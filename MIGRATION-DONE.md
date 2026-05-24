# Миграция завершена

**Машина:** HP Laptop 15s-fq2xxx (`arch-laptop`)  
**Пользователь:** `tom`  
**Завершено:** 2026-05-24  
**ОС:** Arch Linux, kernel 7.0.9-arch2-1, KDE Plasma 6.6.5

## Параметры установки

| Параметр | Значение |
|----------|----------|
| Hostname | `arch-laptop` |
| DE | KDE Plasma (Wayland) |
| LUKS | Нет |
| Диск | `/dev/nvme0n1` — EFI 1G, swap 10G, root ext4 ~227G |
| Timezone | `Asia/Bangkok` |
| Secure Boot | Выключен (установка прошла) |

## Проверка §10 (2026-05-24)

| Пункт | Результат |
|-------|-----------|
| Wi‑Fi | OK — `wlo1`, RTL8821CE, 5 GHz |
| Bluetooth | OK — контроллер `arch-laptop` |
| Звук (PipeWire) | OK — PulseAudio on PipeWire 1.6.5 |
| Камера | OK — HP TrueVision HD (`/dev/video0`) |
| HDMI | **Не проверен** — внешний дисплей не подключён; только `eDP-1` 1920×1080 |
| Tailscale | OK — `arch-laptop` online; **main PC offline** в mesh (ping когда включишь) |
| Docker | OK — `docker run hello-world` |
| Suspend | OK — `systemd-suspend.service` enabled |
| Hibernate | Swap + `resume` в mkinitcpio; **не тестировали** — fallback: suspend (`s2idle`) |

## Софт (факт)

- **pacman:** plasma, firefox, telegram-desktop, docker, tailscale, remmina, tlp, ufw, reflector, git, nodejs, npm…
- **Cursor:** AppImage (не AUR)
- **yay / Chrome / Obsidian AUR:** не ставили — firefox + `~/Obsidian` при необходимости
- **the-office:** `~/the-office`, `.env` есть; см. [scripts/bootstrap-the-office.sh](scripts/bootstrap-the-office.sh)

## Опционально / вручную

- [ ] HDMI — подключить кабель, `kscreen-doctor -o` или System Settings → Display
- [ ] Tailscale ping main PC — когда main PC в сети: `tailscale ping <hostname>`
- [ ] Hibernate — `systemctl hibernate` или mask по [07-post-install-packages.md](07-post-install-packages.md) §7

Все этапные чеклисты в репо отмечены выполненными. Этот файл — единая точка правды.
