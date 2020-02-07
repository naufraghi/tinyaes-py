set shell := ["bash", "-c"]

list:
	@just --list

PY := "python"

env:
	#!/bin/bash
	if [[ "{{PY}}" == "python3" ]]; then
	  [[ -e .env-$HOSTNAME-{{PY}} ]] || {{PY}} -m venv .env-$HOSTNAME-{{PY}}
	else
	  [[ -e .env-$HOSTNAME-{{PY}} ]] || {{PY}} -m virtualenv .env-$HOSTNAME-{{PY}}
	fi
	. .env-$HOSTNAME-{{PY}}/bin/activate
	{{PY}} -m pip install -U pip

clean:
	rm -rfv .env-$HOSTNAME-python*
	rm -rfv build dist __pycache__ *.egg-info .hypothesis

run COMMAND: env
	#!/bin/bash
	. .env-$HOSTNAME-{{PY}}/bin/activate
	{{COMMAND}}

install:
	just PY={{PY}} run "python -m pip install -e ."

dev-install:
	just PY={{PY}} run "python -m pip install pytest hypothesis"

_test:
	#!/usr/bin/env python
	import tinyaes
	print(tinyaes)
	from tinyaes import AES
	cipher = AES(b'0123456789ABCDEF')
	data = b'ciao'
	print("data:", data)
	encrypted = cipher.CTR_xcrypt_buffer(data)
	print("encrypted:", encrypted)
	cipher = AES(b'0123456789ABCDEF')
	decrypted = cipher.CTR_xcrypt_buffer(encrypted)
	print("decrypted:", decrypted)

_test_null_iv:
	#!/usr/bin/env python
	import tinyaes
	print(tinyaes)
	from tinyaes import AES
	cipher = AES(b'0123456789ABCDEF', b'\x00'*16)
	data = b'ciao'
	print("data:", data)
	encrypted = cipher.CTR_xcrypt_buffer(data)
	print("encrypted:", encrypted)
	cipher = AES(b'0123456789ABCDEF', b'\x00'*16)
	decrypted = cipher.CTR_xcrypt_buffer(encrypted)
	print("decrypted:", decrypted)

test: install dev-install
	just PY={{PY}} run "just _test && just _test_null_iv"
	just PY={{PY}} run "python -m pytest . -v"

dist:
	just PY={{PY}} run "python -m pip install cython setuptools wheel"
	just PY={{PY}} run "python setup.py sdist"
	just PY={{PY}} run "python setup.py bdist_wheel"
