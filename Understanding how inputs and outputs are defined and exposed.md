# Understanding `inputs` and `outputs` in flake.nix

This document explains how `inputs` and `outputs` are defined and exposed in your `flake.nix`.

---

## Inputs

**Inputs** are external dependencies (other flakes or resources) your flake uses.
They are defined in the `inputs = { ... }` section.

**Example:**
```nix
inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";
inputs.hardware.url = "github:NixOS/nixos-hardware/master";
# ...and many more
```

Inputs can also follow other inputs, e.g.:
```nix
inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
```

---

## Outputs

**Outputs** are what your flake provides to the outside world (NixOS configs, packages, devShells, etc).
They are defined in the `outputs = { ... }@inputs: let ... in rec { ... }` block.

**Example:**
```nix
outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    # ...
  in
  rec {
    # ... outputs here ...
  }
```

---

## How Inputs and Outputs Are Exposed

- The `outputs` function receives all resolved inputs as arguments (`inputs`).
- You can pass `inputs` and `outputs` to NixOS and Home Manager modules via `specialArgs` or `extraSpecialArgs`:
    ```nix
    mkNixos = modules:
      nixpkgs.lib.nixosSystem {
        inherit modules;
        specialArgs = { inherit inputs outputs; };
      };

    mkHome = modules: pkgs:
      home-manager.lib.homeManagerConfiguration {
        inherit modules pkgs;
        extraSpecialArgs = { inherit inputs outputs; };
      };
    ```
- This makes `inputs` and `outputs` available as variables inside your modules.

---

## Example Usage

**In a NixOS configuration:**
```nix
nixosConfigurations = {
  khawlah = mkNixos [
    ./nixos/host-khawlah.nix
  ];
};
```
Inside `./nixos/host-khawlah.nix`, you can access `inputs` and `outputs` if needed.

**In a Home Manager configuration:**
```nix
homeConfigurations = {
  "najib@khawlah" = mkHome [./home-manager/user-najib/host-khawlah] nixpkgs.legacyPackages."x86_64-linux";
};
```
Inside `./home-manager/user-najib/host-khawlah`, you can also access `inputs` and `outputs`.

---

## Summary Table

| What      | Where Defined         | How Used/Exposed                  |
|-----------|----------------------|-----------------------------------|
| **inputs**  | `inputs = { ... }`    | Passed to outputs, modules via `specialArgs` |
| **outputs** | `outputs = { ... }`   | Built using inputs, exposed as flake outputs |

---

## Useful Commands

- `nix flake info` — Show all inputs and their revisions.
- `nix flake show` — Show outputs provided by the flake.
- `nix flake update` — Update all inputs.
- `nix flake check` — Check the flake for errors.

---

*Generated from your current flake.nix structure.*