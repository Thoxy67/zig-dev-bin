#!/bin/bash

echo ''
echo '                                     z'
echo '                                  zzz'
echo '                             zzzzzz'
echo 'zzzzzzzzzzz  zzzzzzzzzzzzzzzzzzzz  zzz'
echo 'zzzzzzzzz  zzzzzzzzzzzzzzzzzzzz  zzzzz'
echo 'zzzzzzz  zzzzzzzzzzzzzzzzzzzz  zzzzzzz'
echo 'zzzzz                zzzzzz      zzzzz'
echo 'zzzzz              zzzzzz        zzzzz'
echo 'zzzzz            zzzzzz          zzzzz'
echo 'zzzzz          zzzzzz            zzzzz'
echo 'zzzzz        zzzzzz              zzzzz'
echo 'zzzzz      zzzzzz                zzzzz'
echo 'zzzzzzz  zzzzzzzzzzzzzzzzzzzz  zzzzzzz'
echo 'zzzzz  zzzzzzzzzzzzzzzzzzzz  zzzzzzzzz'
echo 'zzz  zzzzzzzzzzzzzzzzzzzz  zzzzzzzzzzz'
echo '   zzzzzz'
echo ' zzz'
echo 'z'
echo ''

echo "⚡ zig-dev-bin Archlinux PKGBUILD builder"
echo ''

show_help() {
	echo "Usage: $0 [--force]"
	echo "    --force   Force the installation/update"
}

if ! command -v pacman >/dev/null 2>&1; then
  echo -e "\033[1;31mError:\033[0m This script is only for Arch Linux systems" >&2
  exit 1
fi

while [[ $# -gt 0 ]]; do
	case "$1" in
	--force)
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

exit_clean() {
  echo "Clean up install files..."
  sleep 2
  rm -rf ./zig-dev-bin-*.tar.zst
  rm -rf ./PKGBUILD
  rm -rf ./pkg
  echo "Done!"
}

install_zig() {
	read -r -p "Do you want to install/update Zig? (y/n) " answer
	if [[ "$answer" =~ ^[Yy]$ ]]; then
    if [ -f "$FILE" ]; then
      makepkg -si
    else
      wget -q "https://raw.githubusercontent.com/Thoxy67/zig-dev-bin/main/PKGBUILD" -O "PKGBUILD" &
      wait
      trap exit_clean SIGINT
      makepkg -si
      exit_clean() 
    fi
    makepkg -si
	else
		exit 0
	fi
}

json=$(curl -s https://ziglang.org/download/index.json)
version=$(echo "$json" | jq -r '.master.version' | tr '-' '_')
sed -i "s/^pkgver=.*$/pkgver=${version}/" PKGBUILD

echo "Latest Zig version: v$version"
if command -v zig >/dev/null; then
	installed=$(zig version | tr '-' '_')
	echo "Installed Zig Version: v$installed"
	if [[ "$installed" == "$version" ]]; then
		echo "You have the latest version installed on your machine"
		if [[ "$force" ]]; then
			install_zig
		else
			exit 0
		fi
	else
		echo ""
		echo "🚀 A new Zig version (v$version) is available!"
		install_zig
	fi
else
	install_zig
fi
