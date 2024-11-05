{ option, lib, hostPlatform }: {
  HYPERVISOR_GUEST = true;
  PARAVIRT = true;
  PARAVIRT_SPINLOCKS = true;
  KVM_GUEST = true;
  ARCH_CPUIDLE_HALTPOLL = true;
  PARAVIRT_CLOCK = true;

  HALTPOLL_CPUIDLE = true;

  FW_CFG_SYSFS = true;

  BLK_MQ_VIRTIO = true;
  VIRTIO_BLK = true;
  VIRTIO_NET = true;
  VIRTIO_CONSOLE = true;

  HW_RANDOM_VIRTIO = true;

  DRM = true;
  DRM_FBDEV_EMULATION = true;
  DRM_VIRTIO_GPU = true;
  DRM_VIRTIO_GPU_KMS = true;
  DRM_BOCHS = true;
  DRM_SIMPLEDRM = true;

  VIRT_DRIVERS = true;
  VMGENID = true;

  VIRTIO_MENU = true;
  VIRTIO = true;
  VIRTIO_PCI = true;
  VIRTIO_PCI_LEGACY = false;
  VIRTIO_BALLOON = true;
  VIRTIO_INPUT = true;

  VIRTIO_IOMMU = true;

  FUSE_FS = true;
  VIRTIO_FS = true;
}
