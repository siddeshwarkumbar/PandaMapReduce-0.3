#ifndef _FUZZYCMEDOIDS_KERNEL_H_
#define _FUZZYCMEDOIDS_KERNEL_H_

#include <stdio.h>

__device__ void calculateCost(float* d, float* m, int nc, int dims[], float costs[], int index);
__device__ float calculateDist(int i, int x, float* d, float* m, int dims[], int n);

__global__ void fuzzyCMedoids(float* data, float* medoids, int* dims, float* cost, int nc, int nb, int nt, int ss) {
	int start;
	int end;
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	int j = blockIdx.y * blockDim.y + threadIdx.y;

	__shared__ float costs[200];

	if (threadIdx.x == 0) {
		for (int i = 0; i < nc; i++) {
			costs[i] = 0;
		}
	}

	__syncthreads();

	/*if (ss == 0) {
		start = i + j * dims[1];
	}
	else {*/
		start = (i + j * dims[1]) * ss;

		if (blockIdx.x == (nb - 1) && threadIdx.x == (nt - 1)) {
			end = dims[1];
		}
		else {
			end = start + ss;
		}

		if (start < dims[1] && end <= dims[1]) {
			for (int x = start; x < end; x++) {
				calculateCost(data, medoids, nc, dims, costs, x);
			}
		}
	//}

	__syncthreads();

	if (threadIdx.x == 0) {
		if (start < dims[1] && end <= dims[1]) {
			for (int x = 0; x < nc; x++) {
				*cost += costs[x];
			}
		}
	}
}

__device__ void calculateCost(float* d, float* m, int nc, int* dims, float costs[], int index) {
	float dist;
	float leastDist = -1;
	int cluster = 0;

	for (int j = 0; j < nc; j++) {
		dist = calculateDist(index, j, d, m, dims, nc);

		if (leastDist == -1 || dist < leastDist) {
			leastDist = dist;
			cluster = j;
		}
	}

	costs[cluster] += leastDist;
}

__device__ float calculateDist(int i, int x, float* d, float* m, int dims[], int n) {
	float sum = 0;

	for (int j = 0; j < dims[0]; j++) {
		sum += pow(d[i + j * dims[1]] - m[j + x * dims[0]], 2);
	}

	return sqrt(sum);
}

#endif