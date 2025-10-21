{ option, lib, hostPlatform }: {
  PREEMPT_VOLUNTARY = hostPlatform.isAarch;
  PREEMPT_LAZY = with hostPlatform; isx86 || isRiscV;
  HZ_100 = option false;
  HZ_300 = true;
}
