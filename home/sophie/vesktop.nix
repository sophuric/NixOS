# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ self, config, pkgs, lib, ... }: {
  catppuccin.vesktop.enable = true;
  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "stable";
      splashColor = "rgb(205, 214, 244)";
      splashBackground = "rgb(30, 30, 46)";
      spellCheckLanguages = [ "en-GB" "en-AU" "en" ];
      audio = {
        granularSelect = false;
        ignoreDevices = false;
      };
      minimizeToTray = false;
      arRPC = false;
    };
    vencord = {
      themes = {
        custom = ''
          :root {
            --font-code: monospace !important;
            --font-primary: sans-serif !important;
            --font-display: sans-serif !important;
            --font-headline: sans-serif !important;
          }
        '';
      };
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = true;
        themeLinks = [
          "https://raw.githubusercontent.com/mekb-turtle/discord-themes/refs/heads/main/no-nitro-annoyances.css"
        ];
        enabledThemes = [ "custom.css" ];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = true;
        winNativeTitleBar = false;
        plugins = {
          AnonymiseFileNames = {
            enabled = true;
            method = 1;
            randomisedLength = 7;
            anonymiseByDefault = true;
            consistent = "file";
          };
          BetterFolders = {
            enabled = true;
            sidebar = false;
            closeAllHomeButton = true;
            sidebarAnim = true;
            closeOthers = false;
            closeAllFolders = false;
            forceOpen = false;
            showFolderIcon = 1;
            keepIcons = false;
          };
          BetterNotesBox = {
            enabled = true;
            hide = true;
            noSpellCheck = false;
          };
          BetterRoleDot = {
            enabled = true;
            bothStyles = false;
            copyRoleColorInProfilePopout = false;
          };
          BlurNSFW = {
            enabled = true;
            blurAmount = 10;
          };
          CallTimer = {
            enabled = true;
            format = "stopwatch";
          };
          Experiments = {
            enabled = true;
            enableIsStaff = false;
            forceStagingBanner = false;
            toolbarDevMenu = false;
          };
          FakeNitro = {
            enabled = true;
            enableEmojiBypass = true;
            enableStickerBypass = true;
            enableStreamQualityBypass = true;
            transformStickers = true;
            transformEmojis = true;
            transformCompoundSentence = true;
            emojiSize = 48;
            stickerSize = 160;
            hyperLinkText = "{{NAME}}";
            useHyperLinks = true;
            disableEmbedPermissionCheck = false;
          };
          FakeProfileThemes = {
            enabled = true;
            nitroFirst = true;
          };
          MemberCount = {
            enabled = true;
            memberList = true;
            toolTip = true;
            voiceActivity = true;
          };
          MessageLinkEmbeds = {
            enabled = true;
            listMode = "blacklist";
            idList = "";
            automodEmbeds = "never";
          };
          MessageLogger = {
            enabled = true;
            deleteStyle = "overlay";
            ignoreBots = false;
            ignoreSelf = false;
            logEdits = true;
            logDeletes = true;
            collapseDeleted = false;
            inlineEdits = true;
          };
          MessageTags = {
            enabled = true;
            clyde = true;
            tagsList = { };
          };
          NoReplyMention = {
            enabled = true;
            shouldPingListed = true;
            inverseShiftReply = false;
          };
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          PlatformIndicators = {
            enabled = true;
            colorMobileIndicator = true;
            list = false;
            badges = false;
            messages = false;
          };
          RelationshipNotifier = {
            enabled = true;
            notices = false;
            offlineRemovals = true;
            friends = true;
            friendRequestCancels = true;
            servers = true;
            groups = true;
          };
          RoleColorEverywhere = {
            enabled = true;
            chatMentions = true;
            memberList = true;
            voiceUsers = true;
            reactorsList = true;
            colorChatMessages = false;
            pollResults = true;
          };
          ServerListIndicators = {
            enabled = true;
            mode = 2;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveActivity";
          };
          ShowHiddenChannels = {
            enabled = true;
            showMode = 0;
            hideUnreads = true;
            defaultAllowedUsersAndRolesDropdownState = true;
          };
          SilentMessageToggle = {
            enabled = true;
            persistState = false;
          };
          SilentTyping = {
            enabled = true;
            showIcon = false;
            isEnabled = true;
            contextMenu = true;
          };
          SpotifyControls = {
            enabled = true;
            hoverControls = false;
          };
          SpotifyCrack = {
            enabled = true;
            noSpotifyAutoPause = true;
            keepSpotifyActivityOnIdle = false;
          };
          TypingIndicator = {
            enabled = true;
            includeMutedChannels = false;
            includeBlockedUsers = false;
            includeCurrentChannel = true;
            indicatorMode = 3;
          };
          TypingTweaks = {
            enabled = true;
            alternativeFormatting = true;
            showRoleColors = true;
            showAvatars = true;
          };
          UserVoiceShow = {
            enabled = true;
            showInUserProfileModal = true;
            showInMemberList = true;
            showInMessages = true;
          };
          VcNarrator = {
            enabled = true;
            volume = 1;
            rate = { };
            sayOwnName = true;
            latinOnly = false;
            joinMessage = "{{USER}} joined";
            leaveMessage = "{{USER}} left";
            moveMessage = "{{USER}} moved to {{CHANNEL}}";
            muteMessage = "{{USER}} muted";
            unmuteMessage = "{{USER}} un muted";
            deafenMessage = "{{USER}} deaf aned";
            undeafenMessage = "{{USER}} un deaf aned";
          };
          ViewIcons = {
            enabled = true;
            format = "webp";
            imgSize = "1024";
          };
          ViewRaw = {
            enabled = true;
            clickMethod = "Left";
          };
          VolumeBooster = {
            enabled = true;
            multiplier = 2;
          };
          GreetStickerPicker = {
            enabled = true;
            greetMode = "Greet";
          };
          PinDMs = {
            enabled = true;
            pinOrder = 0;
            sortDmsByNewestMessage = false;
            dmSectionCollapsed = false;
            canCollapseDmSection = false;
          };
          SendTimestamps = {
            enabled = true;
            replaceMessageContents = true;
          };
          Translate = {
            enabled = true;
            autoTranslate = false;
            receivedInput = "auto";
            receivedOutput = "en";
            sentInput = "auto";
            sentOutput = "en";
            showChatBarButton = true;
          };
          PermissionsViewer = {
            enabled = true;
            defaultPermissionsDropdownState = true;
            permissionsSortOrder = 0;
          };
          NoPendingCount = {
            enabled = true;
            hideFriendRequestsCount = false;
            hideMessageRequestsCount = false;
            hidePremiumOffersCount = true;
          };
          FavoriteGifSearch = {
            enabled = true;
            searchOption = "hostandpath";
          };
          VoiceMessages = {
            enabled = true;
            echoCancellation = true;
            noiseSuppression = true;
          };
          OnePingPerDM = {
            enabled = true;
            channelToAffect = "both_dms";
            allowMentions = false;
            allowEveryone = false;
          };
          PermissionFreeWill = {
            enabled = true;
            lockout = false;
            onboarding = true;
          };
          NewGuildSettings = {
            enabled = true;
            guild = true;
            messages = 1;
            everyone = false;
            role = false;
            highlights = true;
            events = true;
            showAllChannels = true;
          };
          BetterSettings = {
            enabled = true;
            disableFade = true;
            organizeMenu = true;
            eagerLoad = true;
          };
          "Paste.rs".enabled = true;
          ShowHiddenThings = {
            enabled = true;
            showTimeouts = true;
            showInvitesPaused = true;
            showModView = true;
            disableDiscoveryFilters = true;
            disableDisallowedDiscoveryFilters = true;
          };
          BetterSessions = {
            enabled = true;
            backgroundCheck = false;
          };
          ImplicitRelationships = {
            enabled = true;
            sortByAffinity = true;
          };
          MessageLatency = {
            enabled = true;
            latency = 2;
            detectDiscordKotlin = true;
            showMillis = false;
            ignoreSelf = false;
          };
          ConsoleJanitor = {
            enabled = true;
            disableNoisyLoggers = false;
            disableSpotifyLogger = true;
            disableLoggers = false;
            whitelistedLoggers = "GatewaySocket; Routing/Utils";
          };
          MentionAvatars = {
            enabled = true;
            showAtSymbol = true;
          };
          AccountPanelServerProfile = {
            enabled = true;
            prioritizeServerProfile = false;
          };
          UserMessagesPronouns = {
            enabled = true;
            showInMessages = true;
            showSelf = true;
            pronounsFormat = "LOWERCASE";
            showInProfile = true;
            pronounSource = 0;
          };
          ImageFilename = {
            enabled = true;
            showFullUrl = false;
          };
        } // (lib.attrsets.genAttrs [
          "BadgeAPI"
          "CommandsAPI"
          "MemberListDecoratorsAPI"
          "MessageAccessoriesAPI"
          "MessageDecorationsAPI"
          "MessageEventsAPI"
          "MessagePopoverAPI"
          "NoticesAPI"
          "ServerListAPI"
          "SettingsStoreAPI"
          "BetterGifAltText"
          "ClearURLs"
          "CrashHandler"
          "ForceOwnerCrown"
          "iLoveSpam"
          "NoDevtoolsWarning"
          "NoF1"
          "NoUnblockToJump"
          "NSFWGateBypass"
          "StartupTimings"
          "SupportHelper"
          "VoiceChatDoubleClick"
          "VencordToolbox"
          "ValidUser"
          "FavoriteEmojiFirst"
          "NoProfileThemes"
          "UnsuppressEmbeds"
          "MutualGroupDMs"
          "BiggerStreamPreview"
          "NormalizeMessageLinks"
          "PreviewMessage"
          "CopyUserURLs"
          "FixSpotifyEmbeds"
          "NoTypingAnimation"
          "FixImagesQuality"
          "WebKeybinds"
          "BetterGifPicker"
          "FixYoutubeEmbeds"
          "ChatInputButtonAPI"
          "BetterRoleContext"
          "FriendsSince"
          "UnlockedAvatarZoom"
          "ImageLink"
          "PauseInvitesForever"
          "VoiceDownload"
          "WebScreenShareFixes"
          "AutomodContext"
          "DontRoundMyTimestamps"
          "MaskedLinkPaste"
          "NoDefaultHangStatus"
          "ValidReply"
          "MessageUpdaterAPI"
          "ServerInfo"
          "NoOnboardingDelay"
          "UserSettingsAPI"
          "YoutubeAdblock"
          "AlwaysExpandRoles"
          "CopyFileContents"
          "StickerPaste"
          "FullSearchContext"
          "DynamicImageModalAPI"
          "DisableDeepLinks"
          "ExpressionCloner"
          "CopyStickerLinks"
        ] (x: { enabled = true; }));
        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "always";
          logLimit = 50;
        };
        notifyAboutUpdates = false;
        macosTranslucency = false;
        eagerPatches = false;
      };
    };
  };
}
