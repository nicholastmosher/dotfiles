
DISK=${DISK?' Missing DISK, e.g. /dev/sda'}
DISK_ID=${DISK_ID?' Missing DISK_ID, e.g. /dev/disk/by-id/...'}

set -x

wipefs -a $DISK
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- set 1 boot on
parted $DISK -- mkpart primary 512MiB -8GiB
parted $DISK -- mkpart primary linux-swap -8GiB 100%
mkfs.vfat $DISK_ID-part1

cryptsetup luksFormat $DISK_ID-part2
cryptsetup open --type luks $DISK_ID-part2 crypt

# Create and mount /
zpool create -O mountpoint=none rpool /dev/mapper/crypt
zfs create -p -o mountpoint=legacy rpool/local/root
zfs snapshot rpool/local/root@blank
mount -t zfs rpool/local/root /mnt

# Mount boot partition
mkdir /mnt/boot && mount $DISK_ID-part1 /mnt/boot

# Create and mount /nix
zfs create -p -o mountpoint=legacy rpool/local/nix
mkdir /mnt/nix && mount -t zfs rpool/local/nix /mnt/nix

# Create and mount /home
zfs create -p -o mountpoint=legacy rpool/safe/home
mkdir /mnt/home && mount -t zfs rpool/safe/home /mnt/home

# Create and mount /persist
zfs create -p -o mountpoint=legacy rpool/safe/persist
mkdir /mnt/persist && mount -t zfs rpool/safe/persist /mnt/persist

nixos-generate-config --root /mnt

echo "Please update /mnt/etc/nixos/configuration.nix as needed, then nixos-install"
echo "Recommended additions:"

cat << EOF
{
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "deadbeef";
  networking.networkmanager.enable = true;

  boot.loader.grub = {
    enable = true;
    version =2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };

  boot.initrd.luks.devices = {
   root = {
     device = "$DISK_ID-part2";
     # Required even if not using LVM
     preLVM = true;
   };
  };

  swapDevices = [
    { device = "/dev/disk/by-id/$DISK_ID-part3"; }
  ];
}
EOF

