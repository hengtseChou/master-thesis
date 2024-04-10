import numpy as np


def offseting_effect(effect: tuple) -> tuple:
    effect = np.array(effect)
    non_zero_indices = np.flatnonzero(effect)
    if non_zero_indices.size > 0 and effect[non_zero_indices[0]] != 1:
        return tuple((effect * 2) % 3)
    return tuple(effect)


def interaction_component(a: tuple, b: tuple, power_of_b: int = 1):
    """Compute the interaction component of a and b, or a and b^2"""
    if power_of_b not in [1, 2]:
        raise ValueError("power of b must be 1 or 2.")
    np_a = np.array(a)
    np_b = np.array(b)
    add_up = np_a + np_b * power_of_b
    return offseting_effect(tuple(add_up))


def addup(a: tuple, b: tuple) -> tuple:
    a = np.array(a)
    b = np.array(b)
    return tuple(a+b)

def mod_3(a: tuple) -> tuple:
    a = np.array(a)
    return tuple(a % 3)

def power(a: tuple, power: int) -> tuple:
    a = np.array(a)
    return tuple(a * power)