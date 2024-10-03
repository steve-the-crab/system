#! /bin/sh

# the root device with the lvm, i.e. /dev/vda2
device="unset"
# when we're installing we use /mnt/etc/nixos otherwise /etc/nixos
nixos_path="unset"
username="a"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --device) device="$2"; shift ;;
        --nixos_path) nixos_path="$2"; shift ;;
        --username) username="$3"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done



# gen and copy configs
sudo nixos-generate-config --root /mnt
sudo cp ./nixos-config/*.nix /etc/nixos/
sudo cp -r ./nixos-config/nixpkgs ~/


### replace vars

# root partition luks id
# Get the UUID of the root partition directly using blkid
LUKS_UUID=$(blkid -s UUID -o value $device)
# Check if the UUID was successfully retrieved
if [ -z "$LUKS_UUID" ]; then
    echo "LUKS_UUID is unset. Exiting..."
    exit 1
fi
# echo $LUKS_UUID
sudo sed -i "s|/dev/disk/by-uuid/<root_partition>|/dev/disk/by-uuid/$LUKS_UUID|g" /etc/nixos/luks.nix

# replace username
sudo sed -i "s|<username>|$username|g" /etc/nixos/pkgs_dev.nix

