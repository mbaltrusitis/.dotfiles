#!/usr/bin/env sh

arr1=()
arr2=(4,5,6)

realArray=("${arr1[@]:-${arr2[@]}}")

echo "$realArray[@]"

while getopts "f:" option; do
	case "${option}" in
		"f")
			programsFileList+=("${OPTARG}")
			;;
		"h")
			printf "Optional arguments for custom use:\\n  -r: Dotfiles repository (local file or url)\\n  -p: Dependencies and programs csv (local file or url)\\n  -a: AUR helper (must have pacman-like syntax)\\n  -h: Show this message\\n" && exit 1
			;;
		*)
			printf "Invalid option: -%s\\n" "$OPTARG" && exit 1
			;;
	esac
done

fullProgramList="$(mktemp programs.XXXXXX)"

if [ ${#programsFileList[@]} -eq 0 ]; then
	echo "it empty";
else
	echo "it not empty";
fi

for fileName in "${programsFileList[@]}"; do
	cat "$fileName" >> "$fullProgramList"
done

#echo "full file:"

cat "$fullProgramList"

aurinstall() {
	printf "AUR: %s %s\\n" "$1" "${2-}"
	#su -c "$aurhelper -S --noconfirm "$1"" - "$username"
}

aurinstall "one"
#echo "done";

#while IFS="" read -r p || [ -n "$p" ]
#do
	#printf '%s\n' "$p"
#done < "$(cat 1.txt 2.txt 3.txt)"


