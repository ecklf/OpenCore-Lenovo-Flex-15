# Lenovo Flex 15 59416277

![screenshot](misc/Images/screen.png)

**Notes for macOS 10.15 Catalina:**

Installer will not boot on old Mojave configuration on Catalina Beta 5 onwards. 
Make sure to patch your `config.plist` to patch renaming EC0 to EC to have proper USB power management.

Inbuilt Intel WiFi won't work! I use Broadcom BCM94352HMB (use brcm kexts if you also have this setup). For that card Catalina will also need a modified BrcmPatchRAM2 or your Bluetooth won't work

The **works** list below has been already tested by myself. No compatibility issues as of now.

What works (as of macOS **10.15 19A583**):

- Ethernet
- Touchscreen
- USB / Card Reader
- Battery Status (patched)
- Multi-touch Trackpad Gestures
- Hotkeys for Audio and Brightness (patched)
- Audio
  - Out: Speakers, Jack and HDMI
  - In: Webcam (Motherboard does not support combojack input)
- Webcam + Microphone
  > If it breaks reboot without kextcache and run: sudo touch /System/Library/Extensions && sudo kextcache -u /
- WIFI/Bluetooth - Broadcom BCM94352HMB (see BIOS whitelist removal)
- Sleep / Wake

Based on (**BIG THANKS** to RehabMan):

- [Laptop backlight control using AppleBacklightInjector.kext](https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightinjector-kext.218222/)
- [AppleHDA for Realtek ALC283](https://www.tonymacx86.com/threads/solved-help-fixing-applehda-for-realtek-alc283.165181/page-4)
- [Intel IGPU HDMI/DP audio](https://www.tonymacx86.com/threads/guide-intel-igpu-hdmi-dp-audio-sandy-ivy-haswell-broadwell-skylake.189495/)
- [Broadcom WiFi/Bluetooth [Guide]](https://www.tonymacx86.com/threads/broadcom-wifi-bluetooth-guide.242423/#post-1664577)
- [BrcmPatchRAM2 for 10.15 Catalina](https://www.insanelymac.com/forum/topic/339175-brcmpatchram2-for-1015-catalina-broadcom-bluetooth-firmware-upload/)

## Flashing your BIOS / Whitelist removal

#### Only do this with guidance of an expert or this can go bad!!!

You **won't** be able to flash a new bios from a usb stick since this is write protected (even with sleep bug). This laptop sadly has no Libreboot / Coreboot support, so you will need to get someone to unlock your image for you.

Order those two parts online:

- [SPI Programmer](http://www.ebay.de/itm/25-SPI-Serie-24-EEPROM-CH341A-BIOS-Writer-Routing-LCD-Flash-USB-Programmierer-S7/282248666466?_trksid=p2047675.c100011.m1850&_trkparms=aid%3D222007%26algo%3DSIC.MBE%26ao%3D1%26asc%3D42849%26meid%3D01ae9da74f4f4c93a1270e4bf7c08b36%26pid%3D100011%26rk%3D1%26rkt%3D3%26sd%3D141466709787)
- [SOIC8 CLIP](http://www.ebay.de/itm/SOIC8-SOP8-Flash-Chip-IC-Test-Clips-Socket-Adpter-BIOS-24-25-93-Programmer-MF/182230151497?_trksid=p2047675.c100011.m1850&_trkparms=aid%3D222007%26algo%3DSIC.MBE%26ao%3D1%26asc%3D42849%26meid%3D01ae9da74f4f4c93a1270e4bf7c08b36%26pid%3D100011%26rk%3D2%26rkt%3D3%26sd%3D141466709787)

Then follow the following steps:

1. Get in touch with an expert [bios-mods](http://www.bios-mods.com) (or contact the guy who helped me at pythonic2016@gmail.com). I don't get paid for linking this, I am just happy with the result and their work. Consider giving them a good tip!

2. Once you have a person to help you. Open up your laptop and unplug your batteries (CMOS and the main battery that you need to remove in order to open up the laptop).
   ![mobo](misc/Images/lenovomod1.jpg)
3. Locate your BIOS Chip (W25Q64BV ID:0xEF4017 Size: 8192KB). In terms of connecting the clip cable make sure PIN 1 of SPI and the Chip; there is a little mark; are connected (HQ Images on Github).
   ![mobo2](misc/Images/lenovomod2.jpg)

4. Use the Software (CH341A) provided by your expert and create a dump. Send it to him and he will provide you with a new flashable image.

5. You should be done if you did everything right. Test your laptop and if everything works upgrade your hardware!

## Installation

- copy kext to L/E or to CLOVER/kexts/Other (add Broadcom kexts if needed)
- use attached config.plist
- make sure your Clover configuration uses the same UEFI drivers
- use my DSDT / SSDT or patch yourself (see below)
- run the install command for ALCPlugFix (see misc)
- do VoodooPS2 install (skip this if you already see trackpad settings)
  ```
  # Remove conflicting kexts
  sudo rm -rf /System/Library/Extensions/AppleACPIPS2Nub.kext
  sudo rm -rf /System/Library/Extensions/ApplePS2Controller.kext
  # add the Daemon to startup
  sudo cp org.rehabman.voodoo.driver.Daemon.plist /Library/LaunchDaemons
  sudo cp VoodooPS2Daemon /usr/bin
  ```
- setup three finger gestures in Keyboard Settings (they emulate keystrokes as workaround)

## Troubleshooting

If you don't see Trackpad settings use my "Install Trackpad" script. Any other issue? Feel free to open an issue on [GitHub](https://github.com/impulse/Lenovo-Flex-15-Hackintosh)

## Manually creating DSDT/SSDT files

Read up on one of RehabMan's guides and apply following patches:

- DSDT
  - IRQ Fix
  - Audio Layout 3
  - My brightness control patch
  - Lenovo Ux10-Z580 battery patch
  - Add IMEI
  - Fix Mutex with non-zero SyncLevel
  - OS Check Fix (Windows 8)
  - RTC fix
  - HPET Fix
  - Fix \_WAK Arg0 v2
  - USB3 \_PWR 0x6D (instant wake)
- SSDT-3-CB-01 (with changed layout-id 3)
  - rename B0D3 to HDAU
