{ option, lib, hostPlatform }: {
  MD = true;
  MD_BITMAP_FILE = false;
  BLK_DEV_DM = true;
  DM_CRYPT = true;
  DM_UEVENT = true;
  DM_INTEGRITY = true;

  CRYPTO_AES = true;
  CRYPTO_XTS = true;
  CRYPTO_AEGIS128 = true;
  CRYPTO_SHA256 = true;

  CRYPTO_USER_API_HASH = true;
  CRYPTO_USER_API_SKCIPHER = true;
} // lib.optionalAttrs hostPlatform.isx86_64 {
  CRYPTO_AES_NI_INTEL = true;
  CRYPTO_AEGIS128_AESNI_SSE2 = true;
  CRYPTO_SHA256_SSSE3 = true;
} // lib.optionalAttrs hostPlatform.isRiscV64 {
  CRYPTO_AES_RISCV64 = true;
  CRYPTO_SHA256_RISCV64 = true;
} // lib.optionalAttrs hostPlatform.isAarch64 {
  CRYPTO_AES_ARM64 = true;
  CRYPTO_AES_ARM64_CE = true;
  CRYPTO_AES_ARM64_CE_BLK = true;
  CRYPTO_AES_ARM64_NEON_BLK = true;
  CRYPTO_AES_ARM64_BS = true;
  CRYPTO_AEGIS128_SIMD = true;
  CRYPTO_SHA256_ARM64 = true;
}
