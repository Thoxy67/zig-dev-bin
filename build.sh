#!/bin/bash

echo -e '\e[93m                                     z'
echo -e '                                  zzz'
echo -e '                             zzzzzz\e[90m'
echo -e '\e[90mzzzzzzzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzz'
echo -e '\e[90mzzzzzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzz'
echo -e '\e[90mzzzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzzzz'
echo -e '\e[90mzzzzz                \e[93mzzzzzz      \e[90mzzzzz'
echo -e '\e[90mzzzzz              \e[93mzzzzzz        \e[90mzzzzz'
echo -e '\e[90mzzzzz            \e[93mzzzzzz          \e[90mzzzzz'
echo -e '\e[90mzzzzz          \e[93mzzzzzz            \e[90mzzzzz'
echo -e '\e[90mzzzzz        \e[93mzzzzzz              \e[90mzzzzz'
echo -e '\e[90mzzzzz      \e[93mzzzzzz                \e[90mzzzzz'
echo -e '\e[90mzzzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzzzz'
echo -e '\e[90mzzzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzzzzzz'
echo -e '\e[90mzzz  \e[93mzzzzzzzzzzzzzzzzzzzz  \e[90mzzzzzzzzzzz'
echo -e '   \e[93mzzzzzz'
echo -e ' zzz'
echo -e 'z\e[0m'

echo -e "\n⚡ \e[1mzig-dev-bin\e[0m Archlinux PKGBUILD builder\n"

show_help() {
	echo "Usage: $0 [-f, --force]"
	echo -e "\t-f, --force\tForce the installation/update"
  echo -e "\t-h, --help\tPrint help"
}

if ! command -v pacman >/dev/null 2>&1; then
  echo -e "\033[1;31mError:\033[0m \e[1mBy the way,\e[0m this script is only intended for \e[1mArch Linux\e[0m systems. ❤️" >&2
  exit 1
fi

while [[ $# -gt 0 ]]; do
	case "$1" in
	-f | --force)
		force=1
		shift
		;;
	-h | --help)
		show_help
		exit 0
		;;
	*)
		echo "Unknown option: $1"
		show_help
		exit 1
		;;
	esac
done

abord() {
  echo ""
  sleep 1
  clean
  echo -e "❌ Installation aborted !"
  exit 1
}

clean() {
  echo -e "🧹 Clean up install files..."
  if [[ "$remote_url" != "https://github.com/Thoxy67/zig-dev-bin"* ]]; then
    rm -rf ./PKGBUILD
    cd ..
    rm -rf ./zig_install_tmp
  fi
  rm -rf ./zig-dev-bin-*.tar.zst
  rm -rf ./pkg
}

succeed() {
  echo ""
  sleep 2
  clean
  echo "✔️  installation succeed"
  exit 0
}

install_zig() {
  read -r -p "📦 Do you want to install/update Zig? (y/n) " answer
	if [[ "$answer" =~ ^[Yy]$ ]]; then
    if [ -f "PKGBUILD" ]; then
      sed -i "s/^pkgver=.*$/pkgver=${version}/" PKGBUILD
      makepkg -si
    else
      mkdir ./zig_install_tmp
      cd ./zig_install_tmp
      wget -q "https://raw.githubusercontent.com/Thoxy67/zig-dev-bin/main/PKGBUILD" -O "PKGBUILD"
      sed -i "s/^pkgver=.*$/pkgver=${version}/" PKGBUILD
      makepkg -si
      succeed
    fi
	else
		exit 0
	fi
}

json=$(curl -s https://ziglang.org/download/index.json)
version=$(echo "$json" | jq -r '.master.version' | tr '-' '_')

echo "Latest Zig version: v$version"
if command -v zig >/dev/null; then
	installed=$(zig version | tr '-' '_')
	echo -e "Installed Zig Version: \e[1mv$installed\e[0m"
	if [[ "$installed" == "$version" ]]; then
		echo -e "\n\e[0;42mYou have the latest Zig version installed on your machine\033[0m"
    if [[ "$force" ]]; then
      trap abord SIGINT
			install_zig
		else
      echo -e "\033[36mToo force install just pass argument : \e[0m--force\n"
			exit 0
		fi
	else
    echo -e "\n\e[33m🆕 A new Zig version (v$version) is available!\e[0m\n"
    trap abord SIGINT
    install_zig
	fi
else
  echo -e "\e[0;43mIt seems like Zig is not installed on your computer.\e[0m\n"
  trap abord SIGINT
	install_zig
fi
