#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generate a shorted prompt for either bash or fish
"""

__author__ = """
Ralph W. Crosby
ralphcrosby@gmail.com
"""

# **************************************************

import os

# **************************************************

def run(max_len, min_seg):

    seg_part = int((min_seg - 3) / 2)

    cwd = os.getcwd()

    prompt_cwd = cwd

    # Reduce Home directory to '~'

    prompt_cwd = prompt_cwd.replace(os.path.expanduser('~'), '~')
    prompt_len = len(prompt_cwd)

    # Break into pieces

    parts = os.path.normpath(prompt_cwd).split(os.path.sep)

    # First pass, reduce all but last segment to xxx...xxx format

    for i, dirname in enumerate(parts[:-1]):
        # print(i, prompt_len, dirname)
        if prompt_len <= max_len:
            break
        if len(dirname) < 9:
            continue
        cl = len(dirname)
        parts[i] = dirname[:seg_part] + '...' + dirname[-seg_part:]
        prompt_len -= cl - len(parts[i])

    # If we're still too long even without the last segment, reduce parts to
    # single characters

    # print(len(parts[-1]))
    # print(parts)

    i = 0
    while prompt_len > max_len and i < len(parts) - 1:
        # print(i, prompt_len, len(parts[i]), parts[i])
        if len(parts[i]):
            prompt_len -= len(parts[i]) - 1
            parts[i] = parts[i][0]
        i += 1

    # print(prompt_len)

    # If we're still too long, reduce the last segment to no shorter than xxx...xxx

    if prompt_len > max_len:
        available = max_len - (prompt_len - len(parts[-1]))
        final_len = max(available, 9)
        seg_len = int((final_len - seg_part) / 2)
        last = parts[-1]
        last_trimmed = last[:seg_len] + '...' + last[-seg_len:]
        parts[-1] = last_trimmed
        # print(available, final_len, seg_len, last, last_trimmed)

    print(os.sep.join(parts), end='')

# **************************************************

if __name__ == '__main__':
    try:
        max_len = int(os.environ['PROMPT_MAX_LEN'])
    except KeyError:
        max_len = 60

    try:
        min_seg = int(os.environ['PROMPT_MIN_SEGMENT_LEN'])
    except KeyError:
        min_seg = 9

    run(max_len, min_seg)
