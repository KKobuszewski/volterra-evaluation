import os
import sys
import numpy

from setuptools import setup, find_packages
from setuptools.extension import Extension
#from distutils.core import setup
#from distutils.extension import Extension
from Cython.Distutils import build_ext

# get the annotated file as well
import Cython.Compiler.Options
Cython.Compiler.Options.annotate = True
from Cython.Build import cythonize


"""
usage: python setup.py build_ext --inplace
       python setup.py install --user

NOTE: Second command can be used to install package within virtual env or globally
"""



print('Compiling for')
print(sys.version)
print()


dpath = os.path.dirname( os.path.abspath(__file__) )
print(dpath)


# TODO: should be compiled with static libraries?
# gcc -Wl,-Bstatic -llib1 -llib2 file.c

ext_modules = [
    Extension( 'volterra',
               sources             = ['src/volterra/volterra.pyx'],
               language            = 'c++',
               include_dirs        = [numpy.get_include(),'.'],
               extra_compile_args  = ['-std=c++11','-fopenmp','-pthread','-fPIC','-O3'],
               extra_link_args     = ['-fopenmp','-pthread'],
               libraries           = ['gomp','m'],
               library_dirs        = ['/usr/local/lib'],
               define_macros       = [("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")] ),
]

# A list of compiler Directives is available at
# https://cython.readthedocs.io/en/latest/src/userguide/source_files_and_compilation.html#compiler-directives
cython_directives = { 'embedsignature' : True,
                      'language_level' : str( sys.version_info.major ) }

with open("README.md", 'r') as f:
    long_description = f.read()

setup(
    name = 'volterra',
    #cmdclass = {'build_ext': build_ext},
    #zip_safe=False,            # Without these two options
    #include_package_data=True, # PyInstaller may not find your C-Extensions
    #packages=find_packages('src/'),
    #package_dir={'':'src'},
    install_requires=['numpy'],       # additional packages that needs to be installed along with this package.
    ext_modules = cythonize( ext_modules, 
                             compiler_directives=cython_directives ),
)


# NOTE: The non-depricated method to set metadata and requirements is through pyproject.toml
# TODO: How to use pyproject.toml with cython?
# see:  https://stackoverflow.com/questions/73800736/pyproject-toml-and-cython-extension-module

# old-style metadata inclusion within setup.py
# https://python-packaging.readthedocs.io/en/latest/metadata.html

"""
https://stackoverflow.com/questions/22851552/can-i-create-a-static-cython-library-using-distutils

https://stackoverflow.com/questions/47042483/how-to-build-and-distribute-a-python-cython-package-that-depends-on-third-party

https://pypi.org/project/wheel/

"""


