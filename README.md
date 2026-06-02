# HTBMachines Searcher

![HTBMAchines](image/htb-hacking.jpg)

Script en Bash para buscar y filtrar máquinas de Hack The Box a partir del archivo `bundle.js` publicado en `htbmachines.github.io`.

Permite consultar máquinas por nombre, IP, dificultad, sistema operativo, skills y obtener enlaces a walkthroughs de YouTube.

---

# Características

- Descarga y actualización automática del dataset (`bundle.js`)
- Búsqueda de máquinas por nombre
- Búsqueda de máquinas por IP
- Filtrado por dificultad
- Filtrado por sistema operativo
- Filtrado combinado por SO + dificultad
- Búsqueda por skill/técnica
- Obtención automática del enlace de resolución en YouTube
- Interfaz CLI sencilla y rápida
- Manejo de interrupciones (`Ctrl + C`)

---

# Requisitos

Antes de usar el script, instala las dependencias necesarias:

```bash
sudo apt install moreutils curl
npm install -g js-beautify
```

---

# Instalación

Clona el repositorio:

```bash
git clone https://github.com/TU-USUARIO/htbmachines-searcher.git
cd htbmachines-searcher
```

Da permisos de ejecución:

```bash
chmod +x htbmachines.sh
```

---

# Uso

## Descargar o actualizar archivos

```bash
./htbmachines.sh -u
```

---

## Buscar una máquina por nombre

```bash
./htbmachines.sh -m Sauna
```

---

## Buscar una máquina por IP

```bash
./htbmachines.sh -i 10.10.10.175
```

---

## Buscar máquinas por dificultad

```bash
./htbmachines.sh -d Fácil
```

---

## Buscar máquinas por sistema operativo

```bash
./htbmachines.sh -o Linux
```

---

## Buscar máquinas por dificultad y sistema operativo

```bash
./htbmachines.sh -d Fácil -o Linux
```

---

## Buscar máquinas por skill

```bash
./htbmachines.sh -s smb
```

---

## Obtener el enlace de resolución en YouTube

```bash
./htbmachines.sh -y Sauna
```

---

## Mostrar ayuda

```bash
./htbmachines.sh -h
```

---

# Ejemplo de salida

```bash
[+] Listando las propiedades de la máquina Sauna:

name: Sauna
ip: 10.10.10.175
so: Windows
dificultad: Media
skills: Active Directory, Kerberos, ASREPRoast
youtube: https://youtube.com/...
```

---

# Estructura del proyecto

```bash
.
├── htbmachines.sh
├── bundle.js
└── README.md
```

---

# Funcionamiento interno

El script:

1. Descarga el archivo `bundle.js`
2. Lo formatea usando `js-beautify`
3. Realiza búsquedas usando:
   - `grep`
   - `awk`
   - `sed`
   - `column`

4. Muestra resultados formateados por terminal

---

# Tecnologías utilizadas

- Bash
- Curl
- AWK
- Grep
- Sed
- Moreutils (`sponge`)
- js-beautify

---

# Autor

Desarrollado por Javi Lázaro

---

# Licencia

Este proyecto se distribuye bajo licencia MIT.
