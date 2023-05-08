# Zig Lang PKGBUILD for Archlinux

This PKGBUILD allows you to easily install the latest development version of ⚡
Zig language on Archlinux.

## About Zig Lang

⚡ Zig is a general-purpose programming language designed for robustness,
optimality, and maintainability. It is a compiled statically-typed language with
a syntax that resembles C but with additional features such as type inference,
memory safety, and error handling.

If you are new to Zig, check out these links to learn more:

- [Zig official site](https://ziglang.org/)
- [Zig official doc](https://ziglang.org/documentation/master/)
- [Zig source code](https://github.com/ziglang/zig)
- [Ziglearn](https://ziglearn.org/)
- [Ziglings](https://github.com/ratfactor/ziglings)

## Installation

To install the latest development version of Zig on your Archlinux system using
this PKGBUILD, follow these steps:

1. Clone the `zig-dev-bin` repository from Github using the following command:

```
git clone https://github.com/Thoxy67/zig-dev-bin.git
```

2. Change your current working directory to the `zig-dev-bin` folder:

```
cd zig-dev-bin
```

3. Run the build.sh script to build and install the package:

```
chmod +x ./build.sh
./build.sh
```

Alternatively, you can build and install the package via makepkg:

```
makepkg -si
```

After installation, you can start using Zig by running the `zig` command in your
terminal.

Note that the `build.sh` script updates the **PKGBUILD** with the latest version
available online using this
[index.json](https://ziglang.org/download/index.json) link before launching
installation.

## Update

To update Zig, run the `build.sh` script again. It will check for updates and
build the new PKGBUILD to proceed with the installation.

## License

This repository is licensed under the MIT License. For more information, see the
[LICENSE](LICENSE) file.
