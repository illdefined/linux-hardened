{
  targetArch = "znver2";
  platformProfiles = {
    physical = true;
  };

  platformConfig = { option, lib, hostPlatform }: {
    CPU_SUP_INTEL = false;
    CPU_SUP_AMD = true;
    NR_CPUS = 96;
    AMD_MEM_ENCRYPT = true;

    ACPI_IPMI = true;
    ACPI_HMAT = true;

    VIRTUALIZATION = true;
    KVM = true;
    KVM_AMD = true;
    KVM_SMM = true;

    NVME_CORE = true;
    BLK_DEV_NVME = true;
    NVME_VERBOSE_ERRORS = true;
    NVME_HWMON = true;

    ATA = true;
    ATA_VERBOSE_ERROR = true;
    ATA_ACPI = true;
    SATA_PMP = true;
    SATA_AHCI = true;
    SATA_MOBILE_LPM_POLICY = 1;
    ATA_SFF = false;

    BNXT = true;
    BNXT_FLOWER_OFFLOAD = true;
    BNXT_HWMON = true; 

    IPMI_HANDLER = true;
    IPMI_PANIC_EVENT = true;
    IPMI_PANIC_STRING = true;
    IPMI_DEVICE_INTERFACE = true;
    IPMI_SI = true;
    IPMI_SSIF = true;

    I2C_PIIX4 = true;

    HWMON = true;
    SENSORS_K10TEMP = true;

    WATCHDOG = true;
    WATCHDOG_HANDLE_BOOT_ENABLED = true;
    WATCHDOG_OPEN_TIMEOUT = 0;
    WATCHDOG_SYSFS = true;
    SP5100_TCO = true;

    VIDEO = true;
    DRM = true;
    DRM_FBDEV_EMULATION = true;
    DRM_AST = true;

    EDAC_DECODE_MCE = true;
    EDAC_AMD64 = true;

    AMD_PTDMA = true;
    AMD_IOMMU = true;

    INTEL_RAPL = true;

    CRYPTO_DEV_CCP = true;
    CRYPTO_DEV_CCP_DD = true;
    CRYPTO_DEV_SP_CCP = true;
    CRYPTO_DEV_CCP_CRYPTO = true;
    CRYPTO_DEV_SP_PSP = true;
  };
}
