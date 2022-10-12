{pkgs, ...}:
{  
  users.users.dsalazar = {
    isNormalUser = true;
    hashedPassword = "$6$Cmzt0OYRh1Ra9nCG$52hnMtWek1aWFbCN44T9AmZrFVws4Lus7vvOObgnJWpCtIJs.v0mUYW/3a4SFm3kOxJbbV/xaYoAu9S9Wc8lb0";
    description = "Daniel Salazar";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      bash
      direnv
      git
      kubectl
      google-chrome
      sops
      vim
      vscode
      yakuake
    ];
  };
}