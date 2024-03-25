import itertools
import pprint

from .utils import offseting_effect


def _sort_effect(t):
    # Count of zeros as the primary key, negative to sort in reverse (more zeros first)
    # The tuple itself as the secondary key for sorting by values when zero counts are the same
    zero_count = -t.count(0)
    return zero_count, t


class FullFactorial:

    def __init__(self, k: int) -> None:
        try:
            self.k = int(k)
        except ValueError:
            raise ValueError("k must be an integer.")
        if self.k < 2:
            raise ValueError("k must be greater than or equal to 2.")
        self._effects = self._effects_generator()

    def __getitem__(self, idx) -> list[tuple]:
        return self._effects[idx]

    def __str__(self) -> str:
        return pprint.pformat(self._effects)

    def _effects_generator(self) -> list[tuple]:

        effects = list(itertools.product(range(3), repeat=self.k))
        effects = [offseting_effect(effect) for effect in effects]
        effects = [effect for effect in set(effects)]
        effects.remove(tuple(0 for _ in range(self.k)))
        effects = sorted(effects, key=_sort_effect)

        return effects

    @property
    def effects(self) -> list[tuple]:
        return self._effects

    def main_effects(self) -> list[tuple]:
        return [effect for effect in self._effects if effect.count(0) == self.k - 1]

    def interactions(self, num_of_factors: int) -> list[tuple]:
        try:
            num_of_factors = int(num_of_factors)
        except ValueError:
            raise ValueError("num of factors must be an integer.")
        if num_of_factors > self.k:
            raise ValueError("num of factors must not be larger than k.")

        return [eff for eff in self._effects if eff.count(0) == self.k - num_of_factors]


def full_factorial(k: int) -> FullFactorial:
    return FullFactorial(k=k)
