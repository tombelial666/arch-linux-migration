# Разбор железа и дисков

Источник: [arch-preinstall-report.txt](arch-preinstall-report.txt), машина `DESKTOP-U5I1UMS`, дата 2026-05-21.

## Ноутбук

| Параметр | Значение |
|----------|----------|
| Производитель / модель | **HP Laptop 15s-fq2xxx** |
| CPU | **Intel Core i3-1115G4** (11th Gen, 2C/4T) |
| RAM | **8 ГБ** (8022668 KiB ≈ 7.65 GiB) |
| GPU | **Intel UHD Graphics** (встроенная) — **NVIDIA нет** |
| BIOS | AMI F.33, 04.10.2023 |
| Прошивка | UEFI, GPT |
| Часовой пояс (Windows) | UTC+7 (Бангкок/Ханой) |

## Сеть и Bluetooth

| Устройство | ID / чип | Заметки для Arch |
|------------|----------|------------------|
| Wi‑Fi | **Realtek RTL8821CE** 802.11ac PCIe | Пакет `linux-firmware`; обычно драйвер **rtw88**; проверить Wi‑Fi в Live USB до wipe |
| Bluetooth | **Realtek Bluetooth 4.2** USB | `bluez`, `bluetoothctl`; firmware из `linux-firmware` |
| VPN (сейчас) | OpenVPN Connect, TAP-Windows | Бэкап профилей `.ovpn`; на Arch: `openvpn` или NetworkManager-openvpn |

## Мультимедиа

| Устройство | Заметки |
|------------|---------|
| Звук | Realtek Audio + Intel Smart Sound |
| Камера | HP TrueVision HD (`USB\VID_30C9`) |
| Внешнее аудио | Focusrite USB (для Linux — пакеты ALSA/PipeWire, отдельная настройка) |

## Диски — ВАЖНО для установки

### Disk 0 — **целевой для Arch (DESTRUCTIVE full wipe)**

| Поле | Значение |
|------|----------|
| Модель | **NVMe KBG40ZNV256G KIOXIA** |
| Размер | **238.47 ГБ** (~256 GB) |
| Номер в Windows | **0** |
| В Linux (ожидаемо) | **`/dev/nvme0n1`** (проверить `lsblk` в Live) |
| Текущие разделы | EFI 200 MB, MSR 16 MB, **C: 237.52 GB NTFS**, Recovery 760 MB |

### Disk 1 — **НЕ ФОРМАТИРОВАТЬ** (флешка под Arch ISO)

| Поле | Значение |
|------|----------|
| Модель | **Leef iBridge 3** (~32 ГБ) |
| Номер | **1** |
| Буква | **D:** |
| В Linux (ожидаемо) | **`/dev/sda`** или **`/dev/sdb`** — **не использовать для разметки ОС** |

## Шифрование и Secure Boot

| Проверка | Результат |
|----------|-----------|
| BitLocker | Секция пустая / cmdlet без прав Admin — **перепроверить от администратора**: `Get-BitLockerVolume` |
| Secure Boot | `Confirm-SecureBootUEFI` — **отказ в доступе** без Admin; в BIOS: **выключить** перед установкой |

## Бэкап: крупные папки пользователя

| Путь | Размер | MUST HAVE? |
|------|--------|------------|
| `C:\Users\Admin\Pictures` | ~259 ГБ в отчёте | **Не бэкапить** — это **iCloud Photos** (заглушка `ReadOnly`, не локальные файлы). После Arch — вход в iCloud |
| `C:\Users\Admin\Downloads` | ~7.3 ГБ | По желанию |
| `C:\Users\Admin\Documents` | ~0.5 ГБ | Да, если есть заметки |
| `C:\Users\Admin\.ssh` | ~0 | Проверить наличие ключей вручную |
| Профиль целиком | ~275 ГБ (рекурсия) | Не копировать вслепую — из‑за Pictures |

## Разметка целевая (256 ГБ NVMe, без LUKS, hibernation)

Ориентир для **~8 ГБ RAM** — swap **≥ 8 ГБ** (лучше **10 ГБ**):

| Раздел | Размер | Тип | Точка монтирования |
|--------|--------|-----|-------------------|
| EFI | 1 GiB | EFI System | `/boot` или `/efi` |
| swap | 10 GiB | Linux swap | hibernation |
| root | остальное (~220 GiB) | Linux x86_64 | `/` ext4 |

**Bootloader:** systemd-boot (одна ОС, проще).

**Hibernation:** `mkinitcpio` hooks `resume`; kernel cmdline `resume=UUID=<swap-uuid>`.

## NVIDIA / hybrid

**Не применимо** — только Intel UHD. Риски proprietary NVIDIA **сняты**. Hibernation по-прежнему может капризничать на KDE/Wayland — запасной план: suspend.

## Следующий шаг

1. [02-backup-checklist.md](02-backup-checklist.md)
2. [04-preinstall-checklist.md](04-preinstall-checklist.md)
3. После подтверждения — [05-install-arch.md](05-install-arch.md)
