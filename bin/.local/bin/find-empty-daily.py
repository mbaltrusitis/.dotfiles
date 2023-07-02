#!/usr/bin/env python3

import os
import re
from sys import argv
from typing import (
    List,
)

def find_daily_files(directory) -> List[str]:
    daily_files = []
    for root, _dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".md"):
                daily_files.append(os.path.join(root, file))
    return daily_files


def get_abs_path(path):
    return os.path.abspath(os.path.expanduser(path))


def main() -> None:
    rel_path = argv[1]
    abs_path = get_abs_path(rel_path)

    regex = r"^---\ndate: [0-9]{4}-[0-9]{2}-[0-9]{2}\n---\n# [0-9]{4}.[0-9]{2}.[0-9]{2}\n## tasks \/ intentions\.\n- \[ \] \n\n## notes\.\n- $"

    test_str = (
        "---\n"
        "date: 2023-06-27\n"
        "---\n"
        "# 2023.06.27\n"
        "## tasks / intentions.\n"
        "- [ ] \n\n"
        "## notes.\n"
        "- "
    )

    # matches = re.finditer(regex, test_str, re.MULTILINE)

    daily_files = find_daily_files(abs_path)

    empty_daily = []
    for df in daily_files:
        with open(df, mode="r") as file:
            file_contents = file.read()
            if re.fullmatch(regex, file_contents):
                print("-" * (len(df) + 15))
                print(f'file match:    {df}')
                print(f'file contents:\n{file_contents}\n\n')
                print("-" * (len(df) + 15))
                empty_daily.append(df)

    dest_dir = get_abs_path("~/Documents/for_delete")
    os.makedirs(dest_dir, exist_ok=True)

    for ed in empty_daily:
        src_basename = os.path.basename(ed)
        dest_path = get_abs_path(f"{dest_dir}/{src_basename}")

        print(f"from: {ed} to: {dest_path}")
        os.rename(ed, dest_path)

    # for matchNum, match in enumerate(matches, start=1):
    #     print(
    #         "Match {matchNum} was found at {start}-{end}: {match}".format(
    #             matchNum=matchNum,
    #             start=match.start(),
    #             end=match.end(),
    #             match=match.group(),
    #         )
    #     )
    #
    #     for groupNum in range(0, len(match.groups())):
    #         groupNum = groupNum + 1
    #
    #         print(
    #             "Group {groupNum} found at {start}-{end}: {group}".format(
    #                 groupNum=groupNum,
    #                 start=match.start(groupNum),
    #                 end=match.end(groupNum),
    #                 group=match.group(groupNum),
    #             )
    #         )


if __name__ == "__main__":
    main()
