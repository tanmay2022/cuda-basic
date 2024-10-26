#include <iostream>
#include <cuda.h>
#include <stdlib.h>
#include <ctime>

using namespace std;

__global__ void AddIntsCUDA(int *a, int *b, int count)
{
int id = blockIdx.x*blockDim.x + threadIdx.x;

if (id < count)
{
a[id] += b[id];
}
}

int main()
{
srand(time(NULL));

int count = 100;

int *h_a = new int[count];

int *h_b = new int[count];

for (int i = 0; i < count; i++)
{
h_a[i] = rand()%1000;
h_b[i] = rand()%1000;
}

cout << "before add" << endl;

for (int i = 0; i < 5; i++)
cout << h_a[i] << " " << h_b[i] << endl;

int *d_a, *d_b;

if (cudaMalloc(&d_a, sizeof(int)*count) != cudaSuccess)
{
cout << "Error allocating memory!" << endl;
return 0;
}

if (cudaMalloc(&d_b, sizeof(int)*count) != cudaSuccess)
{
cout << "Error allocating memory!" << endl;
cudaFree(d_a);
return 0;
}

if (cudaMemcpy(d_a, h_a, sizeof(int)*count, cudaMemcpyHostToDevice) != cudaSuccess)
{
cout << "Error copying memory!" << endl;
cudaFree(d_a);
cudaFree(d_b);
return 0;
}

if (cudaMemcpy(d_b, h_b, sizeof(int)*count, cudaMemcpyHostToDevice) != cudaSuccess)
{
cout << "Error copying memory!" << endl;
cudaFree(d_a);
cudaFree(d_b);
return 0;
}

AddIntsCUDA<<<count/256 + 1, 256>>>(d_a, d_b, count);

if (cudaMemcpy(h_a, d_a, sizeof(int)*count, cudaMemcpyDeviceToHost) != cudaSuccess)
{
delete[] h_a;
delete[] h_b;
cudaFree(d_a);
cudaFree(d_b);
cout << "Error copying memory!" << endl;
return 0;
}

for (int i = 0; i < 5; i++)
cout << h_a[i] << endl;

//cout << a << endl;

cudaFree(d_a);
cudaFree(d_b);
delete[] h_a;
delete[] h_b;

cudaDeviceReset();

return 0;
}
