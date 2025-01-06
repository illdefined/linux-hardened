{
  instSetArch = "generic-rv64";
  platformProfiles = {
    physical = true;
  };
  
  platformConfig = { option, lib, hostPlatform }: {
    ARCH_SOPHGO = true;
    ERRATA = {
      THEAD = true;
      THEAD_MAE = true;
      THEAD_CMO = true;
      THEAD_PMU = true;
    };

    NR_CPUS = 128;
    NODES_SHIFT = 3;

    ETHOC = true;
    R8169 = true;
    STMMAC_ETH = true;

    SERIAL = {
      "8250_DW" = true;
      OF_PLATFORM = true;
    };

    GPIO = {
      DWAPB = true;
    };

    PWM = true;
    PWM_SIFIVE = true;

    SENSORS = {
      LM90 = true;
      PWM_FAN = true;
    };

    USB = {
      DWC2 = true;
    };

    MMC = {
      SDHCI = true;
      SDHCI_PLTFM = true;
    };
  };
}
