# Init OrderedDict in Python

To supply data via HTTP API from backends we always need to keep the keys of an output `json` in a stable order with `collections.OrderedDict`.
However it's really tedious to construct a deep-nesting OrderedDict instance key by key from scratch.

It's much more effective and readable to use `json.loads(object_pairs_hook=collections.OrderedDict)` like this:

```python
import json
from collections import OrderedDict


d = json.loads(
    '''
        {
            "x": {
                "a": 0,
                "b": "1",
                "c": [3, "4"]
            },
            "y": {
                "d": {
                    "e": 5
                }
            }
        }
    ''',
    object_pairs_hook=OrderedDict
)
```
