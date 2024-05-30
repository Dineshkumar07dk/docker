#!/bin/bash

# Check if an IP address argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

# Set the IP address from the argument
MY_IP_ADDRESS=$1
echo "Using IP Address: $MY_IP_ADDRESS"

# Define the path to the configuration files
IPSEC_CONF="/etc/ipsec.conf"
IPSEC_SECRETS="/etc/ipsec.secrets"

# Check if the IPsec configuration file exists
if [ ! -f "$IPSEC_CONF" ]; then
    echo "Error: $IPSEC_CONF not found!"
    exit 1
fi

# Replace the rightsubnet value in /etc/ipsec.conf
sed -i "s/rightsubnet=[^ ]*/rightsubnet=${MY_IP_ADDRESS}\/32/" "$IPSEC_CONF"

# Add the PSK to /etc/ipsec.secrets
echo ': PSK "ivis@tEst1"' > "$IPSEC_SECRETS"

# Restart the StrongSwan service
service strongswan restart

# Flush the PREROUTING chain in the nat table of iptables
sudo iptables -t nat -F PREROUTING

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Restart IPsec
ipsec restart

# Bring up the IPsec connection
ipsec up n

echo "IPsec VPN configuration completed successfully."
