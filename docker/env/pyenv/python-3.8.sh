#!/usr/bin/env python
# -*- coding: utf-8 -*-
set -x

export PYENV_ROOT="/opt/pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(command pyenv init -)"

pyenv install 3.8.19
