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
from password_strength import PasswordStats

DICT_NAME = '/usr/share/dict/web2'
SPECIAL_CHARS = list(r'!@#$%^&*(){}[];:<>,.')

# **************************************************

def parse_command_line(cmd=None):

    p = argparse.ArgumentParser(description=__doc__)

    p.add_argument('-w', '--wordlen',
                   nargs=2,
                   type=int,
                   default=[8, 10],
                   help="""Min and max word length""")

    p.add_argument('-d', '--digitlen',
                   default=3,
                   type=int,
                   help="""Max random number length""")

    p.add_argument('-n', '--numpasswords',
                   type=int,
                   default=5,
                   help="""Number of passwords to generate""")

    p.add_argument('--strength',
                   type=float,
                   default=0.6,
                   help="""Minimum password strength""")

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
        dict_name=DICT_NAME,
        strength=0.6):

    words = load_dictionary(dict_name, *wordlen)

    while numpasswords:

        try:
            w = words.pop().capitalize()
        except IndexError:
            print("Unable to get a sufficiently strong password")
            break

        s = np.random.choice(SPECIAL_CHARS)
        i = np.random.randint(0, 10**digitlen)

        comp = [w, f"{i:0{digitlen}d}", s, s]
        np.random.shuffle(comp)
        pw = ''.join(comp)

        #       pw = str(f"{s}{w}{i:0{digitlen}d}{s}")
        stats_pw = PasswordStats(pw)

        if stats_pw.strength() >= strength:
            numpasswords -= 1
            print(f"{pw} {stats_pw.strength():0.3f} {stats_pw.entropy_bits:.2f}")


# **************************************************

if __name__ == '__main__':
    opts = parse_command_line()
    run(**vars(opts))
