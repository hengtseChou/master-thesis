from itertools import permutations
from three_lvl_designs.utils import addup, power
from three_lvl_designs.designs import full_factorial
from math import factorial
from tqdm import tqdm
import numpy as np

effects = [
    (1, 0, 0),
    (2, 0, 0),
    (0, 1, 0),
    (0, 2, 0),
    (0, 0, 1),
    (0, 0, 2),
    (1, 1, 0),
    (2, 2, 0),
    (0, 1, 1),
    (0, 2, 2),
    (1, 0, 1),
    (2, 0, 2),
    (1, 2, 0),
    (2, 1, 0),
    (0, 1, 2),
    (0, 2, 1),
    (1, 0, 2),
    (2, 0, 1),
    (1, 1, 1),
    (2, 2, 2),
    (1, 1, 2),
    (2, 2, 1),
    (1, 2, 1),
    (2, 1, 2),
    (1, 2, 2),
    (2, 1, 1),
]

def mod_3(a):
    return a % 3
# pbar = tqdm(total=factorial(len(effects)))
# for per in permutations(effects, len(effects)):
#     ab = []
#     ab_squared = []
#     for pair in zip(effects, per):
#         ab.append(mod_3(addup(pair[0], pair[1])))
#         ab_squared.append(mod_3(addup(pair[0], power(pair[1], 2))))
#     # done third group and fourth group computation
#     pbar.update(1)
#     if len(set(ab)) == len(effects) and len(set(ab_squared)) == len(effects):
#         print(per)
#         break

effects_np = [np.array(effect) for effect in effects]

pbar = tqdm(total=factorial(len(effects)))
for per in permutations(effects_np, len(effects_np)):
    ab = []
    ab_squared = []
    for pair in zip(effects_np, per):
        ab.append(mod_3(pair[0] + pair[1]))
        ab_squared.append(mod_3(pair[0] + pair[1] ** 2))
    # done third group and fourth group computation
    pbar.update(1)
    if len(set(map(tuple, ab))) == len(effects_np) and len(
        set(map(tuple, ab_squared))
    ) == len(effects_np):
        print(per)
        break


