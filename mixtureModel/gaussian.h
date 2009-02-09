/*
 * Parameters file for gaussian mixture model based clustering application
 */

#ifndef GAUSSIAN_H
#define GAUSSIAN_H

#define MAX_CLUSTERS	64

typedef struct 
{
    float N;        // expected # of pixels in cluster
    float pi;       // probability of cluster in GMM
    float *means;   // Spectral mean for the cluster
    float *R;      // Covariance matrix
    float *Rinv;   // Inverse of covariance matrix
    float constant; // Normalizing constant
    float *p;       // Probability that each pixel belongs to this cluster
    float *w;       // Weight for pixels in cluster
} cluster;

int validateArguments(int argc, char** argv, int* num_clusters, FILE** infile, FILE** outfile);
void printUsage(char** argv);
#endif

