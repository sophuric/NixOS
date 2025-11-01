# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ ... }: {
	services.syncthing = {
		enable = true;
		settings.options.urAccepted = -1;
		overrideDevices = false;
		overrideFolders = false;
		tray.enable = false;
	};
}
