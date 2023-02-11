# Copyright (c) 2020 Matteo Bertini <naufraghi@develer.com>

cimport tinyaes
from libc.stdint cimport uint8_t, uint32_t

cdef uint8_t AES_KEYLEN = 16
cdef uint8_t AES_BLOCKLEN = 16


cdef class AES:
    cdef tinyaes.AES_ctx _ctx
    def __cinit__(self, bytes key, bytes iv=None):
        # `uint8_t* data` interface is not usable, because the Cython wrapper
        # detects the buffer lenght searching the final NULL character, that
        # may occur inside the buffer itself.
        if len(key) != AES_KEYLEN:
            raise ValueError(f"AES128 needs a 16 bytes key, but len(key) = {len(key)}")
        if iv is not None and len(iv) != AES_BLOCKLEN:
            raise ValueError(f"AES128 needs a 16 bytes iv (or nothing), but len(iv) = {len(iv)}")
        if iv is None:
            tinyaes.AES_init_ctx(&self._ctx, key)
        else:
            tinyaes.AES_init_ctx_iv(&self._ctx, key, iv)
    def CTR_xcrypt_buffer(self, data):
        inout = bytearray(data)
        # TODO: check if in the Python interpreter invariants is valid to
        # create and mutate inplace a `bytes` buffer, instead of creating a
        # `bytearray`, mutating it and returning back `bytes`.
        tinyaes.AES_CTR_xcrypt_buffer(&self._ctx, inout, len(inout))
        return bytes(inout)
    def CTR_xcrypt_buffer_inplace(self, bytearray data):
        tinyaes.AES_CTR_xcrypt_buffer(&self._ctx, data, len(data))

    def CBC_encrypt_buffer_inplace(self, data):
        if len(data) % AES_KEYLEN:
            raise ValueError(f"Length of plaintext must be multiple of {AES_KEYLEN} bytes")
        tinyaes.AES_CBC_encrypt_buffer(&self._ctx, data, len(data))
    def CBC_decrypt_buffer_inplace(self, data):
        if len(data) % AES_KEYLEN:
            raise ValueError(f"Length of plaintext must be multiple of {AES_KEYLEN} bytes")
        tinyaes.AES_CBC_decrypt_buffer(&self._ctx, data, len(data))
