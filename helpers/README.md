

# QEmuPyWrap
## QEmu Python Wrapper


### Raspberry Pi OS
[Download Raspberry Pi OS (preferably 64-bit and Lite version - who needs Desktop?)](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit), once done and saved run emulation: 

```bash
./qemu-wrap-run -d raspi3b <pathto>/<date>-raspios-<release_name>-arm64-lite.img \
        -i y kernel8.img initramfs8
```

### DietPi
DietPi is Debian based distribution tuned for a wide variety of a Single Board Computers. Download ["Raspberry Pi 2/3/4/Zero 2"](https://dietpi.com/#download) image and run emulation with: 
```bash
qemu-wrap-run -d raspi3b <pathto>/DietPi_RPi-ARMv8-<release_name>.img \
        -i y kernel8.img
```
*Note:* Diet Pi does not require Initial ramdisk (initramfs), kernel is tuned for a specific board so kernel does not need to make use of initramfs to boot (slimer system, faster boot).

### Alpine

Download [Alpine for Raspberry Pi, preferebly aarch64](https://www.alpinelinux.org/downloads/).

Run emulation with: 
```bash
qemu-wrap-run -d raspi3b <pathto>alpine-rpi-<version>-aarch64.img \
        -i y boot/vmlinuz-rpi boot/initramfs-rpi
```
This will lunch alpine installation.

