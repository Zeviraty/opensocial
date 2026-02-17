PYTHON := $(shell (command -v python3 >/dev/null 2>&1 && echo python3) || \
                 (command -v python >/dev/null 2>&1 && echo python) || \
                 (echo ""))

NAME := opensocial

ifeq ($(PYTHON),)
$(error No Python interpreter found (python3 or python))
endif

.PHONY: install run clean check dist distcheck

install:
	@touch clean
	@touch dbcli
	@echo '$(PYTHON) -m opensocial.db $$@' > dbcli
	@echo make run > run.sh
	@echo make clean > clean
	@chmod +x ./dbcli ./run.sh ./clean
	@mkdir logs -p
	@pip install -e . --break-system-packages
	@$(PYTHON) -m opensocial.db full-init --force

run:
	$(PYTHON) -m opensocial

clean:
	rm -rf logs/*.log

check:
	@echo "Running checks..."
	@test -d src || { echo 'Missing src/ directory'; exit 1; }
	@$(PYTHON) -m py_compile $$(find src -name '*.py') || { echo 'Syntax errors found.'; exit 1; }
	@./test || { echo 'Tests failed,'; exit 1; }
	@test -f requirements.txt || { echo 'Missing requirements.txt'; exit 1; }
	@echo "All checks passed!"

dist:
	rm -f OPENSOCIAL.tar.gz
	mkdir -p dist-temp
	find . -type f ! -name '*.pyc' ! -path './__pycache__/*' ! -path './.git/*' -exec cp --parents {} dist-temp/ \;
	tar -czf OPENSOCIAL.tar.gz -C dist-temp .
	rm -rf dist-temp

distcheck:
	@echo "Creating source distribution package..."
	@$(MAKE) dist || { echo "Error: Failed to create the distribution package"; exit 1; }

	@mkdir -p tmp-distcheck
	@tar -xzf OPENSOCIAL.tar.gz -C tmp-distcheck

	@cd tmp-distcheck/ && ./configure && make
	@cd tmp-distcheck/ && make check

	@rm -rf tmp-distcheck

	@echo "distcheck completed successfully!"
	@rm -rf OPENSOCIAL.tar.gz
