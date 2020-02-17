set shell := ["bash", "-c"]


ci-bootstrap:
	#!/bin/bash
	pushd ../..
	git submodule update --init
	python -m pip install -U pip

ci-test:
	#!/bin/bash
	pushd ../..
	python -m pip install .
	python -m pip install -r requirements-dev.txt
	python -m pytest . -v

ci-dist:
	#!/bin/bash
	pushd ../..
	python -m pip install -r requirements-dist.txt
	python setup.py sdist bdist_wheel
