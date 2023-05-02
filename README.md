# Zig Lang PKGBUILD for Archlinux

This PKGBUILD allows you to easily install the latest development version of Zig language on Archlinux.

## About Zig Lang

Zig is a general-purpose programming language designed for robustness, optimality, and maintainability. It is a compiled statically-typed language with a syntax that resembles C but with additional features such as type inference, memory safety, and error handling.

If you are new to Zig, check out these links to learn more:

- [Zig official site](https://ziglang.org/)
- [Zig official doc](https://ziglang.org/documentation/master/)
- [Zig source](https://github.com/ziglang/zig)

## Installation

To install the latest development version of Zig, follow these steps:

1. Clone the `zig-dev-bin` repository from Github using the following command:
```
git clone https://github.com/Thoxy67/zig-dev-bin.git
```

2. Change your current working directory to the `zig-dev-bin` folder:
```
cd zig-dev-bin
```

3. Build and install the package via makepkg or with builder (better):

```
chmod +x ./build.sh
./build.sh
```

```
makepkg -si
```
After installation, you can start using Zig by running the `zig` command in your terminal.

## License

This PKGBUILD is licensed under the MIT License. For more information, see the [LICENSE](LICENSE) file.
