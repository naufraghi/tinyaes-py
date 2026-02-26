set shell := ["bash", "-c"]

list:
	@just --list

PY := "python"

VERSION := `python -m setuptools_scm 2>/dev/null || git describe --tags --abbrev=0 | sed 's/^v//'`

env:
	#!/bin/bash
	PY_MAYOR="$({{PY}} -c 'import sys; sys.stdout.write(str(sys.version_info[0]))')"
	PY_MINOR="$({{PY}} -c 'import sys; sys.stdout.write(str(sys.version_info[1]))')"
	PY_VERSION="${PY_MAYOR}${PY_MINOR}"
	if [[ "$(python -c 'import sys; sys.stdout.write(str(sys.version_info[0]))')" == "3" ]]; then
	  [[ -e .env-$HOSTNAME-py${PY_VERSION} ]] || {{PY}} -m venv .env-$HOSTNAME-py${PY_VERSION}
	else
	  [[ -e .env-$HOSTNAME-py${PY_VERSION} ]] || {{PY}} -m virtualenv .env-$HOSTNAME-py${PY_VERSION}
	fi
	. .env-$HOSTNAME-py${PY_VERSION}/bin/activate
	{{PY}} -m pip install -U pip

ci-bootstrap PYTHON_VERSION:
	#!/bin/bash
	git submodule update --init
	if [[ "3."* == "{{PYTHON_VERSION}}" ]]; then
	  python3 -m pip install --upgrade pip venv
	else
	  python2 -m pip install --upgrade pip virtualenv
	fi

clean:
	rm -rfv .env-$HOSTNAME-py*
	rm -rfv build dist __pycache__ *.egg-info .hypothesis

run COMMAND: env
	#!/bin/bash
	PY_MAYOR="$({{PY}} -c 'import sys; sys.stdout.write(str(sys.version_info[0]))')"
	PY_MINOR="$({{PY}} -c 'import sys; sys.stdout.write(str(sys.version_info[1]))')"
	PY_VERSION="${PY_MAYOR}${PY_MINOR}"
	. .env-$HOSTNAME-py${PY_VERSION}/bin/activate
	{{COMMAND}}

install:
	just PY={{PY}} run "python -m pip install -e ."

dev-install:
	just PY={{PY}} run "python -m pip install -r requirements-dev.txt"

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
	just PY={{PY}} run "python -m pip install -r requirements-dist.txt"
	just PY={{PY}} run "python setup.py sdist bdist_wheel"
	@echo "-------------------------------------------------------------------"
	@echo "Now you can publish with 'twine upload dist/*{{VERSION}}*.tar.gz'!!"
	ls -l dist/*{{VERSION}}*.tar.gz
	@echo "Do not forget to test bigger changes on TestPyPI:"
	@echo "https://packaging.python.org/guides/using-testpypi/#using-test-pypi"
	@echo "-------------------------------------------------------------------"

audit: dist
	just PY={{PY}} run "python -m auditwheel show dist/*{{VERSION}}*.whl"
	@echo "-------------------------------------------------------------------"
	just PY={{PY}} run "python -m auditwheel repair dist/*{{VERSION}}*.whl"
	@echo "-------------------------------------------------------------------"
	ls -l wheelhouse/*{{VERSION}}*.whl
