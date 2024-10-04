
# Mount the root subvolume
mount -o subvol=root,compress=zstd,noatime /dev/mapper/cryptroot /mnt

# Mount the /boot partition
mkdir -p /mnt/boot
mount /dev/vda1 /mnt/boot

# Mount other subvolumes
mkdir -p /mnt/home /mnt/home/archive /mnt/nix /mnt/swap
mount -o subvol=home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home
mount -o subvol=home/archive,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home/archive
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/cryptroot /mnt/nix
mount -o subvol=swap,compress=zstd,noatime /dev/mapper/cryptroot /mnt/swap