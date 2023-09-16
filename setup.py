from distutils.core import setup, Extension
from Cython.Build import cythonize
import numpy

setup(
    ext_modules=cythonize(["utils/lib.pyx","utils/minimax_agent.pyx"]),
    include_dirs=[numpy.get_include()]
)    