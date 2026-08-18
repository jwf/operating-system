#!/bin/bash
# shellcheck disable=SC2155

function haos_pre_image() {
    # rootfs.erofs has grown past the shared 256M SYSTEM_SIZE default
    # (hdd-image.sh) — override here rather than editing the shared script.
    SYSTEM_SIZE=384M

    # HiKey 960: copy DTB into EFI boot partition
    mkdir -p "${BINARIES_DIR}/efi-part/EFI/BOOT"
    mkdir -p "${BINARIES_DIR}/efi-part/hisilicon"
    cp "${BINARIES_DIR}/hi3660-hikey960.dtb" "${BINARIES_DIR}/efi-part/hisilicon/"

    local BOOT_DATA="$(path_boot_dir)"
    local EFIPART_DATA="${BINARIES_DIR}/efi-part"

    mkdir -p "${BOOT_DATA}/EFI/BOOT"

    cp "${BOARD_DIR}/grub.cfg" "${EFIPART_DATA}/EFI/BOOT/grub.cfg"
    cp "${BOARD_DIR}/cmdline.txt" "${EFIPART_DATA}/cmdline.txt"
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" create
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" set ORDER="A B"
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" set A_OK=1
    grub-editenv "${EFIPART_DATA}/EFI/BOOT/grubenv" set A_TRY=0

    cp -r "${EFIPART_DATA}/"* "${BOOT_DATA}/"
}


function haos_post_image() {
    convert_disk_image_xz
}
