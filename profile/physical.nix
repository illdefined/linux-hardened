{ option, lib, hostPlatform }: {
  ACPI_BUTTON = option true;
  ACPI_FAN = option true;
  ACPI_TAD = option true;
  ACPI_THERMAL = option true;
  ACPI_PCI_SLOT = option true;

  SCSI = true;
  BLK_DEV_SD = true;
  CHR_DEV_SG = true;
  SCSI_CONSTANTS = true;
  SCSI_SCAN_ASYNC = true;

  USB_STORAGE = true;
  USB_UAS = true;

  NEW_LEDS = true;
  LEDS_CLASS = true;
  LEDS_CLASS_FLASH = option true;
  LEDS_CLASS_MULTICOLOR = option true;
  LEDS_TRIGGERS = true;
  LEDS_TRIGGER_PANIC = true;
  LEDS_TRIGGER_NETDEV = true;

  EDAC = true;

  THERMAL = true;
  THERMAL_NETLINK = true;
  THERMAL_DEFAULT_GOV_FAIR_SHARE = true;
  THERMAL_GOV_FAIR_SHARE = true;

  POWERCAP = true;

  RAS = true;
} // lib.optionalAttrs hostPlatform.isx86 {
  ACPI_PROCESSOR_AGGREGATOR = option true;
}
