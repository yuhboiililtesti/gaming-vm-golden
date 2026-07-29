# Gaming VM Golden Config

QEMU/KVM GPU passthrough for GTX 1660 SUPER with anti-cheat evasion.

## Files
- `golden.xml` — QXL+SPICE+GPU passthrough, CCX topology, SMBIOS spoof
- `vfio.conf` — VFIO binding for all 4 GPU functions
- `start-vm.sh` — Auto-start script (USB bind + define + start)
- `grub` — Kernel cmdline (isolcpus, pcie_aspm, vfio)
- `qemu-hook` — GPU reset hook

## Anti-Cheat Layers
1. Intel MAC OUI (not QEMU 52:54:00)
2. SATA disk controller (not virtio)
3. SMBIOS: Gigabyte B550, real serial
4. KVM hidden
5. CPU: host-passthrough, AuthenticAMD
6. Hypervisor disabled, SVM off
7. Dummy thermal zone (ACPI SSDT)
8. HPET disabled, PMU off
9. No tablet/ICH9 artifacts
10. American Megatrends F37 BIOS

## Boot Order
1. docker.service + libvirtd.service
2. gaming-vm.service → auto-start VM
3. vm-network.service → DNAT + forwarding
4. docker-ports.service → external access

## NEVER destroy the VM — use virsh reboot for restarts
