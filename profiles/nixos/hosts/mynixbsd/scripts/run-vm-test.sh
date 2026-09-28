#!/usr/bin/env bash
# File: profiles/nixos/hosts/mynixbsd/scripts/run-vm-test.sh
#
# Usage:
#   ./profiles/nixos/hosts/mynixbsd/scripts/run-vm-test.sh mynixbsd disko
#   ./profiles/nixos/hosts/mynixbsd/scripts/run-vm-test.sh mynixbsd install
#   ./profiles/nixos/hosts/mynixbsd/scripts/run-vm-test.sh mynixbsd vm
#   ./profiles/nixos/hosts/mynixbsd/scripts/run-vm-test.sh
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"

HOST_TARGET="${1:-mynixbsd}"
MODE="${2:-vm}" # Pilihan mod: 'disko', 'install', atau 'vm'

cleanup() {
    local exit_code=$?
    if [ -L "$REPO_DIR/result" ]; then
        rm -f "$REPO_DIR/result"
    fi
    if [ $exit_code -ne 0 ]; then
        echo -e "\n[ERROR] Skrip terhenti dengan kod ralat: $exit_code" >&2
    fi
}
trap cleanup EXIT INT TERM

check_cmd() {
    if ! command -v "$1" &> /dev/null; then
        echo "[ERROR] Perisian '$1' tidak dijumpai dalam PATH." >&2
        exit 1
    fi
}

cd "$REPO_DIR"
check_cmd "nix"

# 1. Semakan & Pemilihan Fail Configuration Disko (Mengutamakan disko-nixbsd.nix)
HOST_DIR="$REPO_DIR/profiles/nixos/hosts/$HOST_TARGET"
if [ -f "$HOST_DIR/disko-nixbsd.nix" ]; then
    DISKO_CONFIG="$HOST_DIR/disko-nixbsd.nix"
    echo "[INFO] Menggunakan konfigurasi Disko NixBSD: $DISKO_CONFIG"
elif [ -f "$HOST_DIR/disko-nixos.nix" ]; then
    DISKO_CONFIG="$HOST_DIR/disko-nixos.nix"
    echo "[INFO] Menggunakan konfigurasi Disko NixOS: $DISKO_CONFIG"
else
    DISKO_CONFIG="$HOST_DIR/disk-config.nix"
    echo "[INFO] Menggunakan konfigurasi Disko standard: $DISKO_CONFIG"
fi

case "$MODE" in
    disko)
        echo "=== [MODE 1] Testing Disko Partitioning & Formatting in QEMU ==="
        nix run github:nix-community/disko -- --mode disko "$DISKO_CONFIG"
        ;;

    install)
        echo "=== [MODE 2] Testing Full Partitioning & Installation on disk.raw ==="
        check_cmd "qemu-img"

        DISK_IMAGE="disk.raw"
        MOUNT_DIR="/tmp/disko-mnt-${HOST_TARGET}"

        if [ -f "$DISK_IMAGE" ]; then
            echo "[INFO] Fail imej cakera '$DISK_IMAGE' sedia wujud."
            read -p "Adakah anda mahu memadam dan menjana semula '$DISK_IMAGE'? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -f "$DISK_IMAGE"
                qemu-img create -f raw "$DISK_IMAGE" 20G
            fi
        else
            echo "Menjana fail imej cakera mentah maya 20GB ($DISK_IMAGE)..."
            qemu-img create -f raw "$DISK_IMAGE" 20G
        fi

        echo "1. Melaksanakan Disko ($DISKO_CONFIG) pada $DISK_IMAGE..."
        nix run github:nix-community/disko -- --mode disko --root-mountpoint "$MOUNT_DIR" "$DISKO_CONFIG" --arg disk '"main"' '"'"$DISK_IMAGE"'"'

        echo "2. Membina System Closure bagi $HOST_TARGET..."
        nix build ".#nixosConfigurations.${HOST_TARGET}.config.system.build.toplevel" --show-trace

        echo "3. Memasang System Closure ke dalam $MOUNT_DIR..."
        mkdir -p "$MOUNT_DIR/nix/store"
        nix-store --query --requisites ./result | xargs cp -t "$MOUNT_DIR/nix/store" -r 2>/dev/null || true

        echo "4. Nyahlekap (Unmount) $MOUNT_DIR..."
        umount -R "$MOUNT_DIR" 2>/dev/null || true
        rmdir "$MOUNT_DIR" 2>/dev/null || true

        echo "Pemasangan NixBSD pada $DISK_IMAGE selesai!"
        ;;

    vm)
        echo "=== [MODE 3] Running Pre-built System VM directly ==="
        nix build ".#nixosConfigurations.${HOST_TARGET}.config.system.build.vm" --show-trace

        VM_RUNNER="./result/bin/run-${HOST_TARGET}-vm"

        if [ ! -x "$VM_RUNNER" ]; then
            echo "[ERROR] Skrip pelancar VM '$VM_RUNNER' tidak wujud." >&2
            exit 1
        fi

        QEMU_MEM_SIZE=4096 "$VM_RUNNER"
        ;;

    *)
        echo "[ERROR] Mod '$MODE' tidak dikenali." >&2
        echo "Penggunaan: $0 <host> [disko|install|vm]" >&2
        exit 1
        ;;
esac
