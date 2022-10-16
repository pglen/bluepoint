#!/usr/bin/env python3

import os, sys, shutil

from distutils.core import Extension, setup

os.chdir(os.path.dirname(os.path.abspath(__file__)))

shutil.copy("../bluepoint2.c", "bluepoint2x.c")
shutil.copy("../bluepoint2.h", "bluepoint2.h")
shutil.copy("../hs_crypt.h", "hs_crypt.h")

sys.argv = [sys.argv[0], 'build_ext', '-i']
setup(ext_modules = [Extension('bluepy3', ["bluepy_c.c", "bluepoint2x.c"])])








