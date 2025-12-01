#!/usr/bin/env bash
# @file git-meld.sh
# @example: git-meld.sh 3 --edit
#
# @description Fixup the last `n` commits
# @arg $1 how many commits to fixup (i.e., HEAD~`$1`)

meld() {
	readonly git_count="$1"
	shift
	git reset --soft HEAD~${git_count}
	if [ "$1" = "--edit" ]; then
		git commit --amend
	else
		git commit --amend --no-edit
	fi
}

meld "$@"
