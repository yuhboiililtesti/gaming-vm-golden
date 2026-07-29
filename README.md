# gaming-vm-golden

My KVM GPU passthrough config that took 60+ cold boots to get right. GTX 1660 SUPER on Ubuntu 24.04, QXL+SPICE for display, Moonlight for streaming at 120fps.

## What's in here
- `golden.xml` — the libvirt XML that finally works. QXL + GPU, CCX topology, SMBIOS spoofing (Gigabyte B550), 12GB locked RAM, e1000e NIC
- `vfio.conf` — binds all 4 GPU functions, softdeps so nvidia never touches it
- `grub` — kernel cmdline with isolcpus, pcie_aspm=off, initcall blacklist
- `start-vm.sh` — auto-start script, handles USB bind
- `qemu-hook` — GPU reset on VM stop

## Anti-cheat layers
Built these up over a weekend:
1. Intel MAC (00:d0:b7) — not the default QEMU 52:54:00 that gets insta-flagged
2. SATA disk controller — virtio shows as "Red Hat" in device manager
3. SMBIOS: Gigabyte B550 AORUS ELITE V2, real serial GGB550A001923X
4. KVM hidden, hypervisor off, SVM disabled
5. AuthenticAMD vendor string
6. Dummy ACPI thermal zone so Windows sees normal temps
7. HPET/PMU disabled, no tablet or ICH9 artifacts

## Lessons learned (the hard way)
- **Never destroy the VM.** Use `virsh reboot` for restarts. Destroy = GPU zombie (PCI header 127) = cold boot.
- **D3 errors are random per cold boot.** Some boots are clean (0 D3), some aren't. QXL in the XML helps.
- **remove the ROM file if it's legacy VGA BIOS.** OVMF needs UEFI GOP, not 1990s VGA.
- **virt-manager is fine, but know your XML.** You'll need it when things break.

## Related
- [moonlight-tuning](https://github.com/yuhboiililtesti/moonlight-tuning) — the streaming half of this setup
- [bulletproof-pipeline](https://github.com/yuhboiililtesti/bulletproof-pipeline) — keeps everything alive
