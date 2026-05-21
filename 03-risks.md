# Этап 4 — Risk assessment (HP 15s-fq2xxx)

Уточнено по [01-hardware-analysis.md](01-hardware-analysis.md).

| Риск | Вероятность | Серьёзность | Проверка заранее | Снижение | Откат |
|------|-------------|-------------|------------------|----------|-------|
| Потеря данных | **Низкая** (Vault на GitHub, Pictures в iCloud) | Критическая только если не запушить Vault / не скопировать конфиги IDE | `git status` в Vault | Push Vault + backup-to-main-pc.ps1 | Clone с GitHub после Arch |
| Стереть USB вместо NVMe | Низкая | Критическая | `lsblk` в Live: ISO на removable | Wipe **только** `nvme0n1`; не трогать `sdX` с ISO | — |
| Нет Wi‑Fi в Live | Средняя | Высокая | RTL8821CE — тест в Live | `linux-firmware`, iwd/NM; USB tether | Документация rtw88 |
| Нет звука | Средняя | Средняя | Realtek + SOF | PipeWire, `sof-firmware`, `alsa-firmware` | — |
| Sleep/hibernate | Средняя | Средняя | 8 GB RAM, Intel only | swap ≥ 8 GB, `resume=`; fallback suspend | Отключить hibernate |
| NVIDIA | **Нет** | — | Только Intel UHD | `mesa`, ядро по умолчанию | — |
| Secure Boot | Низкая | Средняя | BIOS + `mokutil` в Live | Выключить в BIOS | — |
| BitLocker | Низкая | Высокая | `Get-BitLockerVolume` (Admin) | Расшифровать до wipe | — |
| Tailscale / Remmina | Низкая | Средняя | Main PC в tailnet | Установить рано после Arch | — |
| OpenVPN профили | Средняя | Средняя | Бэкап `.ovpn` | `openvpn` / NM plugin | — |
| Батарея / питание | Низкая | Низкая | battery-report.html | `tlp` на HP | — |
| Recovery без image | **Факт** | Высокая | Нет внешнего HDD | Main PC + Git | Переустановка Win с Media Creation Tool |
| AUR / yay | Средняя | Средняя | — | Минимум пакетов из AUR; читать PKGBUILD | Пакеты из extra только |

## Итог для этой машины

- **Vault** — на GitHub; **главное** — конфиги Cursor/VS Code на main PC + при необходимости push незакоммиченного в Vault.
- **NVIDIA-риски сняты** — i3-1115G4, Intel UHD only.
- **Wi‑Fi Realtek** — единственный частый «подводный камень» на этапе Live; проверить до wipe.
