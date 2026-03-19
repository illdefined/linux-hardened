{
  targetCPU = "oryon-1";
  platformProfiles = {
    physical = true;
    portable = true;
    wireless = true;
    audio = true;
  };

  platformFirmware = [
    "qcom/gen70500_gmu.bin"
    "qcom/gen70500_sqe.fw"
    "qcom/x1e80100/LENOVO/21N1/adsp_dtbs.elf"
    "qcom/x1e80100/LENOVO/21N1/cdsp_dtbs.elf"
    "qcom/x1e80100/LENOVO/21N1/qcadsp8380.mbn"
    "qcom/x1e80100/LENOVO/21N1/qccdsp8380.mbn"
    "qcom/x1e80100/LENOVO/21N1/qcdxkmsuc8380.mbn"
    "qcom/x1e80100/LENOVO/21N1/qcvss8380.mbn"
  ];

  platformConfig = { option, lib, hostPlatform }: {
    ARCH_QCOM = true;

    NR_CPUS = 12;
    ARM64_EPAN = false;
    ARM64_POE = false;
    ARM64_HAFT = false;
    ARM64_GCS = false;

    ARM_PSCI_CPUIDLE = true;
    ARM_PSCI_CPUIDLE_DOMAIN = true;
    ARM_QCOM_CPUFREQ_HW = true;
    ACPI_CPPC_CPUFREQ = false;

    VIRTUALIZATION = true;
    KVM = true;

    SCHED_SMT = false;
    SHADOW_CALL_STACK = true;

    PCIE_QCOM = true;

    BT_HCIUART = true;
    BT_HCIUART_QCA = true;

    ARM_SCMI_PROTOCOL = true;
    ARM_SCMI_TRANSPORT_MAILBOX = true;

    NVME_CORE = true;
    BLK_DEV_NVME = true;
    NVME_VERBOSE_ERRORS = true;
    NVME_HWMON = true;

    QCOM_FASTRPC = true;

    WLAN = true;
    ATH12K = true;

    KEYBOARD_GPIO = true;

    INPUT_MOUSEDEV = true;

    INPUT_MOUSE = true;
    MOUSE_PS2 = true;
    MOUSE_PS2_TRACKPOINT = true;

    INPUT_MISC = true;
    INPUT_PM8941_PWRKEY = true;

    SERIAL_QCOM_GENI = true;

    I2C = true;
    I2C_QUP = true;
    I2C_QCOM_GENI = true;
    I2C_HID = true;
    I2C_HID_OF_ELAN = true;

    SPI = true;
    SPI_QUP = true;
    SPI_QCOM_GENI = true;

    QCOM_TSENS = true;
    QCOM_LMH = true;

    SPMI = true;

    PINCTRL_MSM = true;
    PINCTRL_SM8550 = true;
    PINCTRL_QCOM_SPMI_PMIC = true;
    PINCTRL_LPASS_LPI = true;
    PINCTRL_SC8280XP_LPASS_LPI = true;
    PINCTRL_SM8550_LPASS_LPI = true;

    POWER_RESET_QCOM_PON = true;

    POWER_SEQUENCING_QCOM_WCN = true;

    BATTERY_QCOM_BATTMGR = true;

    MFD_SPMI_PMIC = true;

    REGULATOR = true;
    REGULATOR_FIXED_VOLTAGE = true;
    REGULATOR_QCOM_RPMH = true;

    MEDIA_PLATFORM_SUPPORT = true;
    MEDIA_PLATFORM_DRIVERS = true;
    VIDEO_QCOM_IRIS = true;

    DRM_MSM = true;
    DRM_MSM_DPU = true;
    DRM_MSM_DP = true;
    DRM_MSM_HDMI = true;
    DRM_PANEL_SAMSUNG_ATNA33XC20 = true;
    DRM_PANEL_EDP = true;

    BACKLIGHT_PWM = true;

    SND_SOC = true;
    SND_SOC_QCOM = true;
    SND_SOC_X1E80100 = true;
    SND_SOC_WCD938X_SDW = true;
    SND_SOC_LPASS_WSA_MACRO = true;
    SND_SOC_LPASS_VA_MACRO = true;
    SND_SOC_LPASS_RX_MACRO = true;
    SND_SOC_LPASS_TX_MACRO = true;

    QCOM_RPMHPD = true;

    HID_MULTITOUCH = true;

    USB_PCI = false;
    USB_DWC3 = true;

    TYPEC_QCOM_PMIC = true;
    TYPEC_MUX_GPIO_SBU = true;
    TYPEC_MUX_PS883X = true;
    UCSI_ACPI = false;
    UCSI_PMIC_GLINK = true;
    TYPEC_TBT_ALTMODE = false;

    MMC_SDHCI = true;
    MMC_SDHCI_PLTFM = true;
    MMC_SDHCI_MSM = true;

    LEDS_QCOM_LPG = true;

    EDAC_QCOM = true;

    RTC_DRV_PM8XXX = true;

    QCOM_GPI_DMA = true;

    EC_LENOVO_THINKPAD_T14S = true;

    HWSPINLOCK = true;
    HWSPINLOCK_QCOM = true;

    COMMON_CLK = true;
    COMMON_CLK_QCOM = true;
    CLK_X1E80100_CAMCC = true;
    CLK_X1E80100_DISPCC = true;
    CLK_X1E80100_GCC = true;
    CLK_X1E80100_GPUCC = true;
    CLK_X1E80100_TCSRCC = true;
    QCOM_CLK_RPMH = true;
    SC_LPASSCC_8280XP = true;
    SM_VIDEOCC_8550 = true;

    MAILBOX = true;
    QCOM_CPUCP_MBOX = true;
    QCOM_IPCC = true;

    ARM_SMMU_V3 = false;
    QCOM_IOMMU = true;

    REMOTEPROC = true;
    QCOM_Q6V5_ADSP = true;
    QCOM_Q6V5_PAS = true;

    RPMSG_QCOM_GLINK_RPM = true;

    SOUNDWIRE = true;
    SOUNDWIRE_QCOM = true;

    QCOM_COMMAND_DB = true;
    QCOM_GENI_SE = true;
    QCOM_LLCC = true;
    QCOM_PMIC_GLINK = true;
    QCOM_RPMH = true;
    QCOM_SMEM = true;
    QCOM_SMP2P = true;
    QCOM_APR = true;
    QCOM_ICC_BWMON = true;

    ARM_PMUV3 = true;

    USB4 = false;

    NVMEM_QCOM_QFPROM = true;

    TEE = true;
    QCOMTEE = true;

    PWM = true;

    PHY_SNPS_EUSB2 = true;
    PHY_NXP_PTN3222 = true;
    PHY_QCOM_EDP = true;
    PHY_QCOM_QMP = true;

    MUX_GPIO = true;

    INTERCONNECT = true;
    INTERCONNECT_QCOM = true;
    INTERCONNECT_QCOM_SC8280XP = true;
    INTERCONNECT_QCOM_X1E80100 = true;

    CORESIGHT = true;
    CORESIGHT_LINK_AND_SINK_TMC = true;
    CORESIGHT_STM = true;
    CORESIGHT_TPDM = true;
    CORESIGHT_TPDA = true;
    CORESIGHT_DUMMY = true;
  };
}
