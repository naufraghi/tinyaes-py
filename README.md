[![PyPI version](https://badge.fury.io/py/tinyaes.svg)](https://pypi.org/project/tinyaes/)

# tiny-AES-c Cython wrapper

[`tinyaes`](https://github.com/naufraghi/tinyaes-py) is a few lines Cython
wrapper for the [`tiny-AES-c`](https://github.com/kokke/tiny-AES-c) library, a
_Small portable AES128/192/256 in C_.

The library offers a few modes, CTR mode is the only one currently wrapped.
Given the C API works modifying a buffer in-place, the wrapper offers:

- `CTR_xcrypt_buffer(..)` that works on all bytes convertible types, and
  encrypting a copy of the buffer,
- `CTR_xcrypt_buffer_inplace(..)` that works on `bytearray`s only, modifying
  the buffer in-place.

## Release notes

- 1.0.1 (Jun 8, 2020):
  - release Python 3.6 OSX and Windows wheels
  - updated upstream [`tiny-AES-c`](https://github.com/kokke/tiny-AES-c) with
    minimal code changes
- 1.0.0 (Feb 20, 2020): updated readme (no code changes)
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
