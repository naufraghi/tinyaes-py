#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2020 Matteo Bertini <naufraghi@develer.com>

import os
from setuptools import setup, find_packages, Extension


try:
    from Cython.Build import cythonize
except ImportError:
    cythonize = None

if cythonize is not None and os.path.exists("tinyaes.pyx"):
    # Development mode, rebuild the .c file
    maybe_cythonize = cythonize
    source = "tinyaes.pyx"
else:
    # Pass-through (sdist installation)
    maybe_cythonize = list
    source = "tinyaes.c"
    assert os.path.exists("tinyaes.c"), "Install Cython to build this package from sources"

with open("README.md", "rb") as f:
    long_description = f.read().decode("utf-8")

setup(
    name="tinyaes",
    description="tiny-AES-c wrapper in Cython",
    long_description=long_description,
    long_description_content_type="text/markdown",
    version="1.0.2",
    author="Matteo Bertini",
    author_email="naufraghi@develer.com",
    url="https://github.com/naufraghi/tinyaes-py",
    license="MIT",
    ext_modules=maybe_cythonize(
        [
            Extension(
                "tinyaes",
                sources=[source, "tiny-AES-c/aes.c"],
                include_dirs=["tiny-AES-c/"],
            )
        ]
    ),
    packages=find_packages("tinyaes"),
    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        "Development Status :: 5 - Production/Stable",
        # Indicate who your project is intended for
        "Intended Audience :: Developers",
        "Topic :: Security :: Cryptography",
        # Pick your license as you wish (should match "license" above)
        "License :: OSI Approved :: MIT License",
        # Specify the Python versions you support here. In particular, ensure
        # that you indicate whether you support Python 2, Python 3 or both.
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        # Source language
        "Programming Language :: Cython",
    ],
    keywords="AES Cryptography block-cipher stream-cipher",
)
