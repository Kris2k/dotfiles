#!/bin/env python
import sys
import json
print(json.dumps(json.load(sys.stdin), sort_keys=True, indent=2))
