# reto2026
hhhh

Colección de scripts PowerShell para administración de sistemas Windows y Linux.

---

## 📁 Estructura del proyecto

```
reto2026/
├── backup.ps1      # Backup remoto de servidor Ubuntu/Apache
├── restore.ps1     # Información de hardware Windows
├── Javi/
│   └── nada.ps1
├── mas/
│   └── menos.ps1
└── README.md
```

---

## 🔧 Scripts

### `backup.ps1` — Backup remoto de `/var/www/html`

Realiza un backup comprimido (`.tar.gz`) de la carpeta web de un servidor Ubuntu con Apache vía SSH/SCP.

**Parámetros:**

| Parámetro | Obligatorio | Descripción |
|-----------|-------------|-------------|
| `-HostName` | ✅ | IP o hostname del servidor |
| `-User` | ✅ | Usuario SSH |
| `-IdentityFile` | ❌ | Ruta a la clave privada SSH |
| `-Port` | ❌ | Puerto SSH (default: 22) |
| `-SourcePath` | ❌ | Ruta remota a respaldar (default: `/var/www/html`) |
| `-LocalBackupDir` | ❌ | Carpeta local de destino (default: `.\backups`) |
| `-RetentionDays` | ❌ | Eliminar backups locales más antiguos (0 = desactivado) |
| `-DryRun` | ❌ | Simular sin ejecutar |

**Ejemplo:**

```powershell
.\backup.ps1 -HostName 192.168.1.100 -User ubuntu -IdentityFile ~/.ssh/id_rsa -RetentionDays 7
```

---

### `restore.ps1` — Información de hardware Windows

Muestra información básica del hardware del sistema:

- **Sistema:** Fabricante, Modelo, RAM
- **Procesador:** Nombre, Núcleos, Hilos
- **Discos:** Modelo y tamaño
- **GPU:** Nombre y VRAM
- **Sistema Operativo:** Nombre, Versión, Arquitectura

**Uso:**

```powershell
.\restore.ps1
```

---

## ⚙️ Requisitos

- **Windows** con PowerShell 5.1 o PowerShell 7+
- Para `backup.ps1`: cliente SSH/SCP instalado (incluido en Windows 10+)

---

## 📄 Licencia

MIT
