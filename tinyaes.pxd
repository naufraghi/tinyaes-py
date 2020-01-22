# CTR is a stream cipher that can be used as an alternative to CBC
# https://stackoverflow.com/questions/1220751/how-to-choose-an-aes-encryption-mode-cbc-ecb-ctr-ocb-cfb

# cython: language_level = 2

from libc.stdint cimport uint8_t, uint32_t

cdef extern from "aes.h":
    cdef struct AES_ctx:
        pass

    # Initialize context calling one of:
    void AES_init_ctx(AES_ctx* ctx, const uint8_t* key);
    void AES_init_ctx_iv(AES_ctx* ctx, const uint8_t* key, const uint8_t* iv);

    # ... or reset IV at random point:
    void AES_ctx_set_iv(AES_ctx* ctx, const uint8_t* iv);

    # Then start encrypting and decrypting with the functions below:
    void AES_ECB_encrypt(const AES_ctx* ctx, uint8_t* buf);
    void AES_ECB_decrypt(const AES_ctx* ctx, uint8_t* buf);

    void AES_CBC_encrypt_buffer(AES_ctx* ctx, uint8_t* buf, uint32_t length);
    void AES_CBC_decrypt_buffer(AES_ctx* ctx, uint8_t* buf, uint32_t length);

    # Same function for encrypting as for decrypting in CTR mode
    void AES_CTR_xcrypt_buffer(AES_ctx* ctx, uint8_t* buf, uint32_t length);
