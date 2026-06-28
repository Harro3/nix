# HARRO's nix config

This is my take on the deepest rabbit hole I have ever fallen into, **nix** configuration.

This config is suppose to be my ultimate modular and highly adaptable everyday config as a software engineer.
Its structure follows the dencritic pattern, with wrapped programs and nixos modules.

## Main features

- Multiple host configs in one place with shared nixos modules
- Platform and system agnostic program wrappers
- Secrets management with [sops-nix](https://github.com/Mic92/sops-nix)

## Documentation links

- [Setting up a new host](./doc/setting-up-a-new-host.md)
