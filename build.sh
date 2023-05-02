#!/bin/bash

echo "zig-dev-bin Archlinux PKGBUILD builder"
echo

# Define a function to show the help message
show_help() {
	echo "Usage: $0 [--force]"
	echo "    --force   Force the installation/update"
}

# Parse the arguments
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

install_zig() {
	echo "Do you want to install/update Zig? (y/n)"
	read -r answer

	if [ "$answer" != "${answer#[Yy]}" ]; then
		makepkg -si
	else
		exit 0
	fi
}

json=$(curl -s https://ziglang.org/download/index.json)

version=$(echo "$json" | jq -r '.master.version' | tr '-' '_')
sed -i "s/^pkgver=.*$/pkgver=${version}/" PKGBUILD

echo "Latest Zig version: v$version"
if which zig >/dev/null; then
	installed=$(zig version | tr '-' '_')
	echo "Installed Zig Version: v$installed"
	if [ "$installed" == "$version" ]; then
		printf "\nYou have the latest version installed on your machine\n"
		if [[ "$force" ]]; then
			install_zig
		else
			exit 0
		fi
	else
		install_zig
	fi
else
	install_zig
fi


