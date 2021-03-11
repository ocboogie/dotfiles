#!/usr/bin/python

# Shameless copied and paste from https://github.com/swaywm/sway/blob/master/contrib/inactive-windows-transparency.py

import argparse
import i3ipc
import signal
import sys
from functools import partial

def on_window_focus(appId, ipc, event):
    global prev_focused

    focused = event.container

    if focused.id != prev_focused:
        if prev_focused.app_id == appId:
            prev_focused.command("kill")
        prev_focused = focused

def close(ipc):
    ipc.main_quit()
    sys.exit(0)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="This script allows you to close windows with specify app ids when they lose focus"
    )
    parser.add_argument(
        "--app-id",
        "-a",
        type=str,
        default="launcher",
        help="specify app id to be closed",
    )
    args = parser.parse_args()

    ipc = i3ipc.Connection()
    prev_focused = None

    print(args.app_id)

    for window in ipc.get_tree():
        if window.focused:
            prev_focused = window
            break;

    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: close(ipc))

    ipc.on("window::focus", partial(on_window_focus, args.app_id))
    ipc.main()


