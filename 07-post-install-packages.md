# После установки — пакеты и софт

> **Статус:** база установлена на `arch-laptop` / `tom` (2026-05-24). Итог: [MIGRATION-DONE.md](MIGRATION-DONE.md).

Пользователь: `tom`. Сеть: NetworkManager + Tailscale.

## 1. База (pacman)

```bash
sudo pacman -Syu
sudo pacman -S plasma kde-applications konsole dolphin \
  firefox git nodejs npm python docker docker-compose \
  openssh tailscale remmina freerdp openssh \
  tlp ufw reflector

sudo systemctl enable --now tlp docker tailscaled
sudo usermod -aG docker tom
```

## 2. yay (AUR) — осознанный риск

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

AUR только для пакетов ниже, если нет в extra.

| Пакет | AUR / заметка | Факт на arch-laptop |
|-------|----------------|---------------------|
| google-chrome | AUR или Chromium | **firefox** (extra) |
| visual-studio-code-bin | или `cursor-bin` AUR | **Cursor AppImage** |
| obsidian | AUR | папка `~/Obsidian` (при необходимости AUR позже) |
| telegram-desktop | extra | **установлен** |
| slack-desktop | AUR | не ставили |

## 3. Wi‑Fi / BT (HP 15s, RTL8821CE)

Обычно хватает `linux-firmware` из pacstrap. Если нет сети:

```bash
sudo pacman -S linux-firmware rtw89-dkms  # при необходимости по версии ядра
# чаще: modprobe rtw88_8821ce
```

## 4. Tailscale

```bash
sudo tailscale up
# авторизация в браузере
```

## 5. Remmina → основной ПК

```bash
# RDP к Windows main PC
remmina
```

## 6. KDE

```bash
# первый вход — Plasma (Wayland или X11; при проблемах hibernate — сессия X11)
```

## 7. Hibernation

Если `systemctl hibernate` не работает:

```bash
# Fallback: только suspend
sudo systemctl mask systemd-hibernate.service systemd-hybrid-sleep.service
```

Или отладка: https://wiki.archlinux.org/title/Power_management#Hibernation

На `arch-laptop`: swap 10G, `resume` в mkinitcpio — **hibernate не тестировали**, suspend enabled.

## 8. Firewall

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0
sudo ufw enable
```

Скрипт: [scripts/fix-ufw-enable.sh](scripts/fix-ufw-enable.sh).

## 9. reflector (зеркала)

```bash
sudo pacman -S reflector
sudo reflector --country Russia,Thailand,Germany --age 12 --download-timeout 5 --save /etc/pacman.d/mirrorlist
```

Подстрой страны под пинг.

## 10. Проверочный чеклист (2026-05-24)

- [x] Wi‑Fi, Bluetooth
- [x] Звук (PipeWire)
- [x] Камера (`/dev/video0`, HP TrueVision HD)
- [ ] Внешний монитор (HDMI) — **проверить при подключении кабеля**
- [x] Tailscale up (`arch-laptop`); ping main PC — когда main в mesh
- [x] Docker `docker run hello-world`
- [x] Suspend (enabled); hibernate — опционально, не тестировали
