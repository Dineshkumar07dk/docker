FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    x11vnc \
    xvfb \
    supervisor \
    dbus-x11 \
    xterm \
    tightvncserver \
    sudo \
    wget \
    desktop-file-utils \
&& apt-get clean

# Configure VNC
RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd 1234 ~/.vnc/passwd

# Set up TightVNC
RUN mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml && \
    echo "session.optionalTasks = ssh-agent" > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml && \
    echo "session.required_components_list = ['windowmanager', 'panel', 'launcher', 'desktop']" >> ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml

# Add the startup script
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start-vnc.sh /usr/local/bin/start-vnc.sh
RUN chmod +x /usr/local/bin/start-vnc.sh

# Expose the VNC port
EXPOSE 5900

CMD ["/usr/local/bin/start-vnc.sh"]
