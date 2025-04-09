#!/bin/bash

# -----------------------------
# Script: voip_qos.sh
# Purpose: Prioritize VoIP (UDP) traffic using tc and HTB
# Interface: eth0 (adjust if needed)
# -----------------------------

IFACE="eth0"

echo "[+] Applying VoIP QoS shaping on interface: $IFACE"

# Step 1: Clear any existing qdisc rules - verify if needed first
tc qdisc del dev $IFACE root 2>/dev/null

# Step 2: Add root HTB qdisc with handle 1: and default class 1:12
tc qdisc add dev $IFACE root handle 1: htb default 12

# Step 3: Create VoIP class (high priority) - classid 1:10
# Rate: guaranteed 1Mbps, Max: 1Mbps
tc class add dev $IFACE parent 1: classid 1:10 htb rate 1mbit ceil 1mbit prio 1

# Step 4: Create Bulk class (low priority) - classid 1:12
# Rate: guaranteed 512Kbps, Max: 512Kbps
tc class add dev $IFACE parent 1: classid 1:12 htb rate 512kbit ceil 512kbit prio 2

# Step 5: Add filter to classify UDP (VoIP-like) traffic into class 1:10
tc filter add dev $IFACE protocol ip parent 1:0 prio 1 u32 \
  match ip protocol 17 0xff flowid 1:10

# Optional Step 6: Show the active qdisc and class configuration
echo "[+] Current tc configuration for $IFACE:"
tc -s qdisc show dev $IFACE
tc -s class show dev $IFACE

echo "[✓] VoIP QoS shaping applied successfully!"
