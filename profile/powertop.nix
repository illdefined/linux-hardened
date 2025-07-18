{ option, lib, hostPlatform }: {
  PM_DEBUG = true;
  PM_ADVANCED_DEBUG = true;

  LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY = false;
  LOCK_DOWN_KERNEL_FORCE_INTEGRITY = true;

  DEBUG_FS = true;
  DEBUG_FS_ALLOW_ALL = true;

  BLK_DEV_IO_TRACE = true;
} // lib.optionalAttrs hostPlatform.isx86 {
  X86_MSR = true;
}
