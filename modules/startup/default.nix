{
  services.getty.autologinUser = "nixos";
  programs.bash.loginShellInit = ''
    if [ "$(id --user "$USER")" -ge "1000" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';
}
