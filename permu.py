from itertools import permutations
from three_lvl_designs.designs import full_factorial_effects
import numpy as np


def mod_3(a: np.ndarray):
    return a % 3


effects = full_factorial_effects(k=2, offset=False)
effects_np = [np.array(effect) for effect in effects]
count = 0

# fix left-hand side of the permutation (group alpha)
# try permutation by right hand side (group beta)
for per in permutations(effects_np, len(effects_np)):
    ab = []
    ab_squared = []
    for pair in zip(effects_np, per):

        ab.append(mod_3(pair[0] + pair[1]))
        ab_squared.append(mod_3(pair[0] + pair[1] * 2))

    ab_no_duplicated = len(set(map(tuple, ab))) == len(effects_np)
    ab_squared_no_duplicated = len(set(map(tuple, ab_squared))) == len(effects_np)

    if ab_no_duplicated and ab_squared_no_duplicated:
        print("Found permutation for beta:")
        print([tuple(effect) for effect in per])
        break
