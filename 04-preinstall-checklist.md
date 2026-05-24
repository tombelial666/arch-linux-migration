# Этап 6 — Pre-install checklist

> **Статус:** выполнено (установка 2026-05, закрыто в репо 2026-05-24).

## Данные и бэкап

- [x] [02-backup-checklist.md](02-backup-checklist.md) — конфиги на main PC
- [x] Pictures — iCloud, не копируем
- [x] Vault: на GitHub (`tombelial666/obsidian`); перед wipe — по необходимости push
- [x] Фраза перед wipe: **`Бэкап проверен, destructive actions confirmed`**

## Железо и диски

- [x] [arch-preinstall-report.txt](arch-preinstall-report.txt) — собран на Windows (в репо опционально)
- [x] Wipe только **Disk 0** NVMe → Linux **`/dev/nvme0n1`**
- [x] **Не трогать** USB Leef (Disk 1)

## Arch ISO и флешка

- [x] ISO: https://archlinux.org/download/
- [x] SHA256 сверен (`archlinux-2026.05.01-x86_64.iso`)
- [x] **DESTRUCTIVE (флешка):** ISO на Leef 32 ГБ — Rufus, GPT, UEFI
- [x] Загрузка с USB (HP: F9 / Esc → Boot)

## BIOS / Live

- [x] Secure Boot **выкл** в BIOS
- [x] Wi‑Fi в Live USB (RTL8821CE)
- [x] BitLocker нет (Admin: `Get-BitLockerVolume`)

## Параметры установки

- [x] DE: KDE Plasma | LUKS: нет
- [x] Hostname: `arch-laptop`
- [x] Username: `tom`
- [x] Timezone: `Asia/Bangkok`
- [x] Swap: 10 GiB | hibernate: resume hook; suspend проверен, hibernate не тестировали

→ [05-install-arch.md](05-install-arch.md) — выполнено.
