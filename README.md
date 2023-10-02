# tiny-AES-c Cython wrapper
[![PyPI version](https://badge.fury.io/py/tinyaes.svg)](https://pypi.org/project/tinyaes/)

[`tinyaes`](https://github.com/naufraghi/tinyaes-py) is a few lines Cython
wrapper for the [`tiny-AES-c`](https://github.com/kokke/tiny-AES-c) library, a
_Small portable AES128/192/256 in C_.

The library offers a few modes, CTR and CBC modes are the only ones currently wrapped.
Given the C API works modifying a buffer in-place, the wrapper offers:

- `CTR_xcrypt_buffer(..)` that works on all bytes convertible types, and
  encrypting a copy of the buffer,
- `CTR_xcrypt_buffer_inplace(..)` that works on `bytearray`s only, modifying
  the buffer in-place.
- `CBC_encrypt_buffer_inplace_raw(..)` that works on `bytearray`s only, modifying
  the buffer in-place (manual padding).
- `CBC_decrypt_buffer_inplace_raw(..)` that works on `bytearray`s only, modifying
  the buffer in-place (manual unpadding).

<details><summary>CBC usage Example:</summary>

```
import tinyaes
import binascii


def pad(m):
    return m + bytes([16 - len(m) % 16] * (16 - len(m) % 16))


def unpad(ct):
    return ct[:-ct[-1]]


# assign key and IV
aes_enc = tinyaes.AES(bytes.fromhex('11223344556677889900AABBCCDDEEFF'),
                      bytes.fromhex('FFEEDDCCBBAA00998877665544332211'))
aes_dec = tinyaes.AES(bytes.fromhex('11223344556677889900AABBCCDDEEFF'),
                      bytes.fromhex('FFEEDDCCBBAA00998877665544332211'))

text = b"hello"
print(text)  # b'hello'
# padding plaintext to a multiple of block size
text = pad(text)
print(binascii.hexlify(bytearray(text)))  # b'68656c6c6f0b0b0b0b0b0b0b0b0b0b0b' hex representation of added text
aes_enc.CBC_encrypt_buffer_inplace_raw(text)  # b'5adc04828f9421c34210b05fe5c92bfd' hex representation of encrypted text
print(binascii.hexlify(bytearray(text)))
aes_dec.CBC_decrypt_buffer_inplace_raw(text)
print(unpad(text)) # b'hello' decrypted, original text
```

</details>

## Release notes

- 1.1.0rc1 (Oct 2, 2023)
  - Add Python 3.12 final to the matrix
  - Expose _raw_ functions for CBC mode, with manual padding and unpadding
- 1.1.0rc0 (13 Feb 2023)
  - Drop support for Python 2.7 (CI tests and builds are disabled, code may still work)
  - Add support for CBC mode (unstable API, inplace only, manual padding)
- **1.0.4** (Nov 3, 2022)
  - Final release with Python 3.11
- 1.0.4rc1 (Oct 24, 2022)
  - add Python 3.11 to the matrix, remove Python 2.7 and 3.6
- **1.0.3** (Feb 22, 2022)
  - Final release with Python 3.10
- 1.0.3rc1 (Nov 4, 2021):
  - add Python 3.10 to the matrix
- **1.0.2** (Nov 4, 2021):
  - version bump from 1.0.2rc1
  - bump to `manylinux2010` because of tlsv1 errors and drop Python 2.7
    missing in the new image
- 1.0.2rc1 (Apr 7, 2021):
  - added release Python 3.9 on Windows, Linux (`manylinux1`) and OSX
  - updated upstream [`tiny-AES-c`](https://github.com/kokke/tiny-AES-c) with
    some cleanups and small optimizations
- **1.0.1** (Jun 8, 2020):
  - release Python 3.6 OSX and Windows wheels
  - updated upstream [`tiny-AES-c`](https://github.com/kokke/tiny-AES-c) with
    some code changes
- **1.0.0** (Feb 20, 2020): updated readme (no code changes)
- 1.0.0a3 (Feb 7, 2020): fix bytes in-place mutation error
- 1.0.0a2 (Jan 29, 2020): first public release

## Like to help?

The CI is up and running, but on Linux only, running a minimal test suite that
uses [hypothesis](https://hypothesis.works), and that allowed me to find a
first bug, a missed variable replacement that had nefarious consequences.

The source package released on PyPI should be usable on Windows and MacOS too,
just `pip install tinyaes`.

The development instead is Linux centered, without any guide yet, but the CI
script can be a guide.

### TL;DR

- Download [Just](https://github.com/casey/just) and put it in your `PATH`.
- `just test` should install the library and the dependencies and run the tests
  using your default Python version.
- Inspect the `justfile` for some hints about what happens.

## Thanks

The library is very minimal, but nonetheless, it uses a lot of existing
software. I'd like to thank:

- [Cython](https://cython.org) developer for their wonderful "product", both
  the library and the documentation.

- Kudos to `kokke` for their [tiny-AES-c](https://github.com/kokke/tiny-AES-c)
  library, very minimal and easy to build and wrap for any usage that needs only
  the few AES modes it exposes.

- [Just](https://github.com/casey/just) developers for their automation tool,
  I use in most of my projects.

- A huge thank to all the [hypothesis](https://github.com/HypothesisWorks/hypothesis)
  authors to their fantastic library, that helped me to find an miss-named
  variable bug that I worked very hard to add in a 6 lines of code wrapper! And
  to this [Data-driven testing with Python](https://www.develer.com/en/data-driven-testing-with-python/)
  article that had left me with the desire to try the library.
