"""
This script generates a data structure for test.

You must use Python 3.8 or greater (may work with earlier version, but not tested).

Just run: python generate_data.py
"""

import json


class Rand:
    COUNTER: int = 3

    @staticmethod
    def rand(in_from: int, in_to: int) -> int:
        Rand.COUNTER = ((Rand.COUNTER * 17) % (in_to - in_from)) + in_from
        return Rand.COUNTER


RECORD_COUNT: int = 10

NAMES: tuple = ("Liam",
                "Olivia",
                "Noah",
                "Emma",
                "Oliver",
                "Ava",
                "Elijah",
                "Charlotte",
                "William",
                "Sophia",
                "James",
                "Amelia",
                "Benjamin",
                "Isabella",
                "Lucas",
                "Mia",
                "Henry",
                "Evelyn",
                "Alexander",
                "Harper")


for rec_idx in range(RECORD_COUNT):
    students = [NAMES[(rec_idx + (5*i)) % len(NAMES)] for i in range((2 + rec_idx*5) % len(NAMES))]
    rec: dict = {
        "students": students,
        "results".format(rec_idx): {name: note for (name, note) in [(i, sum(ord(ch) for ch in i) % 20) for i in students]},
        "details": {"a": [Rand.rand(0, 100) for i in range(Rand.rand(0, 10))],
                    "b": {k: v for k, v in
                          [(NAMES[Rand.rand(0, len(NAMES)-1)], Rand.rand(0, 100)) for _ in range(Rand.rand(1, 5))]
                          }
                    }
    }
    if Rand.rand(0, 2):
        rec['details']['c'] = Rand.rand(0, 200)

    if not rec_idx % 3:
        rec["note"] = "Very well {} !".format(rec_idx)
    print(json.dumps(rec, sort_keys=True))

