{ option, lib, hostPlatform }: {
  WIRELESS = true;
  CFG80211 = true;
  CFG80211_DEFAULT_PS = true;
  CFG80211_CRDA_SUPPORT = true;
  MAC80211 = true;
  MAC80211_RC_MINSTREL = true;
  MAC80211_RC_DEFAULT_MINSTREL = true;
  MAC80211_LEDS = true;

  BT = true;
  BT_BREDR = true;
  BT_RFCOMM = true;
  BT_HIDP = true;
  BT_LE = true;
  BT_LEDS = true;

  BT_HCIBTUSB_AUTOSUSPEND = option true;
  BT_HCIBTUSB_BCM = option false;
  BT_HCIBTUSB_RTL = option false;

  RFKILL = true;
  RFKILL_INPUT = true;

  # iwd
  KEYS = true;
  CRYPTO_USER_API_SKCIPHER = true;
  CRYPTO_USER_API_HASH = true;
  CRYPTO_HMAC = true;
  CRYPTO_CMAC = true;
  CRYPTO_MD4 = true;
  CRYPTO_MD5 = true;
  CRYPTO_SHA1 = true;
  CRYPTO_SHA256 = true;
  CRYPTO_SHA512 = true;
  CRYPTO_AES = true;
  CRYPTO_ECB = true;
  CRYPTO_DES = true;
  CRYPTO_CBC = true;

  ASYMMETRIC_KEY_TYPE = option true;
  ASYMMETRIC_PUBLIC_KEY_SUBTYPE = option true;
  X509_CERTIFICATE_PARSER = option true;
  PKCS7_MESSAGE_PARSER = option true;
  PKCS8_PRIVATE_KEY_PARSER = option true;
} // lib.optionalAttrs hostPlatform.isx86_64 {
  CRYPTO_AES_NI_INTEL = option true;
  CRYPTO_DES3_EDE_X86_64 = option true;
} // lib.optionalAttrs hostPlatform.isRiscV64 {
  CRYPTO_AES_RISCV64 = option true;
} // lib.optionalAttrs hostPlatform.isAarch64 {
  CRYPTO_AES_ARM64_CE = option true;
  CRYPTO_AES_ARM64_CE_BLK = option true;
}
