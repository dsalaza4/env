{ inputs, modules }:
{
  personal = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      ./personal
      { home-manager.sharedModules = modules.sharedModules; }
    ]
    ++ modules.darwinSharedModules;
    specialArgs = {
      inherit inputs;
      primaryUser = {
        email = "podany270895@gmail.com";
        name = "Daniel Salazar";
        username = "dsalazar";
      };
    };
  };
  work = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      ./work
      { home-manager.sharedModules = modules.sharedModules; }
    ]
    ++ modules.darwinSharedModules;
    specialArgs = {
      inherit inputs;
      primaryUser = {
        email = "dsalazar@fluidattacks.com";
        name = "Daniel Salazar";
        username = "dsalazar";
      };
    };
  };

  test = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [ ./test ];
    specialArgs = { inherit inputs; };
  };
}
