# Arch ISO на флешку (Windows)

**DESTRUCTIVE для флешки Leef** — всё на `D:` будет стёрто. Внутренний диск C: не трогаем.

## 1. Скачать

https://archlinux.org/download/ → `archlinux-x86_64.iso`

Рядом файл `sha256sums` — проверка:

```powershell
cd $env:USERPROFILE\Downloads
Get-FileHash .\archlinux-x86_64.iso -Algorithm SHA256
# сравнить с sha256sums с сайта
```

## 2. Записать (Rufus)

1. Флешка **Leef ~32 GB** (сейчас `D:`)
2. https://rufus.ie — запуск от администратора
3. Устройство: Leef
4. ISO: `archlinux-x86_64.iso`
5. Схема разделов: **GPT**
6. Целевая система: **UEFI (non CSM)**
7. Старт → OK

## 3. Проверка загрузки

1. Перезагрузка → **F9** (HP Boot Menu)
2. Выбрать USB Leef (не KIOXIA NVMe)
3. Arch install medium → UEFI
4. В Live: Wi‑Fi

```bash
# в Live после загрузки
bash /path/to/06-live-usb-commands.sh
# или вручную: lsblk  # убедиться: nvme0n1 = KIOXIA, usb = ISO
```

Wi‑Fi в Live (если нет сети):

```bash
iwctl
# station wlan0 connect <SSID>
ping -c 3 archlinux.org
```

## 4. BIOS

Перезагрузка → **F10** BIOS → **Secure Boot: Disabled** → Save

---

После Wi‑Fi в Live и Secure Boot off напиши:

**`Бэкап проверен, destructive actions confirmed`**

и hostname/username — тогда пошагово [05-install-arch.md](05-install-arch.md).
