#include <iostream>
#include <cuda.h>

using namespace std;

__global__ void AddIntsCUDA(int *a, int *b)
{
for (int i = 0; i < 10000005; i++)
a[0] += b[0];
}

int main()
{
int h_a = 0, h_b = 1;

int *d_a, *d_b;

if (cudaMalloc((void**)&d_a, sizeof(int)) != cudaSuccess)
{
cout << "Error allocating memory!" << endl;
return 0;
}

if (cudaMalloc(&d_b, sizeof(int)) != cudaSuccess)
{
cout << "Error allocating memory!" << endl;
cudaFree(d_a);
return 0;
}

if (cudaMemcpy(d_a, &h_a, sizeof(int), cudaMemcpyHostToDevice) != cudaSuccess)
{
cout << "Error copying memory!" << endl;
cudaFree(d_a);
cudaFree(d_b);
return 0;
}

if (cudaMemcpy(d_b, &h_b, sizeof(int), cudaMemcpyHostToDevice) != cudaSuccess)
{
cout << "Error copying memory!" << endl;
cudaFree(d_a);
cudaFree(d_b);
return 0;
}

AddIntsCUDA<<<1, 1>>>(d_a, d_b);

if (cudaMemcpy(&h_a, d_a, sizeof(int), cudaMemcpyDeviceToHost) != cudaSuccess)
{
cout << "Error copying memory!" << endl;
return 0;
}

cout << h_a << endl;

cudaFree(d_a);
cudaFree(d_b);

cudaDeviceReset();

return 0;
}
