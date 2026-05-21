# Live USB — шпаргалка (HP 15s-fq2xxx)

**Wipe только `nvme0n1` (KIOXIA). USB Leef не трогать.**

## 1. Диски

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MODEL,MOUNTPOINTS
```

## 2. Wi‑Fi

```bash
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "SSID"
exit
ping -c 3 archlinux.org
```

## 3. DESTRUCTIVE — разметка

```bash
read -p "Wipe /dev/nvme0n1? type YES: " c
[[ "$c" == "YES" ]] || exit 1

wipefs -a /dev/nvme0n1
sgdisk -z /dev/nvme0n1
sgdisk -n 1:0:+1G  -t 1:ef00 -c 1:EFI  /dev/nvme0n1
sgdisk -n 2:0:+10G -t 2:8200 -c 2:SWAP /dev/nvme0n1
sgdisk -n 3:0:0    -t 3:8300 -c 3:ROOT /dev/nvme0n1

mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2 && swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot && mount /dev/nvme0n1p1 /mnt/boot
```

## 4. Установка

```bash
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers \
  networkmanager pipewire pipewire-pulse wireplumber bluez bluez-utils \
  openssh sudo vim git
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
```

В chroot: `Asia/Bangkok`, hostname, user, `mkinitcpio` + `resume=UUID=swap`, systemd-boot — см. **05-install-arch.md**.

## 5. После reboot

**07-post-install-packages.md** — KDE, Tailscale, Docker, yay.
