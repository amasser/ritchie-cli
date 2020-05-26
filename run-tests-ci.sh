#!/bin/sh

cd /home/application

./wait-for-it.sh "stubby4j:8882" && echo "stubby4j is up"

export REMOTE_URL=http://stubby4j:8882

PACKAGE_NAMES=$(go list ./pkg/... | circleci tests split --split-by=timings --timings-type=classname)

gotestsum --format=short-verbose --junitfile $TEST_RESULTS_DIR/gotestsum-report.xml -- -p 2 -cover -coverprofile=coverage.txt $PACKAGE_NAMES

testStatus=$?
if [ $testStatus -ne 0 ]; then
    echo "Tests failed"
    exit 1
fi
