

# QEmu Python Wrapper QemPyWrap


Download: 
Run Raspberry PI OS:
```bash
qemu-wrap-run -d raspi3b raspios-bookworm-arm64-lite.img \
        -i y kernel8.img initramfs8
```

Run DietPi - Debian based distribution tuned for Single Board Computers
```bash
qemu-wrap-run -d DietPi_RPi-ARMv8-Bookworm.img\
        -i y kernel8.img
```

Run Alpine: 
```bash
qemu-wrap-run -d raspi3b qemu-wrap-run alpine-rpi-3.20.2-aarch64.img \
        -i y boot/vmlinuz-rpi boot/initramfs-rpi
```


