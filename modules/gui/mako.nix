{
  home-manager.users.nixos.services.mako = {
    enable = true;

    layer = "top";
    markup = true;
    anchor = "top-right";
    backgroundColor = "#24292e";
    textColor = "#DADAE8";
    width = 450;
    height = 200;
    maxIconSize = 96;
    margin = "20,20,0";
    padding = "15,15,15";
    borderSize = 2;
    borderColor = "#A4B9EF";
    borderRadius = 15;
    progressColor = "over #332E41";
    defaultTimeout = 10000;
    groupBy = "summary";
    format = ''
      <span size="12288">%s</span>\n<span size="12288">%b</span>
    '';
  };
}
