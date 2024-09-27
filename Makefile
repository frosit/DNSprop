# Variables
CC = gcc
CFLAGS = -Wall -g

# Combine all scripts into one
build/combined_script.sh: src/requirements.sh src/utils.sh src/main.sh
	if [ -f $@ ]; then rm $@; fi
	cat $^ > $@
	chmod +x $@

compile: src/compiled.sh src/utils/consts.sh src/utils/env.sh src/utils/log.sh src/utils/output.sh src/utils/requirements.sh src/utils/record.sh src/utils/utils.sh src/cli.sh src/commands.sh src/main.sh
	if [ -f build/DNSprop.sh ]; then rm build/DNSprop.sh; fi
	cat $^ > build/DNSprop.sh
	chmod +x build/DNSprop.sh


# Run shellcheck on all scripts
lint: shellcheck src/*.sh

# Run tests using BATS
test: build/combined_script.sh
	bats tests/test.bats

test-fail:
	bats --print-output-on-failure tests/test.bats
# Clean build directory
clean: build/combined_script.sh
	rm $^
