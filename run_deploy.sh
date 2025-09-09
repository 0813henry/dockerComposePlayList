#!/bin/bash

# Script simple para ejecutar el playbook de PlaylistsNow en Debian
# Este script evita problemas de configuración de Ansible

echo "🎵 Desplegando PlaylistsNow con Ansible..."
echo "=========================================="

# Verificar que estamos en el directorio correcto
if [ ! -f "deploy.yaml" ]; then
    echo "❌ Error: deploy.yaml no encontrado. ¿Estás en el directorio dockerComposePlayList?"
    exit 1
fi

if [ ! -f "inventory.ini" ]; then
    echo "❌ Error: inventory.ini no encontrado."
    exit 1
fi

echo "✅ Archivos encontrados"
echo "📂 Directorio actual: $(pwd)"
echo ""

# Ejecutar el playbook con parámetros directos (sin usar ansible.cfg)
echo "🚀 Ejecutando playbook..."

ansible-playbook \
    -i inventory.ini \
    deploy.yaml \
    --timeout=30 \
    -e host_key_checking=False \
    -e pipelining=True \
    -v

# Verificar el resultado
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ¡Despliegue completado exitosamente!"
    echo ""
    echo "📱 Accesos principales:"
    echo "   • Frontend:     http://localhost:3000"
    echo "   • Backend API:  http://localhost:8080/api"
    echo "   • Health Check: http://localhost:8080/api/health"
    echo ""
    echo "🔧 Comandos de verificación:"
    echo "   docker compose ps"
    echo "   curl http://localhost:8080/api/health"
    echo "   curl http://localhost:8080/api/songs"
else
    echo ""
    echo "❌ Error durante el despliegue"
    echo "💡 Prueba ejecutar manualmente:"
    echo "   ansible-playbook -i inventory.ini deploy.yaml -vvv"
    exit 1
fi
