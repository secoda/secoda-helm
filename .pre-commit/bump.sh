#!/usr/bin/env bash

set -euo pipefail

export PATH=$PATH:/usr/local/bin

function error {
	echo -e "
[x] Encountered error on pre-commit script: ${BASH_SOURCE[0]}
	Message: $1
"
exit 1
}

function wasChartYamlChanged {
	if [[ -f "$1/Chart.yaml" ]]; then
		[[ -n $(git diff --cached $1/Chart.yaml) ]] && return 0 # checks if there are changes to chart.yaml
	fi

	return 1
}

function wasVersionChanged {
	git diff --cached $1/Chart.yaml | grep -q +version > /dev/null # if the 'version' line wasnt changed, return false
	[[ $? != 0 ]] && return 1

	BEFORE=$(git diff --cached $1/Chart.yaml | grep -- '-version:' | awk '{ print $2 }')
	AFTER=$(git diff --cached $1/Chart.yaml | grep -- '+version:' | awk '{ print $2 }')

	[[ "$BEFORE" != "$AFTER" ]] && return 0

	return 1
}


which semver-tool > /dev/null || error "Please install semver-tool: https://github.com/fsaintjacques/semver-tool"

# get the charts that were changed, and insert their folders into an array
read -a CHANGED_CHARTS <<< $(git diff --cached --name-status | awk '{ print $2 }' | xargs -I '{}' dirname '{}' | uniq | tr '/' ' ' | awk '{ print $1 }' | uniq | tr '\n' ' ')

for CHART in "${CHANGED_CHARTS[@]}"; do
	echo "[x] Checking $CHART chart for version bumps"

	# check if the version in Chart.yaml was changed
	if wasChartYamlChanged "$CHART" && wasVersionChanged "$CHART"; then
		echo "	Version was manually changed, not bumping!"

	else
		if [[ -f "$CHART/Chart.yaml" ]]; then
			echo "	Chart '$CHART' version bumped:"
			OLD_VER=$(cat $CHART/Chart.yaml | grep -E "^version: " | awk '{ print $2 }')
			NEW_VER=$(semver-tool bump patch $OLD_VER)

			echo "		Before: $OLD_VER | After: $NEW_VER"
			sed -i '' "s/^version:.*/version: $NEW_VER/g" $CHART/Chart.yaml
			git add $CHART/Chart.yaml
		fi
	fi

	echo "" # new line
done;

exit