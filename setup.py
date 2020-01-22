from setuptools import setup, find_packages, Extension
from Cython.Build import cythonize


setup(name='tinyaes',
      description='tiny-AES-c wrapper in Cython',
      version='1.0.0a1',
      author='Matteo Bertini',
      author_email='<naufraghi@develer.com>',
      license='MPL-2.0',
      ext_modules=cythonize([Extension('tinyaes',
                                       sources=['tinyaes.pyx', 'tiny-AES-c/aes.c'],
                                       include_dirs=['tiny-AES-c/'])
                            ]),
      packages=find_packages('tinyaes'),
)
