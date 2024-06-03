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
print(has_strength(effects, 5))  # True
# for 81 runs, 8 factors, it should be impossible to have strength 5
# strength should have all clear main effects and 2-fis
# it will requires 1 + 8 * 2 + C^8_2 * 4 degrees of freedom, which is way more than 81
