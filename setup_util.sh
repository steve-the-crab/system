#! /bin/sh

# fns
get_uuid_of_device() {
    # Get the UUID of the root partition directly using blkid
    uuid=$(blkid -s UUID -o value $device)

    # Check if the UUID was successfully retrieved
    if [ -z "$uuid" ]; then
        echo "uuid is unset in get_uuid_of_device(). Exiting..."
        exit 1
    fi

    echo "$uuid"
}

