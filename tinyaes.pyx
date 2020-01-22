# Copyright (c) 2020 Matteo Bertini <naufraghi@develer.com>

cimport tinyaes
from libc.stdint cimport uint8_t, uint32_t

cdef uint8_t AES_KEYLEN = 16
cdef uint8_t AES_BLOCKLEN = 16

cdef class AES:
    cdef tinyaes.AES_ctx _ctx
    def __cinit__(self, uint8_t* key, uint8_t* iv=NULL):
        if len(key) != AES_KEYLEN:
            raise ValueError(f"AES128 needs a 16 bytes key, but len(key) = {len(key)}")
        if iv is not NULL and len(iv) != AES_BLOCKLEN:
            raise ValueError(f"AES128 needs a 16 bytes iv (or nothing), but len(iv) = {len(iv)}")
        if iv is NULL:
            tinyaes.AES_init_ctx(&self._ctx, key)
        else:
            tinyaes.AES_init_ctx_iv(&self._ctx, key, iv)
    cdef _CTR_xcrypt_buffer_raw(self, uint8_t* data):
        tinyaes.AES_CTR_xcrypt_buffer(&self._ctx, data, len(data))
    def CTR_xcrypt_buffer(self, uint8_t* data):
        inout = data[:]
        self._CTR_xcrypt_buffer_raw(inout)
        return inout
    def CTR_xcrypt_buffer_inplace(self, bytearray data):
        self._CTR_xcrypt_buffer_raw(data)
