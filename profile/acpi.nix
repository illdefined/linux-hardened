{ option, lib, hostPlatform }: {
  ACPI = true;
  ACPI_APEI = true;
} // lib.optionalAttrs hostPlatform.isx86 {
  X86_ACPI_CPUFREQ = true;
  X86_ACPI_CPUFREQ_CPB = true;
} // lib.optionalAttrs (with hostPlatform; isAarch64 || isRiscV) {
  ACPI_CPPC_CPUFREQ = true;
}
