# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  util,
  config,
  pkgs,
  ...
}:
{
  programs.prismlauncher = {
    enable = true;
    package = pkgs.prismlauncher.override {
      jdks = with pkgs; [
        jdk8
        jdk17
        jdk21
        jdk25
      ];
    };
    settings = {
      JvmArgs = "-Xss1M -XX:+UseZGC -XX:+UseCompactObjectHeaders -XX:+AlwaysPreTouch -XX:+UseStringDeduplication";
      ApplicationTheme = "system";
      AutoCloseConsole = false;
      AutomaticJavaDownload = false;
      AutomaticJavaSwitch = true;
      BackgroundCat = "teawie";
      CatFit = "fit";
      CatOpacity = 100;
      TheCat = true;
      CentralModsDir = "/storage/PrismLauncher/mods";
      IconsDir = "/storage/PrismLauncher/icons";
      InstanceDir = "/storage/PrismLauncher/instances";
      SkinsDir = "/storage/PrismLauncher/skins";
      CloseAfterLaunch = false;
      ConfigVersion = 1.3;
      ConsoleFont = util.first config.fonts.fontconfig.defaultFonts.monospace;
      ConsoleFontSize = 11;
      ConsoleMaxLines = 100000;
      ConsoleOverflowStop = true;
      DisableQuiltBeacon = false;
      DownloadsDirWatchRecursive = false;
      IconTheme = "flat_white";
      ShowConsole = false;
      ShowConsoleOnError = true;
      ShowGameTime = true;
      ShowGameTimeWithoutDays = true;
      ShowGlobalGameTime = true;
    };
  };
}
