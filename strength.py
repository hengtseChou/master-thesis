from three_lvl_designs.utils import has_strength

effects = [
    (0, 1, 0, 1),
    (0, 2, 0, 1),
    (2, 0, 0, 1),
    (1, 0, 0, 1),
    # (1, 0, 1, 0),
    # (2, 0, 1, 0),
    # (0, 1, 1, 0),
    # (0, 2, 1, 0),
    (1, 1, 1, 0),
    (2, 2, 1, 0),
    (1, 2, 1, 0),
    (2, 1, 1, 0),
]
print(has_strength(effects, 4))  # True
