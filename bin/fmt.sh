#!/bin/bash

# Applies requisite code formatters to the source tree

set -ex
SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )
source $SCRIPTPATH/use_bazel_go.sh

ROOTDIR=$SCRIPTPATH/..
cd $ROOTDIR


GO_FILES=$(find cmd pkg -type f -name '*.go')

UX=$(uname)

#remove blank lines so gofmt / goimports can do their job
for fl in ${GO_FILES}; do
	if [[ ${UX} == "Darwin" ]];then
		sed -i '' -e "/^import[[:space:]]*(/,/)/{ /^\s*$/d;}" $fl
	else
		sed -i -e "/^import[[:space:]]*(/,/)/{ /^\s*$/d;}" $fl
	fi
done
gofmt -s -w ${GO_FILES}
goimports -w -local istio.io ${GO_FILES}
buildifier -mode=fix $(find cmd pkg -name BUILD -type f)
buildifier -mode=fix ./BUILD
buildifier -mode=fix ./BUILD.api
