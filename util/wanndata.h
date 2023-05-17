#ifdef WANNDATA_H
#else
#define WANNDATA_H

#include <complex.h>

#include "vector.h"

typedef struct __wanndata {
  int norb;
  int nrpt;
  double complex * ham;
  vector * rvec;
  int * weight;
} wanndata;
void write_reduced_ham(wanndata * wann);
void init_wanndata(wanndata * wann);
void read_ham(wanndata * wann, char * seed);
void finalize_wanndata(wanndata wann);
void write_ham(wanndata * wann);
int locate_rpt(wanndata * wann, vector vr);

#endif
