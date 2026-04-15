.PHONY: test test-file clean-deps

# Run the full test suite headlessly.
test:
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "lua MiniTest.run()" -c "qa!"

# Run a single test file, e.g. `make test-file FILE=tests/test_reflow.lua`.
test-file:
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "lua MiniTest.run_file('$(FILE)')" -c "qa!"

# Wipe the bootstrapped mini.nvim clone (forces re-clone on next run).
clean-deps:
	rm -rf "$$(nvim --headless -c 'echo stdpath(\"cache\")' -c 'qa!' 2>&1)/reflow-markdown-test-deps"
