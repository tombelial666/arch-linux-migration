# Контекст миграции (из чата Cursor)

Машина: **HP Laptop 15s-fq2xxx**, i3-1115G4, 8 GB RAM, Intel UHD, Wi‑Fi RTL8821CE.

## Решения

| Параметр | Значение |
|----------|----------|
| Цель | Чистый Arch, full wipe |
| LUKS | Нет |
| DE | KDE Plasma |
| Secure Boot | Выключить в BIOS |
| Swap | 10 GiB + hibernation (fallback: suspend) |
| Диск для wipe | **nvme0n1** (KIOXIA 256 GB) |
| Не трогать | USB Leef ~32 GB (установщик) |
| Бэкап | Конфиги на main PC; Vault в GitHub `tombelial666/obsidian` |
| ISO | `archlinux-2026.05.01-x86_64.iso`, SHA256 `4af795aab6530e8344553961d0a0e8e84f9622a131ee7d44b0b86b035b2d9ff7` |
| Hostname | `arch-laptop` |
| Username | `tom` |

## Статус — **ЗАВЕРШЕНО** (2026-05-24)

- [x] Бэкап Cursor/VS Code на main PC
- [x] ISO скачан, checksum OK
- [x] Флешка записана, загрузка с USB
- [x] Live: Wi‑Fi, `lsblk`
- [x] Фраза: `Бэкап проверен, destructive actions confirmed`
- [x] Установка Arch, первая загрузка
- [x] Post-install (pacman, Docker, Tailscale, UFW, §10 кроме HDMI)

Подробности проверки: [MIGRATION-DONE.md](MIGRATION-DONE.md).

## В Live без Cursor

Клонировать этот репо на main PC или читать **LIVE-CHEATSHEET.md** с флешки / после `git clone` в Live (если есть сеть).

## Файлы в репо

См. [README.md](README.md) — полный набор чеклистов и [05-install-arch.md](05-install-arch.md).
