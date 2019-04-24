#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Create the parts of a password

Random Word
Random Number
Special Character
"""

__author__ = """
Ralph W. Crosby
ralph.crosby@navy.mil
SSCLANT Charleston, SC
"""

__all__ = []

# **************************************************

import argparse
import numpy as np

DICT_NAME = '/usr/share/dict/web2'
SPECIAL_CHARS = list(r'!@#$%^&*(){}[];:<>,.')

# **************************************************

def parse_command_line(cmd=None):

    p = argparse.ArgumentParser(description=__doc__)

    p.add_argument('-w', '--wordlen',
                   nargs=2,
                   type=int,
                   default=[5, 8],
                   help="""Min and max word length""")

    p.add_argument('-d', '--digitlen',
                   default=4,
                   type=int,
                   help="""Max random number length""")

    p.add_argument('-n', '--numpasswords',
                   type=int,
                   default=5,
                   help="""Number of passwords to generate""")

    p.add_argument('--dict_name',
                   default=DICT_NAME,
                   help="""Word dictionary to load""")

    return p.parse_args(cmd) if cmd else p.parse_args()

# **************************************************

def load_dictionary(dname, minlen, maxlen):
    """
    Load only words of the requested length
    """

    words = []
    with open(dname, 'r') as f:

        for word in f:
            word = word.strip()
            if minlen <= len(word) <= maxlen:
                words.append(word)

    np.random.shuffle(words)

    print(f"{len(words)} loaded")

    return words

# **************************************************

def run(wordlen=[5, 8],
        digitlen=4,
        numpasswords=5,
        dict_name=DICT_NAME):

    words = load_dictionary(dict_name, *wordlen)

    for n in range(numpasswords):

        w = words.pop()
        i = np.random.choice(SPECIAL_CHARS)
        s = np.random.randint(0, 10**digitlen)
        print(f"{w} {i} {s:0{digitlen}d}")


# **************************************************

if __name__ == '__main__':
    opts = parse_command_line()
    run(**vars(opts))
