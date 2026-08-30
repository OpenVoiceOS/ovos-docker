#!/usr/bin/env python3
"""Readiness probe for Open Voice OS services.

Asks the message bus whether a service is ready (`<ns>.<svc>.is_ready`, answered by
`<ns>.<svc>.is_ready.response` with data.status) exactly like ovos_bus_client's
wait_for_response does, but over a bare websocket: no OVOS imports, so it costs a few hundred
milliseconds instead of a full client start-up, and can run every minute on a small device.

Exit status 0 = ready, 1 = not ready / no answer.
"""
import argparse
import json
import os
import sys
import time

import websocket  # websocket-client, a dependency of ovos-bus-client

parser = argparse.ArgumentParser()
parser.add_argument("-s", "--svc", help="OVOS service to check", default="skills")
parser.add_argument("-n", "--ns", help="message namespace", default="mycroft")
parser.add_argument("-t", "--timeout", help="seconds to wait for the answer", type=float, default=8.0)
parser.add_argument("--url", help="message bus URL", default=os.environ.get("OVOS_BUS_URL", "ws://127.0.0.1:8181/core"))
args = parser.parse_args()

msg_type = f"{args.ns}.{args.svc}.is_ready"
request = {"type": msg_type, "data": {}, "context": {"source": ["docker"], "destination": [args.svc]}}

try:
    ws = websocket.create_connection(args.url, timeout=args.timeout)
    ws.send(json.dumps(request))
    deadline = time.monotonic() + args.timeout
    while time.monotonic() < deadline:
        ws.settimeout(max(0.1, deadline - time.monotonic()))
        try:
            raw = ws.recv()
        except websocket.WebSocketTimeoutException:
            break
        try:
            message = json.loads(raw)
        except (TypeError, ValueError):
            continue
        if message.get("type") == msg_type + ".response":
            sys.exit(0 if (message.get("data") or {}).get("status") else 1)
except Exception:
    pass
sys.exit(1)
