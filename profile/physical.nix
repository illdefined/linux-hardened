{ option, lib, hostPlatform }: {
  ACPI_BUTTON = true;
  ACPI_FAN = true;
  ACPI_TAD = true;
  ACPI_PROCESSOR_AGGREGATOR = true;
  ACPI_THERMAL = true;
  ACPI_PCI_SLOT = true;

  SCSI = true;
  BLK_DEV_SD = true;
  CHR_DEV_SG = true;
  SCSI_CONSTANTS = true;
  SCSI_SCAN_ASYNC = true;

  I2C_CHARDEV = true;

  USB_STORAGE = true;
  USB_UAS = true;

  NEW_LEDS = true;
  LEDS_CLASS = true;
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
}
