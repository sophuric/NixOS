#include <linux/stat.h>
#include <linux/fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <dirent.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <ctype.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <stdbool.h>

#include "sophutil/src/hashmap.h"
#include "sophutil/src/fnv1_32.h"

#define eprintf(...) fprintf(stderr, __VA_ARGS__)

#ifndef __NR_statx
#define __NR_statx -1
#endif

// statx wasn't defined for me for some reason
static ssize_t statx_own(int dfd, const char *filename, unsigned flags,
                         unsigned int mask, struct statx *buffer) {
	return syscall(__NR_statx, dfd, filename, flags, mask, buffer);
}

int statx_timestamp_compare(struct statx_timestamp a, struct statx_timestamp b) {
	if (a.tv_sec > b.tv_sec) return 1;
	if (a.tv_sec < b.tv_sec) return -1;
	if (a.tv_nsec > b.tv_nsec) return 1;
	if (a.tv_nsec < b.tv_nsec) return -1;
	return 0;
}

static int timestamp_compare_direction;
static mode_t allowed_file_types[64] = {0};
static int allowed_file_types_len = 0;
static unsigned int date_type;
static size_t date_offset;
static long long maxdepth;
static bool follow_symlink;
static struct statx_timestamp latest_file_time = {0};
static const char *latest_file_path = NULL;

static const mode_t allowed_file_types_keys[] = {
        ['b'] = S_IFBLK,
        ['c'] = S_IFCHR,
        ['d'] = S_IFDIR,
        ['p'] = S_IFIFO,
        ['f'] = S_IFREG,
        ['l'] = S_IFLNK,
        ['s'] = S_IFSOCK};

int process_file(long long depth, const char *path);

bool parse_bool(const char *str, bool *out) {
	if (
	        strcmp(str, "true") == 0 ||
	        strcmp(str, "yes") == 0 ||
	        strcmp(str, "y") == 0 ||
	        strcmp(str, "1") == 0) {
		*out = true;
		return true;
	}
	if (
	        strcmp(str, "false") == 0 ||
	        strcmp(str, "no") == 0 ||
	        strcmp(str, "n") == 0 ||
	        strcmp(str, "0") == 0) {
		*out = false;
		return true;
	}
	return false;
}

struct hashmap *processed_files;
int free_file(struct hashmap_entry *entry, void *ctx) {
	free(entry->key);
	return 0;
}
bool equals_file(struct hashmap *hm, void *key1, void *key2) {
	if (key1 == key2) return true;
	if (!key1 || !key2) return false;
	return strcmp(key1, key2) == 0;
}
size_t hash_file(struct hashmap *hm, void *key) {
	if (!key) return 0;
	return fnv1_32_hash_str(key);
}

int main(int argc, const char **argv) {
	if (argc < 6) {
		eprintf("Usage: %s <first|latest> <date: create|access|modify|change> <type mask: any combination of bcdpfls> <max depth> <follow symlink: true|false> <files|directories>...\n"
		        "\n"
		        "Finds the first|latest file in a directory given by their date.\n"
		        "Only searches for files of a type in the mask, that are in the file/directory list, to a given maximum depth."
		        "\n"
		        "  b: block (buffered) special\n"
		        "  c: character (unbuffered) special\n"
		        "  d: directory\n"
		        "  p: named pipe (FIFO)\n"
		        "  f: regular file\n"
		        "  l: symbolic link\n"
		        "  s: socket\n"
		        "\n"
		        "-1 for infinite max depth\n"
		        "\n",
		        argv[0]);
		return 2;
	}

#define invalid_usage(...)    \
	{                         \
		eprintf(__VA_ARGS__); \
		return 2;             \
	}

	if (strcmp(argv[1], "first") == 0)
		timestamp_compare_direction = -1;
	else if (strcmp(argv[1], "latest") == 0)
		timestamp_compare_direction = 1;
	else
		invalid_usage("argument 1 must be <first|latest>\n");

	if (strcmp(argv[2], "create") == 0)
		date_type = STATX_BTIME, date_offset = offsetof(struct statx, stx_btime);
	else if (strcmp(argv[2], "access") == 0)
		date_type = STATX_ATIME, date_offset = offsetof(struct statx, stx_atime);
	else if (strcmp(argv[2], "modify") == 0)
		date_type = STATX_MTIME, date_offset = offsetof(struct statx, stx_mtime);
	else if (strcmp(argv[2], "change") == 0)
		date_type = STATX_CTIME, date_offset = offsetof(struct statx, stx_ctime);
	else
		invalid_usage("argument 2 must be <create|access|modify|change>\n");

	// set allowed file types
	for (const char *str = argv[3]; *str; ++str) {
		if (allowed_file_types_len >= sizeof(allowed_file_types) / sizeof(*allowed_file_types)) invalid_usage("too many file types specified\n");
		if (*str >= sizeof(allowed_file_types_keys) / sizeof(*allowed_file_types_keys) || !allowed_file_types_keys[*str])
			invalid_usage("invalid file type '%c'\n", *str);
		allowed_file_types[allowed_file_types_len++] = allowed_file_types_keys[*str];
	}

	// parse maxdepth int
	char *endptr;
	maxdepth = strtoll(argv[4], &endptr, 10);
	if (maxdepth == LLONG_MIN || maxdepth == LLONG_MAX || maxdepth < -1) invalid_usage("invalid number for argument 4\n");
	for (; *endptr; ++endptr)
		if (!isspace(endptr)) invalid_usage("invalid number for argument 4\n");

	if (!parse_bool(argv[5], &follow_symlink)) invalid_usage("argument 5 is not a boolean\n");

	int res;
#define EXIT(code)    \
	{                 \
		res = code;   \
		goto cleanup; \
	}

	if (follow_symlink) {
		processed_files = hashmap_create(MALLOC_SET_DEFAULT, 16384, equals_file, hash_file);
		if (!processed_files) EXIT(1);
	}

	// loop files/directories
	for (int arg_i = 6; arg_i < argc; ++arg_i) {
		const char *path = argv[arg_i];

		res = process_file(0, path);
		if (res) EXIT(res);
	}

	if (!latest_file_path)
		EXIT(3);
	puts(latest_file_path);
	EXIT(0);
cleanup:
	if (processed_files) {
		hashmap_loop_entries(processed_files, free_file, nullptr);
		hashmap_free(processed_files);
	}
	return res;
}

