#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "constants.h"

int read_orbdef(int ** norb_per_sp, char * fuc, char * fsc, FILE * fin) {
  int ii, nsp;
  char line[MAXLEN];
  char * p;
  //fgets(line, MAXLEN, fin);
  //if(!fuc)
  //  sscanf(line, "%s", fuc);

  //fgets(line, MAXLEN, fin);
  //if(!fsc)
  //  sscanf(line, "%s", fsc);
  //fgets(line, MAXLEN, fin);
  //sscanf(line, " %d", &nsp);
  fscanf(fin,"%s\n",fuc);
  fscanf(fin,"%s\n",fsc);
  fscanf(fin, " %d\n", &nsp);
  // printf("fuc = %s\n",fuc);
  // printf("fsc = %s\n",fsc);
  // printf("nsp = %d\n",nsp);
  //fgets(line, MAXLEN, fin);
  fscanf(fin, "%[^\n]",line);
  (* norb_per_sp)=(int *) malloc(sizeof(int)*nsp);

  ii = 0;
  p=strtok(line, " ");
  while (p != NULL && ii < MAXLEN){
    sscanf(p, "%d", (*norb_per_sp)+ii);
    ii = ii + 1;
    p=strtok(NULL, " ");
  }
  // for (ii=0;ii<nsp;ii++){
  //   printf("%d",(*norb_per_sp)[ii]);
  // }
  //for(ii=0; ii<nsp; ii++) {
  //  printf("Hello0003\n");
  //  sscanf(p, "%d", (*norb_per_sp)+ii);
  //  p=strtok(NULL, " ");
  //}
  return nsp;
}
