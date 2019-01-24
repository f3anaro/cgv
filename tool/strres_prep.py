#!/usr/bin/env python3
from argparse import ArgumentParser
import os


template = """
#include "cgv/base/register.h"

static const char* resource = {content};

static cgv::base::resource_string_registration reg("{name}", resource);
"""

parser = ArgumentParser(description="""String resource generator.
    The filename of the input file will be used for the resource
    registration.""")
parser.add_argument('file', help="Path to resource file")
parser.add_argument('output', help="Path to output file. Use - for stdout")

if __name__ == '__main__':
    args = parser.parse_args()

    with open(args.file, 'r') as fd:
        # Split file by lines
        lines = fd.read().splitlines(keepends=False)

        # Wrap each line with quotes including a trailing newline character.
        # Join all lines with a newline and an indentation of 4 spaces.
        escaped = map(lambda line: '"' + line.replace('\\', '\\\\') + '\\n"', lines)
        content = "\n    ".join(escaped)

    # Render template
    resource = template.format(
        name=os.path.basename(args.file),
        content=content,
    )

    if args.output == '-':
        print(resource)
    else:
        os.makedirs(os.path.dirname(args.output), exist_ok=True)
        with open(args.output, 'w') as fd:
            fd.write(resource)