#if defined(WIN32) || defined(_WIN32)
#define PATH_SEPARATOR '\\'
#else
#define PATH_SEPARATOR '/'
#endif

int process_file(long long depth, const char *path) {
	char *new_path;
	if (follow_symlink) {
		new_path = realpath(path, NULL);
		if (!new_path) {
			eprintf("realpath: %s: %s\n", path, strerror(errno));
			return 0;
		}
		path = new_path;

		// skip if already processed
		if (hashmap_get_entry(processed_files, (char *) path)) return 0;

		// use this for new pointer instead
		size_t size = strlen(path) + 1;
		new_path = malloc(size);
		if (!new_path) {
			eprintf("malloc: %s\n", strerror(errno));
			return 1;
		}
		memcpy(new_path, path, size);

		struct hashmap_entry *entry = hashmap_get_or_create_entry(processed_files, new_path);
		if (!entry) {
			free(new_path);
			eprintf("malloc: %s\n", strerror(errno));
			return 1;
		}
	}

	struct statx st;
	if (statx_own(AT_FDCWD, path, AT_SYMLINK_NOFOLLOW | AT_STATX_FORCE_SYNC, STATX_TYPE | date_type, &st)) {
		eprintf("statx: %s: %s\n", path, strerror(errno));
		return 0;
	}

	// if directory
	if ((st.stx_mode & S_IFMT) == S_IFDIR && (maxdepth == -1 || depth < maxdepth)) {
		DIR *dir = opendir(path);
		if (!dir) {
			eprintf("opendir: %s: %s\n", path, strerror(errno));
			return 0;
		}

		// loop dir
		struct dirent *ent;
		while (ent = readdir(dir)) {
			if (ent->d_name[0] == '.' && ent->d_name[1] == '\0') continue;
			if (ent->d_name[0] == '.' && ent->d_name[1] == '.' && ent->d_name[2] == '\0') continue;

			// append path
			size_t path_len = strlen(path),
			       entry_name_len = strlen(ent->d_name),
			       child_path_size = path_len + entry_name_len + 2;
			char *child_path = malloc(child_path_size);
			if (!child_path) {
				eprintf("malloc: %zu: %s\n", child_path_size, strerror(errno));
				closedir(dir);
				return 1;
			}

			size_t i = 0;
			memcpy(&child_path[i], path, path_len);
			i += path_len;
			if (i == 0 || child_path[i - 1] != PATH_SEPARATOR)
				child_path[i++] = PATH_SEPARATOR;
			memcpy(&child_path[i], ent->d_name, entry_name_len);
			i += entry_name_len;
			child_path[i++] = '\0';

			int res = process_file(depth + 1, child_path);
			free(child_path);
			if (res) {
				closedir(dir);
				return res;
			}
		}

		closedir(dir);
	}

	for (int i = 0; i < allowed_file_types_len; ++i) {
		if ((st.stx_mode & S_IFMT) == allowed_file_types[i]) {
			struct statx_timestamp ts = *(struct statx_timestamp *) (((void *) &st) + date_offset); // cursed shit
			if (!latest_file_path || statx_timestamp_compare(ts, latest_file_time) == timestamp_compare_direction) {
				latest_file_time = ts;
				latest_file_path = path;
			}
			return 0;
		}
	}
	return 0;
}
