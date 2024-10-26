#include <iostream>
//#include <conio.h>
#include <cuda.h>

using namespace std;

struct phew
{
float x, y, z, w;
//float[128];
float padding;
};

__global__ void Mykernel(unsigned long long *time)
{
//__shared__ float shared[1024];
__shared__ phew shared[1024];

unsigned long long startTime = clock();

//shared[0]++;
//shared[threadIdx.x]++;
//shared[threadIdx.x*2]++;
//shared[threadIdx.x*8]++;
//shared[threadIdx.x*32]++;

shared[threadIdx.x].x++;

unsigned long long finishTime = clock();
*time = (finishTime - startTime);
}

int main()
{
unsigned long long time;
unsigned long long *d_time;

cudaMalloc(&d_time, sizeof(unsigned long long));

for (int i = 0; i < 10; i++)
{
Mykernel<<<1, 32>>>(d_time);

cudaMemcpy(&time, d_time, sizeof(unsigned long long), cudaMemcpyDeviceToHost);

cout << (time-14)/32 << endl << endl;
}

cudaFree(d_time);

//_getch();
cudaDeviceReset();

return 0;
}
