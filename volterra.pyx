#distutils: language = c++
#cython: boundscheck=False, nonecheck=False, cdivision=True
from __future__ import print_function, division

cimport cython
cimport numpy as np
import numpy as np

from cpython cimport bool as py_bool
from libcpp cimport bool
from libc.stdio cimport printf

#from libcpp.algorithm cimport max_element
#cdef extern from "<algorithm>" namespace "std":




# https://cvanelteren.github.io/post/cython_templates/

# ========================================================  FILE PROCESSING  ============================================================

cdef extern from "volterra_kernels.h" nogil:
    void volterra_kernel_1st_order[T](T* signal_padded, 
                                      T* kernel, 
                                      T* output, 
                                      const size_t n_signal,
                                      const size_t nk1)
    void volterra_kernel_2nd_order[T](T* signal_padded, 
                                      T* kernel, 
                                      T* output, 
                                      const size_t n_signal,
                                      const size_t nk1,
                                      const size_t nk2)
    void volterra_kernel_3rd_order[T](T* signal_padded, 
                                      T* kernel, 
                                      T* output, 
                                      const size_t n_signal,
                                      const size_t nk1,
                                      const size_t nk2,
                                      const size_t nk3)



cpdef volterra_1st_order(np.ndarray[np.float64_t,ndim=1,negative_indices=False,mode='c',cast=True] x,
                         np.ndarray[np.float64_t,ndim=1,negative_indices=False,mode='c',cast=True] kernel):
    cdef size_t n_signal = <size_t>  x.size
    cdef size_t nk1 = <size_t>  kernel.size
    
    # allocate memory for output
    cdef np.ndarray[double,ndim=1,negative_indices=False,mode="c",cast=True] y = np.empty(n_signal,
                                                                                          dtype=x.dtype,
                                                                                          order='C')
    
    # pad signal (NOTE: tested)
    cdef np.ndarray[double,ndim=1,negative_indices=False,mode="c",cast=True] x_padded = np.empty(n_signal+nk1, 
                                                                                                 dtype=x.dtype,
                                                                                                 order='C')
    x_padded[:nk1] = 0.0
    x_padded[nk1:] = x[:]
    
    # call volterra kernel of 1st order (simple convolution)
    # TODO: Extend to complex numbers?
    volterra_kernel_1st_order[double](&x_padded[nk1], &kernel[0], &y[0], n_signal, nk1)
    
    return y



cpdef volterra_2nd_order(np.ndarray[np.float64_t,ndim=1,negative_indices=False,mode='c',cast=True] x,
                         np.ndarray[np.float64_t,ndim=2,negative_indices=False,mode='c',cast=True] kernel):
    cdef size_t n_signal = <size_t>  x.size
    cdef size_t nk1 = <size_t>  kernel.shape[0]
    cdef size_t nk2 = <size_t>  kernel.shape[1]
    cdef size_t nk  = max([nk1,nk2])
    
    # allocate memory for output
    cdef np.ndarray[double,ndim=1,negative_indices=False,mode="c",cast=True] y = np.empty(n_signal,
                                                                                          dtype=x.dtype,
                                                                                          order='C')
    
    # pad signal (NOTE: tested)
    cdef np.ndarray[double,ndim=1,negative_indices=False,mode="c",cast=True] x_padded = np.empty(n_signal+nk, 
                                                                                                 dtype=x.dtype,
                                                                                                 order='C')
    x_padded[:nk] = 0.0
    x_padded[nk:] = x[:]
    
    # call volterra kernel of 1st order (simple convolution)
    # TODO: Extend to complex numbers?
    volterra_kernel_2nd_order[double](&x_padded[nk], &kernel[0,0], &y[0], n_signal, nk1, nk2)
    
    return y




cpdef volterra_3rd_order(np.ndarray[np.float64_t,ndim=1,negative_indices=False,mode='c',cast=True] x,
                         np.ndarray[np.float64_t,ndim=3,negative_indices=False,mode='c',cast=True] kernel):
    cdef size_t n_signal = <size_t>  x.size
    cdef size_t nk1 = <size_t>  kernel.shape[0]
    cdef size_t nk2 = <size_t>  kernel.shape[1]
    cdef size_t nk3 = <size_t>  kernel.shape[2]
    cdef size_t nk  = max([nk1,nk2,nk3])
    
    # allocate memory for output
    cdef np.ndarray[double,ndim=1,negative_indices=False,mode="c",cast=True] y = np.empty(n_signal,
                                                                                          dtype=x.dtype,
                                                                                          order='C')
    
    # pad signal (NOTE: tested)
    cdef np.ndarray[double,ndim=1,negative_indices=False,mode="c",cast=True] x_padded = np.empty(n_signal+nk, 
                                                                                                 dtype=x.dtype,
                                                                                                 order='C')
    x_padded[:nk] = 0.0
    x_padded[nk:] = x[:]
    
    # call volterra kernel of 1st order (simple convolution)
    # TODO: Extend to complex numbers?
    volterra_kernel_3rd_order[double](&x_padded[nk], &kernel[0,0,0], &y[0], n_signal, nk1, nk2, nk3)
    
    return y
