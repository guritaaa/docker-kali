
# GURITA VPS - Kali Linux Docker Container

Image Docker berbasis **Kali Linux (kali-rolling)** yang dikonfigurasi sebagai lightweight SSH environment dengan tools administrasi sistem, jaringan dasar, dan custom dynamic login banner.

---

## Fitur Utama

- **Base Image:** Kali Linux Rolling (`kalilinux/kali-rolling`)
- **Akses Remote:** OpenSSH Server pre-configured (Port 22)
- **Timezone:** Asia/Jakarta (WIB)
- **Locale:** `en_US.UTF-8`
- **Banner Kustom:** ASCII MOTD dinamis (*GURITA VPS*) saat login shell interaktif
- **Pre-installed Tools:**
  - Jaringan: `net-tools`, `iproute2`, `curl`, `wget`, `ping`, `dnsutils`, `traceroute`, `netcat`, `socat`, `rsync`, `telnet`
  - Utilitas Sistem: `htop`, `procps`, `lsof`, `psmisc`, `jq`, `tree`, `vim`, `nano`, `bash-completion`
  - Arsip & Kompresi: `tar`, `gzip`, `bzip2`, `xz-utils`, `zip`, `unzip`

---

## Kredensial Default

| Parameter | Nilai Default |
| :--- | :--- |
| **User** | `root` |
| **Password** | `root` |
| **Port Container** | `22` |

> **Peringatan Keamanan:** Segera ganti password root default di file `Dockerfile` atau setelah login menggunakan perintah `passwd`.

---

## Panduan Penggunaan

### 1. Build Image

Jalankan perintah berikut di direktori tempat `Dockerfile` berada:

```bash
docker build -t gurita-kali-vps .

```

### 2. Menjalankan Container

Jalankan container di background (*detached mode*) dan petakan port SSH (misalnya port host `2222` ke port container `22`):

```bash
docker run -d \
  --name kali-vps \
  -p 2222:22 \
  --restart unless-stopped \
  gurita-kali-vps

```

### 3. Akses via SSH

Hubungkan terminal lokal atau SSH client ke container:

```bash
ssh root@localhost -p 2222

```

Masukkan password default: `root`

---

## Manajemen Container

* **Melihat status container:**
```bash
docker ps -f name=kali-vps

```


* **Melihat log SSH server:**
```bash
docker logs kali-vps

```


* **Menghentikan container:**
```bash
docker stop kali-vps

```


* **Menjalankan kembali container:**
```bash
docker start kali-vps

```


* **Menghapus container:**
```bash
docker rm -f kali-vps

```



---

## Konfigurasi Lanjutan

### Mengubah Password Saat Build

Ubah baris berikut di dalam `Dockerfile` sebelum melakukan build:

```dockerfile
RUN echo 'root:PASSWORD_BARU_ANDA' | chpasswd

```

### Menjalankan dengan Docker Compose

Jika menggunakan `docker-compose.yml`:

```yaml
services:
  kali-vps:
    build: .
    container_name: kali-vps
    ports:
      - "2222:22"
    restart: unless-stopped

```

Jalankan dengan:

```bash
docker compose up -d

```

```
