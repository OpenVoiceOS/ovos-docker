#!/usr/bin/env python3

from ovos_bus_client import MessageBusClient
from ovos_bus_client.message import Message
import argparse
import sys

CLIENT = "docker"

parser = argparse.ArgumentParser()
parser.add_argument(
    "-s", "--svc", help="OVOS service to check status", type=str, default="skills"
)
parser.add_argument(
    "-n", "--ns", help="OVOS message's namespace", type=str, default="mycroft"
)
args = parser.parse_args()

client = MessageBusClient()
client.run_in_thread()


def check_svc_readiness():
    ready_msg = Message(
        f"{args.ns}.{args.svc}.is_ready",
        context={"source": [CLIENT], "destination": [args.svc]},
    )
    resp = client.wait_for_response(ready_msg)
    if resp:
        if resp.data.get("status"):
            sys.exit(0)
    sys.exit(1)


check_svc_readiness()

client.close()
