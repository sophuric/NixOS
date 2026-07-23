# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ self, config, pkgs, lib, ... }: {
  programs.keepassxc = {
    enable = true;
    settings = {
      General.BackupBeforeSave = true;
      Browser.Enabled = true;
      FdoSecrets = {
        Enabled = true;
        NoConfirmDeleteItem = false;
        UnlockBeforeSearch = true;
      };
      GUI = {
        ApplicationTheme = "classic";
        CheckForUpdates = false;
        ColorPasswords = true;
        CompactMode = true;
        HidePasswords = true;
        HidePreviewPanel = false;
        HideToolbar = false;
        HideUsernames = false;
        MinimizeOnClose = true;
        MinimizeOnStartup = true;
        MinimizeToTray = true;
        MonospaceNotes = true;
        MovableToolbar = false;
        ShowExpiredEntriesOnDatabaseUnlock = false;
        ShowTrayIcon = true;
        ToolButtonStyle = 0;
        TrayIconAppearance = "monochrome-light";
      };
      PasswordGenerator = import /root/keepassxc-password-generator.nix;
      SSHAgent.Enabled = true;
      Security = {
        ClearClipboardTimeout = 7;
        IconDownloadFallback = true;
        LockDatabaseIdle = true;
        LockDatabaseIdleSeconds = 120;
        LockDatabaseMinimize = false;
        LockDatabaseScreenLock = true;
        NoConfirmMoveEntryToRecycleBin = false;
      };
    };
  };
}
