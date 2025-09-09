# 🚀 PlaylistsNow Deployment con Ansible para Debian

Playbooks de Ansible para desplegar automáticamente **PlaylistsNow** en Debian.

## 📁 Estructura

```
dockerComposePlayList/
├── deploy.yaml           # Playbook principal
├── inventory.ini         # Configuración localhost
├── ansible.cfg          # Configuración Ansible
├── linux_hostname.yaml  # Opcional: hostname
├── timezone.yaml        # Opcional: timezone
└── README.md            # Esta documentación
```

## 🛠️ Prerrequisitos en Debian

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Ansible y Git
sudo apt install ansible git curl -y

# Verificar/crear usuario sysadmin
sudo adduser sysadmin
sudo usermod -aG sudo sysadmin
```

## 🚀 Ejecución Directa en Terminal Debian

```bash
# 1. Clonar repositorio
git clone https://github.com/0813henry/dockerComposePlayList.git
cd dockerComposePlayList

# 2. OPCIÓN A: Ejecutar con localhost directo (más simple)
ansible-playbook deploy.yaml -c local -K

# 3. OPCIÓN B: Usar inventory (si la opción A no funciona)
ansible-playbook -i inventory.ini deploy.yaml

# 4. OPCIÓN C: Forzar conexión local explícita
ansible-playbook deploy.yaml --connection=local --ask-become-pass

# Parámetros:
# -c local = usa conexión local (sin SSH)
# -K = pide contraseña sudo
# --ask-become-pass = igual que -K
```

## 🎯 Lo que hace el playbook

1. Instala Docker CE
2. Crea usuario sysadmin en grupo docker
3. Clona PlaylistsNow en `/home/sysadmin/playlistsnow`
4. Configura variables de entorno
5. Ejecuta `docker compose up -d`
6. Verifica que la API responda

## 🌐 Accesos tras despliegue

- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:8080/api
- **Health**: http://localhost:8080/api/health

## 🔧 Verificación

```bash
# Ver contenedores
cd /home/sysadmin/playlistsnow
docker compose ps

# Probar API
curl http://localhost:8080/api/health
curl http://localhost:8080/api/songs

# Crear canción de prueba
curl -X POST http://localhost:8080/api/songs \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","artist":"Debian"}'
```

## 🚨 Si hay problemas

### Error SSH "Connection refused"

Si ves: `ssh: connect to host localhost port 22: Connection refused`

**Solución (usar conexión local SIN SSH):**

```bash
ansible-playbook deploy.yaml -c local -K
```

### Error SafeRepresenter

```bash
# Usar comando con -v en lugar del ansible.cfg
ansible-playbook deploy.yaml -c local -v
```

### Permisos Docker

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Puertos ocupados

```bash
sudo netstat -tulpn | grep :3000
sudo netstat -tulpn | grep :8080
```

---

**¡PlaylistsNow listo en Debian! 🎵🐧**
