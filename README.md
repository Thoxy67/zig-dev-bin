# Zig Lang PKGBUILD for Archlinux

This PKGBUILD allows you to easily install the latest development version of ⚡
Zig language on Archlinux.

## About Zig Lang

⚡ Zig is a general-purpose programming language designed for robustness,
optimality, and maintainability. It is a compiled statically-typed language with
a syntax that resembles C but with additional features such as type inference,
memory safety, and error handling.

The following links provide information and resources related to the Zig programming language,
a general-purpose language designed for robustness, optimality, and maintainability:

- [Zig official site](https://ziglang.org/): The main website for the Zig programming language.
- [Zig official doc](https://ziglang.org/documentation/master/): The official documentation for the Zig programming language.
- [Zig source code](https://github.com/ziglang/zig): The source code for the Zig programming language, hosted on GitHub.
- [Ziglearn](https://ziglearn.org/): An educational website for learning the Zig programming language.
- [Ziglings](https://github.com/ratfactor/ziglings): Learn the Zig programming language by fixing tiny broken programs. 

## Installation
### Auto

The easiest way to install the latest version of Zig is by running one of the following commands in your terminal:

```
curl -sSf https://raw.githubusercontent.com/Thoxy67/zig-dev-bin/main/build.sh | sh
```

or for a shorter command, use:

```
curl -sSLf https://bit.ly/3HXIb0v | sh
```

These commands will automatically download and install the latest version of Zig on your system.

### Manual

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
