{ option, lib, hostPlatform }: {
  PREEMPT_RT = true;
  HZ_100 = option false;
  HZ_1000 = true;
}
