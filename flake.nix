{
  nixConfig = {
    extra-substituters = [
      "https://cosmic.cachix.org/"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-cosmic,
      ...
    }:
    {
      nixosConfigurations.cosmic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-cosmic.nixosModules.default
          {
            networking.hostName = "hello-cosmic";
            # cosmic
            services.xserver.enable = true;
            services.desktopManager.cosmic.enable = true;
            services.displayManager.cosmic-greeter.enable = true;
            # user initialization
            users.users.honnip = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              initialPassword = "asdf";
            };
            # better vm setting
            virtualisation.vmVariant = {
              virtualisation = {
                memorySize = 4096;
                cores = 4;
                resolution = {
                  x = 1920;
                  y = 1080;
                };
                qemu.options = [
                  # "-vga virtio" # does not work on my machine
                  "-display gtk,zoom-to-fit=false"
                ];
              };
            };
            system.stateVersion = "24.05";
          }
        ];
      };
    };
}
