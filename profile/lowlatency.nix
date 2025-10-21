{ option, lib, hostPlatform }: {
  PREEMPT_LAZY = with hostPlatform; isRiscV || isx86;
  PREEMPT = hostPlatform.isAarch;
  HZ_100 = option false;
  HZ_1000 = true;
}
