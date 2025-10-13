{ option, lib, hostPlatform }: {
  PREEMPT_VOLUNTARY = true;
  HZ_100 = option false;
  HZ_300 = true;
}
