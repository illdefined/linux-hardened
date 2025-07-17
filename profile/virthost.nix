{ option, lib, hostPlatform }: {
  VIRTUALIZATION = true;
  KVM = true;

  PCI_IOV = true;

  MACVLAN = true;
  MACVTAP = true;
  IPVLAN = true;
  IPVTAP = true;
} // lib.optionalAttrs hostPlatform.isx86 {
  KVM_INTEL = option true;
  KVM_AMD = option true;
  KVM_AMD_SEV = option true;
  KVM_SMM = true;
  KVM_HYPERV = true;

  DRM_I915_GVT_KVMGT = option true;
}
