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
    "qcom/x1e80100/LENOVO/21N1/X1E80100-LENOVO-Thinkpad-T14s-tplg.bin"
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
    ARM64_PTR_AUTH = false;
    ARM64_POE = false;
    ARM64_HAFT = false;
    ARM64_GCS = false;

    ARM_PSCI_CPUIDLE = true;
    ARM_PSCI_CPUIDLE_DOMAIN = true;
    ARM_SCMI_CPUFREQ = true;

    VIRTUALIZATION = true;
    KVM = true;

    SCHED_SMT = false;
    SHADOW_CALL_STACK = true;

    BT_HCIUART = true;
    BT_HCIUART_QCA = true;

    CMA = true;

    HOTPLUG_PCI = false;
    PCIE_QCOM = true;
    PCI_PWRCTRL_TC9563 = false;

    QCOM_EBI2 = false;

    EFI_DISABLE_RUNTIME = true;

    QCOM_QSEECOM = true;
    QCOM_QSEECOM_UEFISECAPP = true;

    ARM_SCMI_PROTOCOL = true;
    ARM_SCMI_TRANSPORT_MAILBOX = true;

    NVME_CORE = true;
    BLK_DEV_NVME = true;
    NVME_VERBOSE_ERRORS = true;
    NVME_HWMON = true;

    QCOM_FASTRPC = true;
    SRAM = true;

    WLAN = true;
    ATH12K = true;

    INPUT_MOUSEDEV = true;

    KEYBOARD_ATKBD = false;
    KEYBOARD_GPIO = true;

    INPUT_MOUSE = true;

    INPUT_MISC = true;
    INPUT_PM8941_PWRKEY = true;

    SERIAL_QCOM_GENI = true;

    I2C = true;
    I2C_QUP = true;
    I2C_QCOM_CCI = true;
    I2C_QCOM_GENI = true;
    I2C_HID = true;
    I2C_HID_OF = true;

    SPI = true;
    SPI_QUP = true;
    SPI_QCOM_GENI = true;

    DEVFREQ_THERMAL = true;
    QCOM_TSENS = true;
    QCOM_SPMI_TEMP_ALARM = true;
    QCOM_LMH = true;

    SPMI = true;

    PINCTRL_MSM = true;
    PINCTRL_X1E80100 = true;
    PINCTRL_QCOM_SPMI_PMIC = true;
    PINCTRL_LPASS_LPI = true;
    PINCTRL_SC8280XP_LPASS_LPI = true;
    PINCTRL_SM8550_LPASS_LPI = true;

    POWER_RESET_QCOM_PON = true;

    POWER_SEQUENCING_QCOM_WCN = true;

    BATTERY_QCOM_BATTMGR = true;

    WATCHDOG = true;
    QCOM_WDT = true;

    MFD_SPMI_PMIC = true;

    REGULATOR = true;
    REGULATOR_FIXED_VOLTAGE = true;
    REGULATOR_QCOM_RPMH = true;

    MEDIA_PLATFORM_SUPPORT = true;
    MEDIA_PLATFORM_DRIVERS = true;
    V4L_PLATFORM_DRIVERS = true;
    VIDEO_QCOM_CAMSS = true;
    VIDEO_QCOM_IRIS = true;
    VIDEO_OV02C10 = true;

    DRM_MSM = true;
    DRM_MSM_MDP4 = false;
    DRM_MSM_MDP5 = false;
    DRM_MSM_DPU = true;
    DRM_MSM_DP = true;
    DRM_MSM_DSI = false;
    DRM_MSM_HDMI = false;
    DRM_DISPLAY_CONNECTOR = true;
    DRM_PANEL_SAMSUNG_ATNA33XC20 = true;
    DRM_PANEL_EDP = true;

    BACKLIGHT_PWM = true;

    SND_PCI = false;

    SND_SOC = true;
    SND_SOC_QCOM = true;
    SND_SOC_X1E80100 = true;
    SND_SOC_WCD938X_SDW = true;
    SND_SOC_LPASS_WSA_MACRO = true;
    SND_SOC_LPASS_VA_MACRO = true;
    SND_SOC_LPASS_RX_MACRO = true;
    SND_SOC_LPASS_TX_MACRO = true;

    QCOM_RPMHPD = true;

    PM_DEVFREQ = true;
    DEVFREQ_GOV_SIMPLE_ONDEMAND = true;

    HID_MULTITOUCH = true;

    USB_PCI = false;
    USB_DWC3 = true;

    TYPEC_QCOM_PMIC = true;
    TYPEC_MUX_GPIO_SBU = true;
    TYPEC_MUX_PS883X = true;
    UCSI_PMIC_GLINK = true;
    TYPEC_TBT_ALTMODE = false;

    MMC_SDHCI = true;
    MMC_SDHCI_PLTFM = true;
    MMC_SDHCI_MSM = true;

    LEDS_QCOM_FLASH = true;
    LEDS_QCOM_LPG = true;

    EDAC_QCOM = true;

    RTC_DRV_PM8XXX = true;

    QCOM_GPI_DMA = true;

    EC_LENOVO_THINKPAD_T14S = true;

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

    HWSPINLOCK = true;
    HWSPINLOCK_QCOM = true;

    FSL_ERRATUM_A008585 = false;
    HISILICON_ERRATUM_161010101 = false;
    ARM64_ERRATUM_858921 = false;

    MAILBOX = true;
    QCOM_CPUCP_MBOX = true;
    QCOM_IPCC = true;

    ARM_SMMU = true;
    ARM_SMMU_V3 = true;

    REMOTEPROC = true;
    QCOM_Q6V5_ADSP = true;
    QCOM_Q6V5_PAS = true;

    RPMSG_QCOM_GLINK_SMEM = true;

    SOUNDWIRE = true;
    SOUNDWIRE_QCOM = true;

    QCOM_AOSS_QMP = true;
    QCOM_COMMAND_DB = true;
    QCOM_GENI_SE = true;
    QCOM_LLCC = true;
    QCOM_PD_MAPPER = true;
    QCOM_PMIC_GLINK = true;
    QCOM_RPMH = true;
    QCOM_SMEM = true;
    QCOM_SMP2P = true;
    QCOM_SOCINFO = true;
    QCOM_APR = true;
    QCOM_ICC_BWMON = true;

    IIO = true;

    ARM_PMU = true;
    ARM_PMUV3 = true;

    USB4 = false;

    NVMEM_QCOM_QFPROM = true;
    NVMEM_SPMI_SDAM = true;

    TEE = true;
    QCOMTEE = true;

    PWM = true;

    QCOM_PDC = true;

    RESET_GPIO = true;
    RESET_SCMI = false;

    PHY_SNPS_EUSB2 = true;
    PHY_NXP_PTN3222 = true;
    PHY_QCOM_EDP = true;
    PHY_QCOM_QMP = true;
    PHY_QCOM_EUSB2_REPEATER = true;

    MUX_GPIO = true;

    INTERCONNECT = true;
    INTERCONNECT_QCOM = true;
    INTERCONNECT_QCOM_X1E80100 = true;

    CRYPTO_DEV_QCE = true;
    CRYPTO_DEV_QCOM_RNG = true;

    DMA_CMA = true;
    CMA_SIZE_MBYTES = 128;

    CORESIGHT = true;
    CORESIGHT_LINK_AND_SINK_TMC = true;
    CORESIGHT_STM = true;
    CORESIGHT_TPDM = true;
    CORESIGHT_TPDA = true;
    CORESIGHT_DUMMY = true;
  };
}
