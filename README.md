# zmk-config

This is my personal ZMK configuration, containing the firmware configuration for all my keyboards.

## Building

This Nix config is inspired/copied from [urob's zmk config](https://github.com/urob/zmk-config). It requires a working nix environment, with direnv/nix-direnv installed (which I set up in my [nix-config](https://github.com/tanordheim/nix-config)).

```sh
# allow direnv for the zmk config checkout, this will set up the build environment using the nix flake
direnv allow

# initialize the Zephyr environment
just init
```
