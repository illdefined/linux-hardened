{ option, lib, hostPlatform }: {
  SUSPEND = true;
  WQ_POWER_EFFICIENT_DEFAULT = true;
  ACPI_BATTERY = true;
  ACPI_VIDEO = true;

  HOTPLUG_PCI_PCIE = true;
  HOTPLUG_PCI = true;

  MEDIA_SUPPORT = true;
  MEDIA_SUPPORT_FILTER = true;
  MEDIA_SUBDRV_AUTOSELECT = true;
  MEDIA_CAMERA_SUPPORT = true;
  MEDIA_USB_SUPPORT = true;
  USB_VIDEO_CLASS = true;
  USB_VIDEO_CLASS_INPUT_EVDEV = true;

  HID_BATTERY_STRENGTH = true;

  USB_NET_DRIVERS = true;
  USB_RTL8152 = true;
  USB_USBNET = true;
  USB_NET_AX88179_178A = true;
  USB_NET_CDCETHER = true;
  USB_NET_CDC_SUBSET = true;

  BACKLIGHT_CLASS_DEVICE = true;

  TYPEC = true;
  TYPEC_TCPM = true;
  TYPEC_TCPCI = true;
  TYPEC_UCSI = true;
  UCSI_ACPI = true;
  TYPEC_DP_ALTMODE = true;

  MMC = true;
  MMC_BLOCK = true;

  USB4 = true;

  KFENCE_SAMPLE_INTERVAL = "500";
}
