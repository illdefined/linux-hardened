{
  instSetArch = "alderlake";
  profiles = {
    physical = true;
    portable = true;
    wireless = true;
    audio = true;
  };
  
  platformConfig = { option, lib, hostPlatform }: {
    X86_INTEL_LPSS = true;

    CPU_SUP_INTEL = true;
    CPU_SUP_AMD = false;
    NR_CPUS = 20;
    X86_MCE_INTEL = true;

    ACPI_DPTF = true;
    DPTF_POWER = true;
    DPTF_PCH_FIVR = true;
    INTEL_IDLE = true;

    VIRTUALIZATION = true;
    KVM = true;
    KVM_INTEL = true;
    KVM_SMM = true;

    BT_INTEL = true;
    BT_HCIBTUSB = true;

    EISA = true;
    EISA_PCI_EISA = true;
    EISA_VIRTUAL_ROOT = false;
    EISA_NAMES = true;

    NVME_CORE = true;
    BLK_DEV_NVME = true;
    NVME_VERBOSE_ERRORS = true;
    NVME_HWMON = true;

    MISC_RTSX = true;
    INTEL_MEI = true;
    MISC_RTSX_PCI = true;

    WLAN = true;
    IWLWIFI = true;
    IWLMVM = true;

    INPUT_MOUSEDEV = true;

    KEYBOARD_ATKBD = true;

    INPUT_MOUSE = true;
    MOUSE_PS2 = true;
    MOUSE_PS2_TRACKPOINT = true;

    INTEL_PCH_THERMAL = true;

    MFD_CORE = true;
    MFD_INTEL_LPSS_PCI = true;

    I2C = true;
    I2C_I801 = true;

    SPI = true;
    SPI_MEM = true;
    SPI_INTEL_PCI = true;

    INT340X_THERMAL = true;

    VIDEO = true;
    VGA_SWITCHEROO = true;
    DRM = true;
    DRM_FBDEV_EMULATION = true;
    DRM_I915 = true;

    BACKLIGHT_CLASS_DEVICE = true;

    HDMI = true;

    SND_HDA_INTEL = true;
    SND_HDA_HWDEP = true;
    SND_HDA_CODEC_REALTEK = true;
    SND_HDA_CODEC_HDMI = true;
    SND_HDA_POWER_SAVE_DEFAULT = 2;

    SND_SOC = true;
    SND_SOC_SOF_TOPLEVEL = true;
    SND_SOC_SOF_PCI = true;
    SND_SOC_SOF_INTEL_TOPLEVEL = true;
    SND_SOC_SOF_TIGERLAKE = true;
    SND_SOC_SOF_HDA_LINK = true;
    SND_SOC_SOF_HDA_AUDIO_CODEC = true;
    SND_SOC_DMIC = true;

    HID_LENOVO = true;

    USB_ACM = true;

    EDAC_IGEN6 = true;

    ACPI_WMI = true;
    MXM_WMI = true;
    THINKPAD_ACPI = true;
    THINKPAD_ACPI_ALSA_SUPPORT = true;
    THINKPAD_ACPI_VIDEO = true;

    INTEL_TURBO_MAX_3 = true;
    INTEL_VSEC = true;

    INTEL_IOMMU = true;
    INTEL_IOMMU_DEFAULT_ON = true;

    SOUNDWIRE = true;
    SOUNDWIRE_INTEL = true;

    INTEL_IDMA64 = true;

    INTEL_RAPL = true;
  };

  platformFirmware = [
    "i915/adlp_dmc.bin"
    "i915/adlp_dmc_ver2_16.bin"
    "i915/adlp_guc_70.bin"
    "i915/tgl_huc.bin"
    "intel/ibt-0040-0041.sfi"
    "intel/ibt-0040-0041.ddc"
    "intel/sof/sof-adl.ri"
    "intel/sof-tplg/sof-hda-generic-2ch.tplg"
    "iwlwifi-so-a0-gf-a0-89.ucode"
    "iwlwifi-so-a0-gf-a0.pnvm"
    "regulatory.db"
    "regulatory.db.p7s"
    "rtl_nic/rtl8153b-2.fw"
  ];
}
