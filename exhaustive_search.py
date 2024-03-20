import argparse
import json
import pprint
from itertools import combinations
from math import comb

import numpy as np
from tqdm import tqdm


def offseting_effect(effect: np.ndarray) -> np.ndarray:
    non_zero_indices = np.flatnonzero(effect)
    if non_zero_indices.size > 0 and effect[non_zero_indices[0]] != 1:
        return (effect * 2) % 3
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
        # Apply the offseting_effect function to C
        element_C_offset = offseting_effect(element_C)
        design_C.append(element_C_offset)

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
        # Apply the offseting_effect function to D
        element_D_offset = offseting_effect(element_D)
        design_D.append(element_D_offset)

    return design_D


def filter_effects(effects, exclude):
    return np.array(
        [e for e in effects if not any(np.array_equal(e, ex) for ex in exclude)]
    )


def has_repeated_array(*lists_of_arrays):
    """Check if there are any repeated arrays across multiple lists of arrays."""
    checked_arrays = []
    for list_of_arrays in lists_of_arrays:
        for arr in list_of_arrays:
            if any(np.array_equal(arr, checked_arr) for checked_arr in checked_arrays):
                return True
            checked_arrays.append(arr)
    return False


def nparray_to_tuple(list_of_arrays):
    return [tuple(map(int, arr)) for arr in list_of_arrays]


def read_json_file(file_path):
    try:
        with open(file_path, "r", encoding="utf-8") as file:
            data = json.load(file)
            if not isinstance(data, list):
                raise ValueError("JSON root is not a list, cannot append data.")
            return data
    except (FileNotFoundError, json.JSONDecodeError):
        return []


def custom_json_stringify(data):
    result = "[\n"
    for obj in data:
        obj_str = "  {\n"
        for key, value in obj.items():
            # Convert list of lists to a single-line JSON string
            value_str = json.dumps(value).replace("],", "], ")
            obj_str += f'    "{key}": {value_str},\n'
        obj_str = (
            obj_str.rstrip(",\n") + "\n  },\n"
        )  # Remove the last comma and add closing braces
        result += obj_str
    result = (
        result.rstrip(",\n") + "\n]"
    )  # Remove the last comma from the result string and add closing bracket
    return result


def write_json_file(json_file_path, data):
    json_string = custom_json_stringify(data)
    with open(json_file_path, "w", encoding="utf-8") as file:
        file.write(json_string)


def add_design_to_file(design: dict, json_file_path="result.json"):
    data = read_json_file(json_file_path)
    data.append(design)  # Append the new design to the existing data list
    print(data)
    write_json_file(json_file_path, data)


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

parser = argparse.ArgumentParser()
parser.add_argument("idx", help="index of selecting design A", type=int)
parser.add_argument(
    "--first-only", help="print out the first design and exit", action="store_true"
)
args = parser.parse_args()

if args.idx < 0 or args.idx >= len(design_As):
    raise ValueError("Index out of range.")


design_A = design_As[args.idx]
remaining_effects = filter_effects(effects, design_A)
pbar = tqdm(total=comb(len(remaining_effects), 10))

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
        tqdm.write("design found. saved to file.")
    pbar.update(1)

    if args.first_only:
        tqdm.write(
            pprint.pformat(
                {
                    "design A": nparray_to_tuple(design_A),
                    "design B": nparray_to_tuple(design_B),
                    "design C": nparray_to_tuple(design_C),
                    "design D": nparray_to_tuple(design_D),
                }
            )
        )
        exit()

print(f"search with index={args.idx} completed.")
