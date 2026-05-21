# Этап 7 — Установка Arch Linux

## БЛОКИРОВКА

Выполнять **только** если:

1. Пройден [04-preinstall-checklist.md](04-preinstall-checklist.md)
2. Ты явно подтвердил: **`Бэкап проверен, destructive actions confirmed`**

---

## Подтверждение перед DESTRUCTIVE

```
[ ] Бэкап проверен на основном ПК
[ ] wipe только nvme0n1 (KIOXIA 256GB), НЕ USB Leef
[ ] Wi-Fi работает в Live USB
[ ] Secure Boot выключен
```

---

## Шаг 0 — Загрузка с Arch ISO

1. Boot Menu на HP (обычно **F9** или **Esc** → Boot Device Options).
2. Выбрать USB **Leef iBridge** (не NVMe).
3. Arch install medium → **Arch Linux install medium (x86_64, UEFI)**.

---

## Шаг 1 — Live: собрать фактические имена дисков

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MODEL,MOUNTPOINTS
fdisk -l
```

**Ожидаемо на этом ноутбуке:**

| Устройство | Модель | Действие |
|------------|--------|----------|
| `/dev/nvme0n1` | KBG40ZNV256G KIOXIA ~238G | **Только его wipe** |
| `/dev/sda` (или `sdb`) | Leef iBridge ~30G | **Не трогать** — на нём ISO |

Если имена **отличаются** — остановись и перепроверь MODEL в `lsblk`.

Сохрани вывод в файл (для отката/документации).

Скрипт: [06-live-usb-commands.sh](06-live-usb-commands.sh)

---

## Шаг 2 — Подключение к интернету (Live)

```bash
# Проверка Wi-Fi (RTL8821CE)
iwctl
# device list
# station <wlan0> scan
# station <wlan0> get-networks
# station <wlan0> connect <SSID>
# exit

# или после установки NetworkManager — ping
ping -c 3 archlinux.org
```

Если Wi‑Fi не работает — **не переходи к wipe**; решай сеть (tethering / ethernet).

---

## Шаг 3 — DESTRUCTIVE: разметка `nvme0n1`

**ВНИМАНИЕ:** уничтожает Windows и все данные на внутреннем NVMe.

Подставь только если `lsblk` показал модель **KIOXIA** на `nvme0n1`:

```bash
# Проверка ещё раз
lsblk -d -o NAME,SIZE,MODEL | grep -E 'nvme|NAME'

# ОТМЕНА: если не уверен — Ctrl+C
read -p "Wipe /dev/nvme0n1? type YES: " confirm
[[ "$confirm" == "YES" ]] || { echo "Aborted"; exit 1; }

# DESTRUCTIVE
wipefs -a /dev/nvme0n1
sgdisk -z /dev/nvme0n1
sgdisk -n 1:0:+1G -t 1:ef00 -c 1:"EFI" /dev/nvme0n1
sgdisk -n 2:0:+10G -t 2:8200 -c 2:"swap" /dev/nvme0n1
sgdisk -n 3:0:0 -t 3:8300 -c 3:"root" /dev/nvme0n1

mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

Запомни **UUID swap** для hibernation:

```bash
SWAP_UUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
echo "SWAP_UUID=$SWAP_UUID"   # понадобится в arch.conf
```

---

## Шаг 4 — Установка базовой системы

```bash
pacstrap -K /mnt base base-devel linux linux-firmware linux-headers \
  networkmanager pipewire pipewire-pulse pipewire-alsa wireplumber \
  bluez bluez-utils openssh sudo vim git

genfstab -U /mnt >> /mnt/etc/fstab
```

---

## Шаг 5 — chroot и настройка

```bash
arch-chroot /mnt

# Локаль и время (подставь свои)
ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# Hostname / пользователь
echo "arch-laptop" > /etc/hostname
# Замени YOURUSER и пароль
useradd -m -G wheel -s /bin/bash YOURUSER
passwd YOURUSER
EDITOR=nano visudo  # раскомментируй %wheel ALL=(ALL) ALL

# mkinitcpio — hibernation
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems resume fsck)/' /etc/mkinitcpio.conf

# systemd-boot
bootctl install
ROOT_UUID=$(blkid -s UUID -o value /dev/nvme0n1p3)
SWAP_UUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
cat > /boot/loader/loader.conf <<EOF
default arch.conf
timeout 3
editor  no
EOF
mkdir -p /boot/loader/entries
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=${ROOT_UUID} rw resume=UUID=${SWAP_UUID} loglevel=3 quiet
EOF

systemctl enable NetworkManager bluetooth sshd

passwd root
mkinitcpio -P
exit
```

---

## Шаг 6 — Завершение

```bash
umount -R /mnt
swapoff -a
reboot
```

Снять USB при перезагрузке.

---

## Шаг 7 — После первой загрузки

См. [07-post-install-packages.md](07-post-install-packages.md).

Проверки:

```bash
# Wi-Fi
nmcli device wifi list
# Bluetooth
bluetoothctl show
# Hibernation (опционально)
cat /sys/power/disk   # должен содержать swap
systemctl hibernate   # только после теста suspend; fallback — отключить
```

---

## Откат

Полного image нет. Откат = только файлы с основного ПК + переустановка Windows с Media Creation Tool на Microsoft (если понадобится Windows снова).
