from dataclasses import dataclass
from typing import Dict

@dataclass
class ToolVersions:
    bindata: str = "-1"
    elftools: str = "-1"
    one_gadget: str = "-1"
    seccomp_tools: str = "-1"
    pwndbg: str = "-1"

def init_versions() -> Dict[str, ToolVersions]:
    ubuntu_versions = ["16.04", "18.04", "20.04", "22.04"]
    return {f"ubuntu-{v}": ToolVersions() for v in ubuntu_versions}

VERSION = init_versions()

# Custom configurations
VERSION["ubuntu-16.04"].bindata = "2.4.14"
VERSION["ubuntu-16.04"].one_gadget = "1.7.3"
VERSION["ubuntu-16.04"].seccomp_tools = "1.3.0"
VERSION["ubuntu-16.04"].pwndbg = "2022.01.05"

VERSION["ubuntu-18.04"].elftools = "1.1.3"
VERSION["ubuntu-18.04"].one_gadget = "1.9.0"
VERSION["ubuntu-18.04"].seccomp_tools = "1.5.00"
VERSION["ubuntu-18.04"].pwndbg = "2022.08.30"

VERSION["ubuntu-20.04"].elftools = "1.2.0"
VERSION["ubuntu-20.04"].one_gadget = "1.9.0"
VERSION["ubuntu-20.04"].pwndbg = "2024.02.14"
