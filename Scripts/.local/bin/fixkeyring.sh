#!/usr/bin/env bash

# [Fix common keyring / pacman issues on CachyOS / Arch based systems](https://gist.github.com/sm9cc/7422dc6beeffe1a3491a9d29b32fd7bc)

declare -gr PACMAN_PACKAGE="https://mirror.cachyos.org/repo/x86_64/cachyos/pacman-6.0.2-11-x86_64.pkg.tar.zst"
declare -gr ARCHLINUX_KEYRING_PACKAGE="https://archlinux.org/packages/core/any/archlinux-keyring/download/"
declare -gr CACHYOS_KEYRING_PACKAGE="https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-3-1-any.pkg.tar.zst"
declare -gr PACMAN_MIRRORLIST_PACKAGE="https://archlinux.org/packages/core/any/pacman-mirrorlist/download/"
declare -gr CACHYOS_MIRRORLIST_PACKAGE="https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-mirrorlist-17-1-any.pkg.tar.zst"
declare -gr CACHYOS_V3_MIRRORLIST_PACKAGE="https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v3-mirrorlist-17-1-any.pkg.tar.zst"
declare -gr CACHYOS_V4_MIRRORLIST_PACKAGE="https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v4-mirrorlist-5-1-any.pkg.tar.zst"
declare -gr CACHYOS_RATE_MIRRORS_PACKAGE="https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-rate-mirrors-2-2-any.pkg.tar.zst"

function sync_time_date() {
    sudo timedatectl set-ntp true
}

function disable_signature_verification() {
    sudo sed -i 's/^SigLevel\s*=.*/SigLevel = Never/' /etc/pacman.conf
}

function install_packages() {
    yes | sudo pacman -U --noconfirm \
        "${PACMAN_PACKAGE}" \
        "${ARCHLINUX_KEYRING_PACKAGE}" \
        "${CACHYOS_KEYRING_PACKAGE}" \
        "${PACMAN_MIRRORLIST_PACKAGE}" \
        "${CACHYOS_MIRRORLIST_PACKAGE}" \
        "${CACHYOS_V3_MIRRORLIST_PACKAGE}" \
        "${CACHYOS_V4_MIRRORLIST_PACKAGE}" \
        "${CACHYOS_RATE_MIRRORS_PACKAGE}"
}

function enable_signature_verification() {
    sudo sed -i 's/^SigLevel\s*=.*/SigLevel = Required DatabaseOptional/' /etc/pacman.conf
}

function cleanup_gnupg() {
    sudo pkill gpg-agent
    sudo rm -rf /etc/pacman.d/gnupg
}

function initialize_keyring() {
    sudo pacman-key --init
    sudo pacman-key --populate
    sudo pacman-key --refresh-keys
    sudo pacman-key --lsign-key archlinux cachyos
}

function rate_mirrors() {
    sudo cachyos-rate-mirrors
}

function update_package_databases() {
    yes | sudo pacman -Sy --noconfirm
}

function main() {
    sync_time_date
    disable_signature_verification
    install_packages
    enable_signature_verification
    cleanup_gnupg
    initialize_keyring
    rate_mirrors
    update_package_databases
    exit 0
}

main
