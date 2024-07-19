# pragma once

#include <stdio.h>
#include <math.h>

#include <omp.h>


// #include <iostream>
// #include <cmath>
// #include <numeric>
// #include <algorithm>
// #include <string.h>
// #include <float.h>


/* 
 * Performs $ \int_{\mathbb{R}_+} h^{(1)}(\tau_1)x(t-\tau_1) \, d\tau_1 $.
 * 
 */
template<typename T>
void volterra_kernel_1st_order(T* signal_padded, 
                               T* kernel,
                               T* output,
                               const size_t n_signal,
                               const size_t nk1)
{
    #pragma omp parallel for simd
    for (size_t it=0; it<n_signal; it++)
    {
        T out = 0.0;
        //#pragma omp for simd
        for (size_t itau=0; itau<nk1; itau++)
            out += kernel[itau]*signal_padded[it-itau];
        output[it] = out;
    }
    
}


template<typename T>
void volterra_kernel_2nd_order(T* signal_padded, 
                               T* kernel,        /* 2-d kernel function stored in 1-d C-array */
                               T* output,
                               const size_t n_signal,
                               const size_t nk1,
                               const size_t nk2)
{
    // TODO: Change order of for loops (iteration over time inside?)
    // TODO: 
    #pragma omp parallel for simd
    for (size_t it=0; it<n_signal; it++)
    {
        T out = 0.0;
        for (size_t itau1=0; itau1<nk1; itau1++)
        for (size_t itau2=0; itau2<nk2; itau2++)
        {
            const size_t j = itau1*nk2 + itau2;
            out += kernel[j]*signal_padded[it-itau1]*signal_padded[it-itau2];
        }
        output[it] = out;
    }
    
}



template<typename T>
void volterra_kernel_3rd_order(T* signal_padded, 
                               T* kernel,        /* 3-d kernel function stored in 1-d C-array */
                               T* output,
                               const size_t n_signal,
                               const size_t nk1,
                               const size_t nk2,
                               const size_t nk3)
{
    #pragma omp parallel for
    for (size_t it=0; it<n_signal; it++)
    {
        T out = 0.0;
        for (size_t itau1=0; itau1<nk1; itau1++)
        for (size_t itau2=0; itau2<nk2; itau2++)
        for (size_t itau3=0; itau3<nk3; itau3++)
        {
            const size_t j = itau1*nk2*nk3 + itau2*nk3 + itau3;
            out += kernel[j]*signal_padded[it-itau1]*signal_padded[it-itau2]*signal_padded[it-itau3];
        }
        output[it] = out;
    }
    
}
