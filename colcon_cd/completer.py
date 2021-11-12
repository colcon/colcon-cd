# Copyright 2021 Chen Bainian
# Licensed under the Apache License, Version 2.0

from colcon_argcomplete.argument_parser.argcomplete.completer.package_name \
    import package_name_completer
import argcomplete
import argparse
from argcomplete.completers import SuppressCompleter


def main():
    """
    Fake command with parser for colcon_cd completer.

    Using --external-argcomplete-script to construct
    a bash completer for the colcon_cd command.
    """
    parser = argparse.ArgumentParser()

    # base_path argument is needed for package_name_completer
    parser.add_argument(
        "--base-paths",
        default='.').completer = SuppressCompleter()

    # Add --set and --unset argument for the completer
    parser.add_argument("--set")

    parser.add_argument("--unset")

    # Add package name completer
    parser.add_argument(
        'package_name').completer = package_name_completer

    argcomplete.autocomplete(parser)
    parser.parse_args()
