from typing import Optional, Union

class AES:
    """Cython wrapper for the tiny-AES-c library."""
    def __init__(self, key: bytes, iv: Optional[bytes] = None) -> None:
        """Initialize context with key and optional iv."""
        ...
    def set_iv(self, iv: bytes) -> None:
        """Reset the IV at a random point."""
        ...
    def CTR_xcrypt_buffer(self, data: Union[bytes, bytearray]) -> bytes:
        """Encrypt/decrypt a copy of the buffer in CTR mode."""
        ...
    def CTR_xcrypt_buffer_inplace(self, data: bytearray) -> None:
        """Encrypt/decrypt the buffer in-place in CTR mode."""
        ...
    def CBC_encrypt_buffer_inplace_raw(self, data: Union[bytes, bytearray]) -> None:
        """Encrypt the buffer in-place in CBC mode (manual padding required)."""
        ...
    def CBC_decrypt_buffer_inplace_raw(self, data: Union[bytes, bytearray]) -> None:
        """Decrypt the buffer in-place in CBC mode (manual unpadding required)."""
        ...
