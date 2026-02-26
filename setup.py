#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2022 Matteo Bertini <naufraghi@develer.com>

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
    version="1.1.2",
    author="Matteo Bertini",
    author_email="naufraghi@develer.com",
    url="https://github.com/naufraghi/tinyaes-py",
    license="MIT",
    python_requires=">=3.10",
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
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Developers",
        "Topic :: Security :: Cryptography",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Programming Language :: Python :: 3.13",
        "Programming Language :: Python :: 3.14",
        "Programming Language :: Cython",
    ],
    keywords="AES Cryptography block-cipher stream-cipher",
)
