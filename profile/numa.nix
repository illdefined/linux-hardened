{ option, lib, hostPlatform }: {
  NUMA = true;
  NUMA_BALANCING = true;
  NUMA_BALANCING_DEFAULT_ENABLED = true;
} // lib.optionalAttrs hostPlatform.is86_64 {
  AMD_NUMA = option false;
  X86_64_ACPI_NUMA = true;
}
