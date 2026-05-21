# Этап 6 — Pre-install checklist

## Данные и бэкап

- [x] [02-backup-checklist.md](02-backup-checklist.md) — конфиги на main PC
- [x] Pictures — iCloud, не копируем
- [ ] Vault: незакоммиченное уехало на GitHub (`git push` при необходимости)
- [ ] Фраза перед wipe: **`Бэкап проверен, destructive actions confirmed`**

## Железо и диски

- [x] [arch-preinstall-report.txt](arch-preinstall-report.txt)
- [x] Wipe только **Disk 0** NVMe → Linux **`/dev/nvme0n1`**
- [x] **Не трогать** USB Leef (Disk 1)

## Arch ISO и флешка

- [ ] ISO: https://archlinux.org/download/
- [ ] SHA256 сверен
- [ ] **DESTRUCTIVE (флешка):** ISO на Leef 32 ГБ — Rufus, GPT, UEFI
- [ ] Загрузка с USB (HP: F9 / Esc → Boot)

## BIOS / Live

- [ ] Secure Boot **выкл** в BIOS
- [ ] Wi‑Fi в Live USB (RTL8821CE)
- [ ] BitLocker нет (Admin: `Get-BitLockerVolume`)

## Параметры установки

- [ ] DE: KDE Plasma | LUKS: нет
- [ ] Hostname: _______________
- [ ] Username: _______________
- [ ] Timezone: `Asia/Bangkok`
- [ ] Swap: 10 GiB | hibernate: да (fallback: suspend)

→ [05-install-arch.md](05-install-arch.md)
