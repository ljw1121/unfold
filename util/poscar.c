#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "constants.h"
#include "vector.h"
#include "poscar.h"

void init_poscar(poscar * psc) {
  psc->nsp=0;
  psc->nat_per_sp=NULL;
  psc->tau=NULL;
}

void read_poscar_header(poscar * psc, FILE * fin) {
  char line[MAXLEN];
  char line_strtok[MAXLEN];
  char * p;
  double lat;
  int ii;
  fgets(line, MAXLEN, fin);
  //fgets(line, MAXLEN, fin);
  //sscanf(line, " %lf", &lat);
  fscanf(fin, " %lf\n", &lat);
  // printf("lat = %12.8f\n",lat);
  for(ii=0; ii<3; ii++) {
    //fgets(line, MAXLEN, fin);
    //sscanf(line, " %lf %lf %lf", (psc->cell+ii)->x, (psc->cell+ii)->x+1, (psc->cell+ii)->x+2);
    fscanf(fin, " %lf %lf %lf\n", (psc->cell+ii)->x, (psc->cell+ii)->x+1, (psc->cell+ii)->x+2);
    // printf("%12.8f\n%12.8f\n%12.8f\n\n",(psc->cell[ii]).x[0],(psc->cell[ii]).x[1],(psc->cell[ii]).x[2]); 
    (psc->cell[ii]).x[0]*=lat;
    (psc->cell[ii]).x[1]*=lat;
    (psc->cell[ii]).x[2]*=lat;
  }


  fgets(line, MAXLEN, fin);
  //printf("line_st = %s\n",line);  
  
  ii=0;
  p=strtok(line, " ");
  while(p!=NULL) {
    ii++;
    p=strtok(NULL, " ");
    // printf("p=%s\n",p);
  }
  psc->nsp=ii;

  psc->nat_per_sp=(int *) malloc(sizeof(int)*psc->nsp);

  fgets(line, MAXLEN, fin);
  //printf("line = %s\n",line);  
  // printf("psc->nsp = %d\n",psc->nsp);
  
//  psc->nat=0;
//  p=strtok(line, " ");
//  for(ii=0; ii<psc->nsp; ii++) {
//    sscanf(p, " %d", psc->nat_per_sp+ii);
//    psc->nat+=psc->nat_per_sp[ii];
//    p=strtok(NULL, " ");
//  }

  psc->nat=0;
  ii = 0;
  p=strtok(line, " ");
  while (p != NULL && ii < MAXLEN){
    sscanf(p, "%d", (psc->nat_per_sp)+ii);
    psc->nat+=psc->nat_per_sp[ii];
    ii = ii + 1;
    p=strtok(NULL, " ");
  }
  psc->tau=NULL;

}

void read_poscar(poscar * psc, char * fn) {
  FILE * fin;
  char line[MAXLEN];
  char * p;
  int ii;

  fin=fopen(fn, "r");

  read_poscar_header(psc, fin);

  psc->tau=(vector *)malloc(sizeof(vector)*psc->nat);
  fgets(line, MAXLEN, fin);
  // fscanf(fin, "%[^\n]",line);
  for(ii=0; ii<psc->nat; ii++) {
    //fgets(line, MAXLEN, fin);
    fscanf(fin, " %lf %lf %lf\n", (psc->tau+ii)->x, (psc->tau+ii)->x+1, (psc->tau+ii)->x+2);
    //sscanf(line, " %lf %lf %lf ", (psc->tau+ii)->x, (psc->tau+ii)->x+1, (psc->tau+ii)->x+2);
  }
  fclose(fin);
}

void finalize_poscar(poscar psc) {
  if(psc.nat_per_sp)
    free(psc.nat_per_sp);
  if(psc.tau)
    free(psc.tau);
}
