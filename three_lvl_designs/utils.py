import numpy as np


def offseting_effect(effect: tuple) -> tuple:
    effect = np.array(effect)
    non_zero_indices = np.flatnonzero(effect)
    if non_zero_indices.size > 0 and effect[non_zero_indices[0]] != 1:
        return tuple((effect * 2) % 3)
    return tuple(effect)
