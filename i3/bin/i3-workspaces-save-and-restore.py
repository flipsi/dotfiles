#!/usr/bin/env python

import os
import i3
import sys
import pickle


PATH = "/home/sflip/.i3/workspace_mapping"


def showHelp():
    print(sys.argv[0] + " [save|restore]")


if __name__ == '__main__':
    if len(sys.argv) < 2:
        showHelp()
        sys.exit(1)

    if sys.argv[1] == 'save':
        pickle.dump(i3.get_workspaces(), open(PATH, "wb"))
    elif sys.argv[1] == 'restore':
        try:
            workspace_mapping = pickle.load(open(PATH, "rb"))
        except Exception:
            print("Can't find existing mappings...")
            sys.exit(1)

        for workspace in workspace_mapping:
            i3.msg('command', 'workspace %s' % workspace['name'])
            i3.msg('command', 'move workspace to output %s' % workspace['output'])
        for workspace in filter(lambda w: w['visible'], workspace_mapping):
            i3.msg('command', 'workspace %s' % workspace['name'])
    else:
        showHelp()
        sys.exit(1)
