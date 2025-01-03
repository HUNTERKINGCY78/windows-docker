# Gunakan image Debian sebagai basis
FROM debian:latest

# Instal XFCE, NoVNC, dan dependensi
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-terminal novnc websockify \
    x11vnc xvfb curl wget net-tools supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Konfigurasi VNC
RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd 1234 ~/.vnc/passwd

# Konfigurasi Supervisor
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Tambahkan NoVNC
RUN mkdir -p /novnc && \
    curl -L https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar xz -C /novnc --strip-components=1 && \
    ln -s /novnc/utils/websockify /usr/local/bin/websockify

# Set environment
ENV DISPLAY=:0
EXPOSE 8080

# Jalankan Supervisor untuk mengelola layanan
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
