#!/bin/bash

# Start the X virtual framebuffer
Xvfb :0 -screen 0 1024x768x16 &
sleep 5

# Start the Xfce desktop environment
export DISPLAY=:0
startxfce4 &

# Start x11vnc
x11vnc -display :0 -forever -shared -rfbauth ~/.vnc/passwd &

# Start supervisor to manage processes
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
