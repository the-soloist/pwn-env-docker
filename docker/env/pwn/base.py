import subprocess
import argparse
from dataclasses import dataclass
from typing import Dict

VERSION_LATEST = "latest"


@dataclass
class ToolVersions:
    bindata: str = VERSION_LATEST
    elftools: str = VERSION_LATEST
    one_gadget: str = VERSION_LATEST
    seccomp_tools: str = VERSION_LATEST
    pwndbg: str = VERSION_LATEST


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


def gem_install(name, version):
    """Gem安装函数"""
    if version == VERSION_LATEST:
        subprocess.run(["gem", "install", name], check=True)
    else:
        subprocess.run(["gem", "install", name, "-v", version], check=True)


def main(sys_version: str):
    """根据Ubuntu版本安装工具"""

    # 设置gem源
    subprocess.run(["gem", "sources", "--add", "https://mirrors.tuna.tsinghua.edu.cn/rubygems/", "--remove", "https://rubygems.org/"], check=True)

    # 安装工具
    versions = VERSION[sys_version]
    gem_install("bindata", versions.bindata)
    gem_install("elftools", versions.elftools)
    gem_install("one_gadget", versions.one_gadget)
    gem_install("seccomp-tools", versions.seccomp_tools)
    if versions.pwndbg != VERSION_LATEST:
        _cwd = "/root/tools/gdb/plugins/pwndbg"
        subprocess.run(["git", "clone", "https://github.com/pwndbg/pwndbg", "/root/tools/gdb/plugins/pwndbg"], check=True)
        subprocess.run(["git", "checkout", "-f", versions.pwndbg], cwd=_cwd, check=True)
        subprocess.run(["/root/tools/gdb/plugins/pwndbg/setup.sh"], cwd=_cwd, check=True)
        subprocess.run(["cp", "/root/tools/gdb/init/pwndbg.conf", "/root/.gdbinit"], check=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Install tools based on Ubuntu version")
    parser.add_argument("-v", "--version", required=True, help="Ubuntu version (e.g. ubuntu-22.04)")
    args = parser.parse_args()

    if args.version not in VERSION:
        raise ValueError(f"Unsupported Ubuntu version: {args.version}")

    main(args.version)
