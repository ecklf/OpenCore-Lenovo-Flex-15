# Lenovo Flex 2-15 Hackintosh

What works (currently using macOS 10.13.3):
  - Touchscreen
  - USB / Card Reader
  - Audio / Mic over Speakers, Jack and HDMI
  - Ethernet
  - Hotkeys for Audio / Brightness

What does not work:
  - Wifi / Bluetooth (needs replacement card since Intel is not supported)

Untested / yet to do:
  - Sleep / Wake

Based on:
  - [Laptop backlight control using AppleBacklightInjector.kext](https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightinjector-kext.218222/)
  - [AppleHDA for Realtek ALC283](https://www.tonymacx86.com/threads/solved-help-fixing-applehda-for-realtek-alc283.165181/page-4)
  - [[Guide] Intel IGPU HDMI/DP audio](https://www.tonymacx86.com/threads/guide-intel-igpu-hdmi-dp-audio-sandy-ivy-haswell-broadwell-skylake.189495/)

### Installation
- copy kext files to S/L/E and L/E
- copy or modify clover.plist and use the kexts in Other dir
- use my DSDT / SSDT or patch yourself (see below)
- do VoodooPS2 install (see misc)
     ```
    # Remove conflicting kexts
    sudo rm -rf /System/Library/Extensions/AppleACPIPS2Nub.kext
    sudo rm -rf /System/Library/Extensions/ApplePS2Controller.kext
    # add the Daemon to startup
    sudo cp org.rehabman.voodoo.driver.Daemon.plist /Library/LaunchDaemons
    sudo cp VoodooPS2Daemon /usr/bin
    ```
- run the Trackpad install script (else you will have no tap to click)
- setup three finger gestures in Keyboard Settings (they emulate keystrokes as workaround)

### Manually creating DSDT/SSDT files
Read up on one of RehabMan's guides and apply following patches
- IRQ Fix
- Audio Layout 3 (DSDT) and rename B0D3 to HDAU (SSDT-3-CB-01 with changed layout-id 3)
- My battery and brightness control patch files
