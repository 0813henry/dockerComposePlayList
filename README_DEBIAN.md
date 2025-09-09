# 🚀 PlaylistsNow Deployment con Ansible para Debian

Este proyecto contiene los playbooks de Ansible para desplegar automáticamente la aplicación **PlaylistsNow** usando Docker y Docker Compose en Debian.

## 📋 Descripción

Los playbooks de Ansible automatizan completamente el proceso de:

- Instalación de Docker y Docker Compose
- Clonado del repositorio PlaylistsNow
- Configuración de variables de entorno
- Despliegue de la aplicación con contenedores
- Verificación de salud de los servicios

## 📁 Estructura del Proyecto

```
dockerComposePlayList/
├── deploy.yaml           # Playbook principal de despliegue
├── inventory.ini         # Inventario de hosts (localhost)
├── ansible.cfg          # Configuración de Ansible
├── linux_hostname.yaml  # Configuración de hostname
├── timezone.yaml        # Configuración de zona horaria
└── README.md            # Esta documentación
```

## 🛠️ Prerrequisitos en Debian

### 1. Actualizar sistema

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Ansible y Git

```bash
sudo apt install ansible git curl -y
```

### 3. Verificar usuario sysadmin

```bash
# Si no existe el usuario, crearlo
sudo adduser sysadmin
sudo usermod -aG sudo sysadmin

# Cambiar a usuario sysadmin
su - sysadmin
```

## 🚀 Despliegue en Debian

### 1. Clonar el repositorio

```bash
git clone https://github.com/0813henry/dockerComposePlayList.git
cd dockerComposePlayList
```

### 2. Ejecutar el playbook

```bash
# Despliegue básico
ansible-playbook -i inventory.ini deploy.yaml

# Con detalles (recomendado para primera vez)
ansible-playbook -i inventory.ini deploy.yaml -vvv

# Si pide contraseña sudo
ansible-playbook -i inventory.ini deploy.yaml --ask-become-pass
```

### 3. Verificar el despliegue

```bash
# Verificar contenedores
docker compose ps

# Probar health check
curl http://localhost:8080/api/health

# Ver canciones
curl http://localhost:8080/api/songs

# Crear una canción de prueba
curl -X POST http://localhost:8080/api/songs \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Debian","artist":"Ansible"}'
```

## 🎯 Lo que hace el playbook

1. **Instala Docker CE** desde el repositorio oficial
2. **Crea el usuario sysadmin** y lo agrega al grupo docker
3. **Clona PlaylistsNow** en `/home/sysadmin/playlistsnow`
4. **Configura variables de entorno** (.env files)
5. **Ejecuta docker compose** para levantar los servicios
6. **Verifica** que la API responda correctamente

## 📊 Configuración del Inventario

El archivo `inventory.ini` está configurado para localhost:

```ini
[controller]
dev-controlplane-01 ansible_host=localhost ansible_user=sysadmin

[defaults]
host_key_checking = False
```

## 🌐 URLs de Acceso

Después del despliegue exitoso:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080/api
- **Health Check**: http://localhost:8080/api/health

## 🔧 Comandos Útiles Post-Despliegue

```bash
# Ver estado de contenedores
cd /home/sysadmin/playlistsnow
docker compose ps

# Ver logs
docker compose logs -f

# Reiniciar servicios
docker compose restart

# Parar todo
docker compose down

# Actualizar y relanzar
git pull origin main
docker compose down
docker compose up -d --build
```

## 🚨 Solución de Problemas

### Error de permisos Docker

```bash
sudo usermod -aG docker $USER
newgrp docker
# O reiniciar sesión
```

### Puertos ocupados

```bash
# Verificar qué usa los puertos
sudo netstat -tulpn | grep :3000
sudo netstat -tulpn | grep :8080

# Matar procesos si es necesario
sudo lsof -ti:3000 | xargs sudo kill -9
sudo lsof -ti:8080 | xargs sudo kill -9
```

### Error de MongoDB

- El sistema funciona en modo memoria si MongoDB Atlas no está disponible
- Verifica conectividad a internet
- Las credenciales están configuradas en el playbook

## 📚 Playbooks Adicionales

### Configurar zona horaria

```bash
ansible-playbook -i inventory.ini timezone.yaml
```

### Configurar hostname

```bash
ansible-playbook -i inventory.ini linux_hostname.yaml
```

## 🎵 Pruebas de la Aplicación

1. **Abrir frontend** (si tienes GUI): http://localhost:3000
2. **Probar API directamente**:

   ```bash
   # Ver canciones iniciales
   curl http://localhost:8080/api/songs | jq

   # Agregar canción
   curl -X POST http://localhost:8080/api/songs \
     -H "Content-Type: application/json" \
     -d '{"title":"Bohemian Rhapsody","artist":"Queen"}' | jq

   # Verificar que se agregó
   curl http://localhost:8080/api/songs | jq
   ```

## ✅ Criterios de Éxito

El despliegue es exitoso cuando:

- ✅ `docker compose ps` muestra servicios "Up"
- ✅ `curl http://localhost:8080/api/health` retorna `{"status":"ok"}`
- ✅ Frontend es accesible en puerto 3000
- ✅ Se pueden crear y ver canciones via API
- ✅ La red `playlistsnow-network` existe

---

**¡PlaylistsNow listo para producir música en Debian! 🎵🐧**
