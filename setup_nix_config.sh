#! /bin/sh

# params
# Default values
device="unset"
nixos_path="unset"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --device) device="$2"; shift ;;  # --name flag expects a value
        --nixos_path) nixos_path="$2"; shift ;;    # --age flag expects a value
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done



nixos-generate-config --root /mnt

sudo cp *.nix /etc/nixos/

# Get the UUID of the root partition directly using blkid
luksuuid=$(blkid -s UUID -o value $device)
# Check if the UUID was successfully retrieved
if [ -z "$luksuuid" ]; then
    echo "luksuuid is unset. Exiting..."
    exit 1
fi
# echo $luksuuid

# replace the placeholder variable in  /etc/nixos/luks.nix
sudo sed -i "s|/dev/disk/by-uuid/<root_partition>|/dev/disk/by-uuid/$luksuuid|g" /etc/nixos/luks.nix


