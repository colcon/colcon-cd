# Copyright 2021 Chen Bainian
# Licensed under the Apache License, Version 2.0

import argparse

import argcomplete
from colcon_argcomplete.argument_parser.argcomplete.completer.package_name \
    import package_name_completer


def main():
    """
    Fake command with parser for colcon_cd completer.

    Using package_name_completer to construct
    a bash completer for the colcon_cd command.
    """
    parser = argparse.ArgumentParser()

    # base_path argument is needed for package_name_completer
    parser.add_argument(
        '--base-paths',
        default='.')

    # Add --set and --reset argument for the completer
    parser.add_argument('--set')

    parser.add_argument('--reset')

    # Add package name completer
    parser.add_argument(
        'package_name').completer = package_name_completer

    argcomplete.autocomplete(parser)
    parser.parse_args()


if __name__ == '__main__':
    main()
