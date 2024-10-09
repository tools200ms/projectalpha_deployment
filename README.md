

# AlphaWrap
This is a wrapper for `qemu-system-*` that allows on creation, launch and interaction with QEmu emulated machines in a manner that Docker does.

This wrapper manages QEMU ARM-emulated machines. It has been developed as a key tool to support the development and automation of AlpBase Linux, which is specifically designed for ARM platforms, particularly Raspberry Pi boards.

![Made with ChatGPT (accually ChatGPT made this)](./art/AlphaWrap-mini.png)

## Functions

AlphaWrap manages QEmu ARM machines extending `qemu-system-*` command set by: 
- ability of creating containers from image (ala Docker)
- ease of usage, kernel, initramfs and other elements are handled by `alpha-wrap`, it simplifies working with VMs
- provides functions to interact with VMs, attaching virtual USB storage, executing commands inside VM etc.

AlphaWrap has been developed as tool to biuld AlpBase Linux images.

## Concept

On the beginning there is an image (ARM image). To launch the image, the user specifies the device model to emulate (defaulting to 'raspi3b' if omitted), along with the paths to the kernel, initramfs, and most importantly, the ARM image file.

The image will be turned into container, if option `--name` is provided, 'named' container is created. If `--name` is skipped, instead 'temporary' container is created - that will live only until VM is on. 'Named' container states indefinitely, util is intentionally removed.

The benefit coming from this aproach is that image stays intact. Some systems, such as Raspberry PI OS modify image upon first launch what is very practical for user. But, while experimenting and developing it's essential to keep track on what has changed, what not. Thus, distinction between images - that never change, and containers - that are prone for changes, is very practical.
Container name can be provided after parameter `--name`, if `--name` does not have any name afterward, random container name is given.

When container is created, user can attach "Attachable Storage" that is emulated "USB storage device", or execute (over SSH) certain command.

Below, complete guide with an examples.

## AlphaWrap Guaid

### Installation

Clone this repository: 
```bash
git clone https://github.com/tools200ms/projectalpha_deployment.git
cd projectalpha_deployment
```
Copy DTB files and `alpha-wrap`:
```bash
sudo mkdir -p /var/lib/alphawrap/dtb
sudo cp -r alpha-wrap/dtbs/* /var/lib/alphawrap/dtb

sudo cp ./alpha-wrap/alpha-wrap-run /usr/local/bin/
```
and finally initialize directory structure and databases: 
```bash
alpha-wrap-run init
```
AlphaWrap uses `/var/cache` for storage, ensure that you have enough free space under this location. Containers might take about 10 GB, the rule of thumb is to have at least half of the disk space to be free (and trimmed if it's SSD). Make sure you are well below half of the available storage capacity.

### Running ARM Linux Image

`AlphaWrap` supports emulation of the following devices: 
- `raspi0` - DOES NOT WORK
- `raspi3b` - emulated ARMv8 four core CPU, uses emulated USB 2.0, thus networking and storage access is kinda slowish.

Desired device is chosen with `--device` flag. 

VM requires kernel and eventually initramfs in order to boot system. These parameters can be provided as `--imgboot` (`-i`) argument. `--imgboot` work in two 'modes':
- `y` - yes, to search for a kernel and eventually initramfs within image file. `AlphaWrap` will examine image file and attempt to find a boot partition and within it appropriate kernel and initramfs files.
- `n` - no, kernel and an optional initramfs must be located on host.


Below are the instructions on how to run popular Raspberry Pi Linuxes.


#### Raspberry Pi OS
[Download Raspberry Pi OS (preferably 64-bit and Lite version - who needs Desktop?)](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit), once done and saved run emulation: 

```bash
./alpha-wrap-run -d raspi3b <pathto>/<date>-raspios-<release_name>-arm64-lite.img \
        -i y kernel8.img initramfs8
```

#### DietPi
DietPi is Debian based distribution tuned for a wide variety of a Single Board Computers. Download ["Raspberry Pi 2/3/4/Zero 2"](https://dietpi.com/#download) image and run emulation with: 
```bash
alpha-wrap-run -d raspi3b <pathto>/DietPi_RPi-ARMv8-<release_name>.img \
        -i y kernel8.img
```
*Note:* Diet Pi does not require Initial ramdisk (initramfs), kernel is tuned for a specific board so kernel does not need to make use of initramfs to boot (slimer system, faster boot).

#### Alpine

Download [Alpine for Raspberry Pi, preferebly aarch64](https://www.alpinelinux.org/downloads/).

Run emulation with: 
```bash
alpha-wrap-run -d raspi3b <pathto>alpine-rpi-<version>-aarch64.img \
        -i y boot/vmlinuz-rpi boot/initramfs-rpi
```
This will lunch alpine installation.

