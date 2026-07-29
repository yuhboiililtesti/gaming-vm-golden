#!/bin/bash
LOG="/var/log/gaming-vm.log"
echo "$(date): Starting VM..." >> $LOG

# Unbind USB from xhci_hcd
echo "0000:0b:00.2" > /sys/bus/pci/drivers/xhci_hcd/unbind 2>/dev/null || true
echo "vfio-pci" > /sys/bus/pci/devices/0000:0b:00.2/driver_override 2>/dev/null || true
echo "0000:0b:00.2" > /sys/bus/pci/drivers_probe 2>/dev/null || true
sleep 1

# Ensure network
virsh net-start default 2>/dev/null || true

# Define and start
virsh define /etc/libvirt/passthrough-win10-golden.xml >> $LOG 2>&1 || true
virsh start win10-gaming >> $LOG 2>&1 && echo "$(date): VM started" >> $LOG || echo "$(date): VM start FAILED" >> $LOG
