import json
import os
import sys
from itertools import combinations

import numpy as np
from tqdm import tqdm


def offseting_effect(effect: np.ndarray) -> np.ndarray:
    # Find the index of the first non-zero element
    non_zero_indices = np.nonzero(effect)[0]
    if len(non_zero_indices) > 0:
        first_non_zero_index = non_zero_indices[0]
        first_non_zero_value = effect[first_non_zero_index]

        # If the first non-zero digit is not 1, multiply the array by 2 and mod 3
        if first_non_zero_value != 1:
            return (effect * 2) % 3

    # Return the original array if the first non-zero digit is 1 or the array is all zeros
    return effect


def generate_design_C(
    design_A: list[np.ndarray], design_B: list[np.ndarray]
) -> list[np.ndarray]:
    if len(design_A) != len(design_B):
        raise ValueError("design_A and design_B must have the same length.")

    design_C = []
    for element_A, element_B in zip(design_A, design_B):
        # Perform the element-wise operation
        element_C = (element_A + element_B) % 3
        # Apply the offseting_effect_np function to C
        D_transformed = element_C
        design_C.append(D_transformed)

    return design_C


def generate_design_D(
    design_A: list[np.ndarray], design_B: list[np.ndarray]
) -> list[np.ndarray]:
    if len(design_A) != len(design_B):
        raise ValueError("design_A and design_B must have the same length.")

    design_D = []
    for element_A, element_B in zip(design_A, design_B):
        # Perform the element-wise operation
        element_D = (element_A + element_B * 2) % 3
        # Apply the offseting_effect_np function to D
        D_transformed = offseting_effect(element_D)
        design_D.append(D_transformed)

    return design_D


def filter_effects(effects, design_A):
    """Filter out arrays in design_A from effects."""
    remaining_effects = []
    for effect in effects:
        if not any(np.array_equal(effect, a) for a in design_A):
            remaining_effects.append(effect)
    return remaining_effects


def has_repeated_array(*lists_of_arrays):
    """Check if there are any repeated arrays across multiple lists of arrays."""
    checked_arrays = []
    for list_of_arrays in lists_of_arrays:
        for arr in list_of_arrays:
            # Check if arr is equal to any array we've already checked
            if any(np.array_equal(arr, checked_arr) for checked_arr in checked_arrays):
                return True
            checked_arrays.append(arr)
    return False


def nparray_to_tuple(list_of_arrays):
    return [tuple(arr) for arr in list_of_arrays]


def add_design_to_file(design: dict[list], json_file_path="result.json"):
    if not os.path.exists(json_file_path):
        with open(json_file_path, "w") as file:
            json.dump([], file)
    with open(json_file_path, "r+", encoding="utf-8") as file:
        # Try to load the existing JSON content
        try:
            data = json.load(file)
            if not isinstance(data, list):
                raise ValueError("JSON root is not a list, cannot append data.")
        except json.JSONDecodeError:
            # File is empty or not valid JSON; start a new list
            data = []

        # Append the new list of tuples
        data.append(design)

        # Move back to the beginning of the file to overwrite it
        file.seek(0)
        # Convert the updated data back to JSON and save it to the file
        json.dump(data, file, ensure_ascii=False)


# (a, b, c, d)
effects = [
    (1, 0, 0, 0),  # main effect 0:4
    (0, 1, 0, 0),
    (0, 0, 1, 0),
    (0, 0, 0, 1),
    (1, 1, 0, 0),  # two-factor interaction 4:16
    (1, 2, 0, 0),
    (1, 0, 1, 0),
    (1, 0, 2, 0),
    (1, 0, 0, 1),
    (1, 0, 0, 2),
    (0, 1, 1, 0),
    (0, 1, 2, 0),
    (0, 1, 0, 1),
    (0, 1, 0, 2),
    (0, 0, 1, 1),
    (0, 0, 1, 2),
    (1, 1, 1, 0),  # three-factor interaction 16: 32
    (1, 1, 2, 0),
    (1, 2, 1, 0),
    (1, 2, 2, 0),
    (1, 1, 0, 1),
    (1, 1, 0, 2),
    (1, 2, 0, 1),
    (1, 2, 0, 2),
    (1, 0, 1, 1),
    (1, 0, 1, 2),
    (1, 0, 2, 1),
    (1, 0, 2, 2),
    (0, 1, 1, 1),
    (0, 1, 1, 2),
    (0, 1, 2, 1),
    (0, 1, 2, 2),
    (1, 1, 1, 1),  # four-factor interaction 32:40
    (1, 1, 1, 2),
    (1, 1, 2, 1),
    (1, 1, 2, 2),
    (1, 2, 1, 1),
    (1, 2, 1, 2),
    (1, 2, 2, 1),
    (1, 2, 2, 2),
]

effects = [np.array(effect) for effect in effects]

main_effect = effects[0:4]
two_fi = effects[4:16]
three_fi = effects[16:32]
four_fi = effects[32:40]

design_As = list(combinations(four_fi, 6))
design_As = [main_effect + list(candidate) for candidate in design_As]

print(len(design_As))

if len(sys.argv) < 2:
    raise ValueError("need index of possible design A")
try:
    idx = int(sys.argv[1])
except ValueError:
    raise ValueError("must input valid index")
if idx < 0 or idx > 27:
    raise ValueError("must input valid index")

design_A = design_As[idx]

print(f"current design A :{nparray_to_tuple(design_A)}")

pbar = tqdm(total=30045015)
remaining_effects = filter_effects(effects, design_A)

for design_B in combinations(remaining_effects, 10):

    design_B = list(design_B)
    design_C = generate_design_C(design_A, design_B)
    design_D = generate_design_D(design_A, design_B)

    if not has_repeated_array(design_A, design_B, design_C, design_D):
        add_design_to_file(
            design={
                "design A": nparray_to_tuple(design_A),
                "design B": nparray_to_tuple(design_B),
                "design C": nparray_to_tuple(design_C),
                "design D": nparray_to_tuple(design_D),
            }
        )
        print("design found. saved to file.")
    pbar.update(1)

print(f"search with index={idx} completed.")
