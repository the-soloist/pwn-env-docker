#!/usr/bin/env python
# -*- coding: utf-8 -*-

import ipdb
import yaml
from pathlib import Path


workhome = Path(__file__).parent.parent.parent
ubuntu_file = workhome / "build" / "ubuntu"
ubuntu_version = {
    "LTS": [path.name for path in ubuntu_file.glob("lts/*") if path.is_dir()],
    "non-LTS": [path.name for path in ubuntu_file.glob("non-lts/*") if path.is_dir()]
}

TEMPLATE_YAML = """
  ubuntu-{version}:
    image: th3s/pwn-env:ubuntu-{version}
    container_name: pwn-env_ubuntu-{version}
    volumes:
      - ./challenge:/challenge
      - ./config:/root/.config
      - ./deps:/deps
      - ./ssh:/root/.ssh
    ports:
      - '22{ver3}:22'
      - '6{ver4}:8888'
    expose:
      - '22'
      - '8888'
"""

TEMPLATE_YAML_DEV = """
  ubuntu-{version}:
    image: pwn-env/ubuntu-{version}
    container_name: pwn-env_ubuntu-{version}
    build:
      context: ./
      dockerfile: ./build/ubuntu/{type}/{version}/Dockerfile
    volumes:
      - ./challenge:/challenge
      - ./config:/root/.config
      - ./deps:/deps
      - ./ssh:/root/.ssh
    ports:
      - '22{ver3}:22'
      - '6{ver4}:8888'
    expose:
      - '22'
      - '8888'
"""

docker_compose = """version: '3'\n\nservices:"""
docker_compose_dev = """version: '3'\n\nservices:"""


for version in sorted(ubuntu_version["LTS"] + ubuntu_version["non-LTS"]):
    print(version)
    _ver = version.replace(".", "")

    if version in ubuntu_version["LTS"]:
        ubuntu_type = "lts"
    else:
        ubuntu_type = "non-lts"

    docker_compose += TEMPLATE_YAML.format(version=version, ver3=_ver[:3], ver4=_ver[:4])
    docker_compose_dev += TEMPLATE_YAML_DEV.format(version=version, type=ubuntu_type, ver3=_ver[:3], ver4=_ver[:4])


open("docker-compose.yml", "w").write(docker_compose)
open("docker-compose-dev.yml", "w").write(docker_compose_dev)
