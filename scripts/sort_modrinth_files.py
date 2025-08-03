#!python3
# Sort the files in a Modrinth project JSON file by their path.
# This makes the git history a bit cleaner and easier to read when updating included mods.


import json
import sys


def main(filename):
    with open(filename, 'r') as fin:
        json_obj = json.load(fin)
    json_obj['files'] = sorted(json_obj['files'], key=lambda x: x['path'])

    print(json.dumps(json_obj, indent=2))


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python sort_modrinth_files.py <modrinth.index.json path>")
        sys.exit(1)
    main(sys.argv[1])