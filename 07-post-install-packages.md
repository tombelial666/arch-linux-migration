# После установки — пакеты и софт

Пользователь: `YOURUSER`. Сеть: NetworkManager + Tailscale.

## 1. База (pacman)

```bash
sudo pacman -Syu
sudo pacman -S plasma kde-applications konsole dolphin \
  firefox git nodejs npm python docker docker-compose \
  openssh tailscale remmina freerdp openssh \
  tlp ufw reflector

sudo systemctl enable --now tlp docker tailscaled
sudo usermod -aG docker YOURUSER
```

## 2. yay (AUR) — осознанный риск

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

AUR только для пакетов ниже, если нет в extra.

| Пакет | AUR / заметка |
|-------|----------------|
| google-chrome | `google-chrome` AUR или Chromium из extra |
| visual-studio-code-bin | или `cursor-bin` AUR |
| obsidian | AUR |
| telegram-desktop | extra: `telegram-desktop` |
| slack-desktop | AUR |

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

## 8. Firewall

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0
sudo ufw enable
```

## 9. reflector (зеркала)

```bash
sudo pacman -S reflector
sudo reflector --country Russia,Thailand,Germany --age 12 --download-timeout 5 --save /etc/pacman.d/mirrorlist
```

Подстрой страны под пинг.

## 10. Проверочный чеклист

- [ ] Wi‑Fi, Bluetooth
- [ ] Звук (PipeWire)
- [ ] Камера (`pw-top` / KDE Settings)
- [ ] Внешний монитор (HDMI)
- [ ] Tailscale ping main PC
- [ ] Docker `docker run hello-world`
- [ ] Suspend / (опционально) hibernate
