# Этап 3 — бэкап

> **Статус:** MUST HAVE и DESTRUCTIVE выполнены (2026-05).

Флешка 32 ГБ — только Arch ISO. Отдельный USB под бэкап нет.

---

## MUST HAVE

- [x] **Cursor / VS Code / .gitconfig** — `arch-migration-backup\laptop-backup-2026-05-21-1245`
- [x] Перенесено на **основной ПК** (RDP / и т.д.)
- [x] Проверка с main PC

---

## Уже в Git / облаке — отдельно не копировать

| Что | Почему |
|-----|--------|
| **Obsidian Vault** | `Documents\Vault` → remote `obsidian` (GitHub). Плагин **obsidian-git**. Копия на main PC **не нужна** |
| Git push по всем репо | Не надо |
| Pictures | iCloud Photos, не локальные файлы |
| SSH | Только `known_hosts` |
| 2FA | Нет |
| `.env` | В пользовательских папках нет; WebHotelBE — в iCloud Drive |

**Перед wipe (только Vault):** если есть незакоммиченное — один раз `git add` / `commit` / `push` в Vault (сейчас в том числе `arch-migration/` и прочие `??`). Или дождаться автокоммита obsidian-git.

```powershell
cd $env:USERPROFILE\Documents\Vault
git status -sb
# при необходимости:
# git add -A && git commit -m "pre-arch backup" && git push obsidian main
```

---

## Опционально

- [x] [arch-preinstall-report.txt](arch-preinstall-report.txt) — справка по железу (Windows, не в git)
- [ ] Downloads (~7 ГБ) — **пропущено** (не критично)

---

## DESTRUCTIVE — после подтверждения

- [x] ISO на флешку Leef
- [x] Wipe Disk 0 NVMe → Arch на `nvme0n1`

**`Бэкап проверен, destructive actions confirmed`** → [05-install-arch.md](05-install-arch.md) — **выполнено**.
