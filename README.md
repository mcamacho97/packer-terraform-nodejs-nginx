# Proyecto Packer + Terraform: Despliegue Automatizado de Node.js y Nginx en AWS

<p align="center">
  <a href="./README.md">🇪🇸 Español</a> |
  <a href="./README_EN.md">🇺🇸 English</a>
</p>

---

## Descripción General

Este proyecto demuestra el uso de **HashiCorp Packer** y **Terraform** para automatizar la creación y despliegue de una aplicación Node.js ejecutándose detrás de un servidor Nginx en AWS.

La solución implementa principios de **Infraestructura como Código (IaC)** e **Infraestructura Inmutable**, generando una Amazon Machine Image (AMI) personalizada que incluye:

* Ubuntu Server 24.04 LTS
* Node.js
* Nginx
* Aplicación Node.js
* Servicio Systemd
* Configuración de Nginx como Reverse Proxy

Posteriormente, Terraform consume la AMI generada por Packer para desplegar automáticamente una instancia EC2 lista para ser utilizada.

---

## Arquitectura de la Solución

```text
                +----------------+
                |    Packer      |
                +--------+-------+
                         |
                         v
                +----------------+
                |  AMI Personalizada |
                +--------+-------+
                         |
                         v
                +----------------+
                |   Terraform    |
                +--------+-------+
                         |
                         v
                +----------------+
                | EC2 en AWS     |
                +--------+-------+
                         |
                         v
                +----------------+
                |     Nginx      |
                +--------+-------+
                         |
                         v
                +----------------+
                |    Node.js     |
                +----------------+
```

---

## Estructura del Proyecto

```text
.
├── packer
│   ├── app
│   │   ├── hello.js
│   │   └── package.json
│   │
│   ├── nginx
│   │   └── default.conf
│   │
│   ├── scripts
│   │   ├── install-nodejs.sh
│   │   ├── install-nginx.sh
│   │   └── validate-installation.sh
│   │
│   ├── systemd
│   │   └── nodeapp.service
│   │
│   ├── templates
│   │   ├── aws.pkr.hcl
│   │   └── azure.pkr.hcl
│   │
│   └── manifest.json
│
├── terraform
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
└── README.md
```

---

## Tecnologías Utilizadas

* HashiCorp Packer
* HashiCorp Terraform
* Amazon Web Services (AWS)
* Amazon EC2
* Amazon Machine Images (AMI)
* Ubuntu Server 24.04 LTS
* Node.js
* Nginx
* Systemd

---

## Flujo de Construcción con Packer

Packer realiza las siguientes tareas:

1. Crea una instancia EC2 temporal.
2. Establece conexión mediante SSH.
3. Instala Node.js.
4. Instala Nginx.
5. Copia la aplicación Node.js.
6. Configura el servicio Systemd.
7. Configura Nginx como Reverse Proxy.
8. Ejecuta validaciones automáticas.
9. Genera una AMI personalizada.
10. Elimina los recursos temporales utilizados durante la construcción.

### Ejecución

```bash
packer init templates/aws.pkr.hcl

packer validate templates/aws.pkr.hcl

packer build templates/aws.pkr.hcl
```

---

## Flujo de Despliegue con Terraform

Terraform consume automáticamente la AMI generada por Packer utilizando el archivo `manifest.json`.

Durante el despliegue se crean:

* Security Group
* Instancia EC2
* Salidas (Outputs) con información de despliegue

### Ejecución

```bash
terraform init

terraform plan

terraform apply
```

---

## Validación de la Aplicación

Una vez completado el despliegue, la aplicación puede accederse mediante:

```text
http://IP_PUBLICA
```

Respuesta esperada:

```text
Aplicacion NodeJS desplegada mediante Packer
```

---

## Automatización Completa

La solución implementa un flujo automatizado donde:

```text
Packer
↓
Generación de AMI
↓
Manifest
↓
Terraform
↓
Creación de EC2
↓
Aplicación Disponible
```

Esto permite realizar el despliegue sin configuraciones manuales sobre los servidores.

---

## Soporte Multinube

Además del builder para AWS, el proyecto incluye un template para Azure (`azure.pkr.hcl`).

El objetivo es demostrar la capacidad de reutilizar los mismos scripts de aprovisionamiento y configuración en distintos proveedores cloud, reduciendo el riesgo de dependencia tecnológica (vendor lock-in).

---

## Buenas Prácticas Implementadas

* Infraestructura como Código (IaC)
* Infraestructura Inmutable
* Automatización de despliegues
* Separación de responsabilidades
* Configuración como Código
* Reutilización de scripts
* Validaciones automáticas durante la construcción
* Soporte para despliegues multinube

---

## Resultados Obtenidos

Durante el desarrollo del proyecto se logró:

* Crear una AMI personalizada utilizando Packer.
* Instalar y configurar automáticamente Node.js y Nginx.
* Configurar Nginx como Reverse Proxy para la aplicación Node.js.
* Automatizar la creación de infraestructura mediante Terraform.
* Implementar un flujo reproducible y repetible de despliegue.
* Preparar la solución para escenarios multinube.

---

## Autor

**Mauricio Camacho**

Maestría en Ingeniería DevOps

Universidad Internacional de La Rioja (UNIR)
