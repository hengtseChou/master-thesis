from itertools import permutations, combinations, product
from three_lvl_designs.designs import full_factorial_effects
import numpy as np

effects = full_factorial_effects(k=2, offset=False)


def mod_3(a: np.ndarray):
    return a % 3


def offset_effect(a: np.ndarray):
    return (a * 2) % 3


effects_np = [np.array(effect) for effect in effects]
count = 0

# fix left-hand side of the permutation (group alpha)
for per_ in permutations(effects_np, len(effects_np)):
    # try permutation by right hand side (group beta)
    for per in permutations(effects_np, len(effects_np)):
        ab = []
        ab_squared = []
        for pair in zip(per_, per):

            ab.append(mod_3(pair[0] + pair[1]))
            ab_squared.append(mod_3(pair[0] + pair[1] * 2))

        ab_no_duplicated = len(set(map(tuple, ab))) == len(effects_np)
        ab_squared_no_duplicated = len(set(map(tuple, ab_squared))) == len(effects_np)

        if not ab_no_duplicated or not ab_squared_no_duplicated:
            continue

        # check the alpha group has res 3
        has_res_three = True
        for comb in combinations(per, 3):
            comb_extend = [[e, offset_effect(e)] for e in comb]

            for idxs in product([0, 1], repeat=3):

                add_up_and_mod = mod_3(
                    comb_extend[0][idxs[0]]
                    + comb_extend[1][idxs[1]]
                    + comb_extend[2][idxs[2]]
                )
                if (add_up_and_mod == np.array((0, 0))).all():
                    has_res_three = False

        if has_res_three:
            print(per)
