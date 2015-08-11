
#define STRMAXLEN 1000
#define MAXNSTR 500000

typedef struct Feature
{
  int *features;
  int *group;
  int n;
} Features;

typedef struct Combinations
{
  int n;
  int k;
  double num_comb;
  int *comb;
} Combinations;

typedef struct Kernel
{
  int count;
  int *K;
} Kernel;

int **loadStrings(char *filename, int* len, int *nStr);
int *cntsrtna(int *sx, int k, int r, int na);
void countAndUpdate(int *outK, int *sx, int *g, int k, int r, int nStr);
double nchoosek(double n, double k);
void getCombinations(const int *elems, unsigned int n, unsigned int k, int *pos, unsigned int depth, unsigned int margin, int *cnt_comb, int *out, int num_comb);
void initalizeMatrix(int *M, int nrow, int ncol);
