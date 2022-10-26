{pkgs, ...}: {
  fonts = {
    enableDefaultFonts = false;
    fontDir.enable = true;
    fonts = [
      pkgs.noto-fonts-emoji
      pkgs.twitter-color-emoji
      (pkgs.nerdfonts.override
        {
          fonts = [
            "FiraCode"
          ];
        })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["FiraCode Nerd Font"];
        sansSerif = ["FiraCode Nerd Font"];
        serif = ["FiraCode Nerd Font"];
      };
    };
  };
}
