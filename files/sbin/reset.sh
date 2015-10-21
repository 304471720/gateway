#!/bin/bash

# Step 1: Recover the original setting in ROM
cp -a /rom/etc /

# Step 2: Remove routerId so that init.sh will kick in
rm /etc/routerId

# Step 3: Run init.sh to recover the initiaization phase
/usr/lib/wifixi/init.sh
