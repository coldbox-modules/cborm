#!/bin/sh
# Run build process
ant -f workbench/build.xml
# Get exit code from build process
export exitCode=$?
# If failure, then get diagnostic data from server
if [ $exitCode == 1 ]; then
	curl http://localhost:49616/tests/runner.cfm?reporter=text -o /tmp/output.txt
	cat /tmp/output.txt
fi