# Lenovo Flex 2-15 Hackintosh

What works:
  - Touchscreen
  - USB / Card Reader
  - Audio / Mic over Speakers and Jack
  - Ethernet

What does not work:
  - Wifi / Bluetooth (needs replacement card)

Untested:
  - HDMI Audio

Based on:
    - [Laptop backlight control using AppleBacklightInjector.kext](https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightinjector-kext.218222/).
    - [AppleHDA for Realtek ALC283](https://www.tonymacx86.com/threads/solved-help-fixing-applehda-for-realtek-alc283.165181/page-4).

### Installation
- copy kext files to S/L/E and L/E
- copy or modify clover.plist and use the kexts in Other dir
- use my DSDT / SSDT or patch yourself (see below)
- do VoodooPS2 install (see misc)
     ```
    sudo rm -rf /System/Library/Extensions/AppleACPIPS2Nub.kext
    sudo rm -rf /System/Library/Extensions/ApplePS2Controller.kext
    sudo cp org.rehabman.voodoo.driver.Daemon.plist /Library/LaunchDaemons
    sudo cp VoodooPS2Daemon /usr/bin
    ```
- run the Trackpad install script (else you will have no tap to click)
- setup three finger gestures in Keyboard Settings (they emulate keystrokes!)

### Manually creating DSDT/SSDT
Read up on one of RehabMan's guides and apply following patches
- Audio Layout 3
- IRQ Fix
- My battery patch file
