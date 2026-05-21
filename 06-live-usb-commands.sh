#!/bin/bash
# Run in Arch Live USB after boot. Saves report to ~/live-report.txt
set -e
OUT=~/live-report.txt
{
  echo "=== $(date) ==="
  echo "--- LSBLK ---"
  lsblk -o NAME,SIZE,TYPE,FSTYPE,UUID,MODEL,MOUNTPOINTS
  echo "--- FDISK ---"
  fdisk -l
  echo "--- PCI (GPU/NET) ---"
  lspci -nnk | grep -A3 -E 'VGA|3D|Network|Audio'
  echo "--- USB ---"
  lsusb
  echo "--- SECURE BOOT ---"
  mokutil --sb-state 2>/dev/null || echo "mokutil N/A"
  echo "--- RFKILL ---"
  rfkill list
  echo "--- MEM ---"
  free -h
  echo "--- EFI ---"
  [ -d /sys/firmware/efi ] && echo "UEFI: yes" || echo "UEFI: no"
} | tee "$OUT"
echo "Saved: $OUT"
echo ""
echo "VERIFY: nvme with MODEL KIOXIA = install target; removable ~30G = USB ISO, DO NOT WIPE"
