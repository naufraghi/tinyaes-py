set shell := ["powershell.exe", "-c"]


ci-bootstrap:
	cd ..\.. ; git submodule update --init
	cd ..\.. ; python -m pip install -U pip

ci-test:
	cd ..\.. ; python -m pip install .
	cd ..\.. ; python -m pip install -r requirements-dev.txt
	cd ..\.. ; python -m pytest . -v

ci-dist:
	cd ..\.. ; python -m pip install -r requirements-dist.txt
	cd ..\.. ; python setup.py bdist_wheel
