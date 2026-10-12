FROM --platform=linux/amd64 kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Install package minimal untuk server + tools dasar
RUN apt-get update && apt-get install --no-install-recommends -y \
    dbus \
    net-tools iproute2 iputils-ping dnsutils traceroute netcat-openbsd \
    curl wget rsync telnet socat \
    openssh-server openssh-client \
    vim nano less man-db bash-completion \
    htop lsof psmisc procps \
    tar gzip bzip2 xz-utils zip unzip \
    sudo tzdata locales \
    openssl ca-certificates \
    jq tree file bc debianutils \
    apt-utils apt-transport-https gnupg lsb-release \
    && sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup SSH
RUN mkdir -p /var/run/sshd && \
    ssh-keygen -A && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PrintLastLog yes/PrintLastLog no/' /etc/ssh/sshd_config && \
    sed -i 's/^session.*pam_motd.so/#&/' /etc/pam.d/sshd

# Set root password (ganti sesuai kebutuhan)
RUN echo 'root:root' | chpasswd

# ==========================================
# SSH BANNER SETUP - GURITA VPS
# ==========================================

# Matikan MOTD default
RUN rm -rf /etc/update-motd.d/* && \
    rm -f /etc/motd /etc/issue /etc/issue.net && \
    touch /etc/motd /etc/issue /etc/issue.net

# Pre-auth banner
RUN printf '\n  GURITA VPS (Kali) - Authorized Access Only\n\n' > /etc/ssh/banner && \
    echo 'Banner /etc/ssh/banner' >> /etc/ssh/sshd_config

# Banner GURITA VPS (post-login)
RUN cat <<'EOF' > /etc/profile.d/gurita-banner.sh
#!/bin/bash

# Hindari banner pada shell non-interaktif
case $- in
    *i*) ;;
    *) return ;;
esac

clear

echo ""
echo "=========================================="
echo "       G U R I T A   V P S  (KALI)"
echo "=========================================="
echo ""
echo "    ____  _   _ ____ ___ _____  _"
echo "   / ___|| | | |  _ \\_ _|_   _|/ \\"
echo "  | |  _ | | | | |_) | |  | | / _ \\"
echo "  | |_| || |_| |  _ <| |  | |/ ___ \\"
echo "   \\____| \\___/|_| \\_\\_|  |_|_/   \\_\\"
echo ""
echo ""
echo "=========================================="
echo " User     : $(whoami)"
echo " Uptime   : $(uptime -p 2>/dev/null || echo 'N/A')"
echo " Date     : $(date)"
echo "=========================================="
echo ""
EOF
RUN chmod +x /etc/profile.d/gurita-banner.sh

# ==========================================
# END BANNER SETUP
# ==========================================

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
