/// My Query 23
/// select l_linenumber, count(*) --> l_linenumber is the 4th attribute in lineitem table
/// from lineitem
/// group by l_linenumber
#include <cassert>
#include <cstring>

#include <list>
#include <unordered_map>
#include <vector>
#include <iostream>
#include <ctime>
#include <limits.h>
#include <float.h>
#include "../dogqc/include/csv.h"
#include "../dogqc/include/util.h"
#include "../dogqc/include/mappedmalloc.h"
#include "../dogqc/include/util.cuh"
#include "../dogqc/include/hashing.cuh"
struct apayl2 {
    int att5_llinenum;
};

constexpr int SHARED_MEMORY_SIZE = 49152;  /// Total amount of shared memory per block:       49152 bytes

__global__ void krnl_lineitem1(
    int* iatt5_llinenum, int* nout_result, int* oatt5_llinenum, int* oatt1_countlli) {  ///

    /// local block memory cache : ONLY FOR A BLOCK'S THREADS!!!
    const int HT_SIZE = 128;
    __shared__ agg_ht<apayl2> aht2[HT_SIZE];  ///
    __shared__ int agg1[HT_SIZE];  ///
    const int shared_memory_usage = sizeof(aht2) + sizeof(agg1);
    assert(shared_memory_usage <= SHARED_MEMORY_SIZE);  /// Check stuff fits into shared memory in a SM.
    if (threadIdx.x == 0 && blockIdx.x == 0) {
        /// Allow only one print here.
        printf("Shared memory usage: %d / %d bytes.\n", shared_memory_usage, SHARED_MEMORY_SIZE);
    }

    {
        /// Init hash table in shared memory.
        int ht_index;
        unsigned loopVar = threadIdx.x;  ///
        unsigned step = blockDim.x;  ///
        while(loopVar < HT_SIZE) {
            ht_index = loopVar;
            aht2[ht_index].lock.init();
            aht2[ht_index].hash = HASH_EMPTY;
            loopVar += step;
        }
    }

    {
        /// Init array in shared memory.
        int index;
        unsigned loopVar = threadIdx.x;  ///
        unsigned step = blockDim.x;  ///
        while(loopVar < HT_SIZE) {
            index = loopVar;
            agg1[index] = 0;
            loopVar += step;
        }
    }

    __syncthreads();

    {
        /// The first old kenrel
        int att5_llinenum;

        int tid_lineitem1 = 0;
        unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
        unsigned step = (blockDim.x * gridDim.x);
        unsigned flushPipeline = 0;
        int active = 0;
        while(!(flushPipeline)) {
            tid_lineitem1 = loopVar;
            active = (loopVar < 6001215);
            // flush pipeline if no new elements
            flushPipeline = !(__ballot_sync(ALL_LANES,active));
            if(active) {
                att5_llinenum = iatt5_llinenum[tid_lineitem1];
            }
            // -------- aggregation (opId: 2) --------
            int bucket = 0;
            if(active) {
                uint64_t hash2 = 0;
                hash2 = 0;
                if(active) {
                    hash2 = hash ( (hash2 + ((uint64_t)att5_llinenum)));
                }
                apayl2 payl;
                payl.att5_llinenum = att5_llinenum;
                int bucketFound = 0;
                int numLookups = 0;
                while(!(bucketFound)) {
                    bucket = hashAggregateGetBucket ( aht2, HT_SIZE, hash2, numLookups, &(payl));  ///
                    apayl2 probepayl = aht2[bucket].payload;
                    bucketFound = 1;
                    bucketFound &= ((payl.att5_llinenum == probepayl.att5_llinenum));
                }
            }
            if(active) {
                atomicAdd(&(agg1[bucket]), ((int)1));
            }
            loopVar += step;
        }
    }

    __syncthreads();  ///

    {
        /// The second old kernel
        int att5_llinenum;
        int att1_countlli;
        unsigned warplane = (threadIdx.x % 32);
        unsigned prefixlanes = (0xffffffff >> (32 - warplane));

        int tid_aggregation2 = 0;
//        unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);  ///
        unsigned loopVar = threadIdx.x;  ///
//        unsigned step = (blockDim.x * gridDim.x);
        unsigned step = blockDim.x;  ///
        unsigned flushPipeline = 0;
        int active = 0;
        while(!(flushPipeline)) {
            tid_aggregation2 = loopVar;
            active = (loopVar < HT_SIZE);  ///
            // flush pipeline if no new elements
            flushPipeline = !(__ballot_sync(ALL_LANES,active));
            if(active) {
            }
            // -------- scan aggregation ht (opId: 2) --------
            if(active) {
                active &= ((aht2[tid_aggregation2].lock.lock == OnceLock::LOCK_DONE));
            }
            if(active) {
                apayl2 payl = aht2[tid_aggregation2].payload;
                att5_llinenum = payl.att5_llinenum;
            }
            if(active) {
                att1_countlli = agg1[tid_aggregation2];
            }
            // -------- projection (no code) (opId: 3) --------
            // -------- materialize (opId: 4) --------
            int wp;
            int writeMask;
            int numProj;
            writeMask = __ballot_sync(ALL_LANES,active);
            numProj = __popc(writeMask);
            if((warplane == 0)) {
                wp = atomicAdd(nout_result, numProj);
            }
            wp = __shfl_sync(ALL_LANES,wp,0);
            wp = (wp + __popc((writeMask & prefixlanes)));
            if(active) {
                oatt5_llinenum[wp] = att5_llinenum;
                oatt1_countlli[wp] = att1_countlli;
            }
            loopVar += step;
        }
    }
}

int main() {
    int* iatt5_llinenum;
    size_t filesize = get_file_size( "mmdb/lineitem_l_linenumber" );  ///
    cudaMallocHost((void**)&iatt5_llinenum, filesize - 8 /* 8: the meta: size of file in 8bytes*/);  /// host pinned
    read_file("mmdb/lineitem_l_linenumber", (void*)iatt5_llinenum );  ///

    // TODO(jigao): free all memory

    int nout_result;
    /// std::vector < int > oatt5_llinenum(6001215);
    /// std::vector < int > oatt1_countlli(6001215);
    int* oatt5_llinenum;  ///
    int* oatt1_countlli;  ///
    cudaMallocHost((void**)&oatt5_llinenum, 6001215 * sizeof(int));  /// host pinned
    cudaMallocHost((void**)&oatt1_countlli, 6001215 * sizeof(int));  /// host pinned
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cudaMallocHost! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cudaMallocHost")
        }
    }

    // wake up gpu
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in wake up gpu! " << cudaGetErrorString( err ) << std::endl;
            ERROR("wake up gpu")
        }
    }

    /// Input as Column Store.
    int* d_iatt5_llinenum;
    cudaMalloc((void**) &d_iatt5_llinenum, 6001215* sizeof(int) );  /// l_linenumber is the 4th attribute in lineitem table

    /// Output: allocated as max group size: the same size as the lineitem table's cardinality.
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    int* d_oatt5_llinenum;
    cudaMalloc((void**) &d_oatt5_llinenum, 6001215* sizeof(int) );
    int* d_oatt1_countlli;  /// For SQL projection.
    cudaMalloc((void**) &d_oatt1_countlli, 6001215* sizeof(int) );
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda malloc! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda malloc")
        }
    }


    // show memory usage of GPU
    {   size_t free_byte ;
        size_t total_byte ;
        cudaError_t cuda_status = cudaMemGetInfo( &free_byte, &total_byte ) ;
        if ( cudaSuccess != cuda_status ) {
            printf("Error: cudaMemGetInfo fails, %s \n", cudaGetErrorString(cuda_status) );
            exit(1);
        }
        double free_db = (double)free_byte ;
        double total_db = (double)total_byte ;
        double used_db = total_db - free_db ;
        fprintf(stderr, "Memory %.1f / %.1f GB\n",
                used_db/(1024*1024*1024), total_db/(1024*1024*1024) );
        fflush(stdout);
    }


    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_nout_result, 0, 1);
    }
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda mallocHT! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda mallocHT")
        }
    }


    // show memory usage of GPU
    {   size_t free_byte ;
        size_t total_byte ;
        cudaError_t cuda_status = cudaMemGetInfo( &free_byte, &total_byte ) ;
        if ( cudaSuccess != cuda_status ) {
            printf("Error: cudaMemGetInfo fails, %s \n", cudaGetErrorString(cuda_status) );
            exit(1);
        }
        double free_db = (double)free_byte ;
        double total_db = (double)total_byte ;
        double used_db = total_db - free_db ;
        fprintf(stderr, "Memory %.1f / %.1f GB\n",
                used_db/(1024*1024*1024), total_db/(1024*1024*1024) );
        fflush(stdout);
    }

    cudaMemcpy( d_iatt5_llinenum, iatt5_llinenum, 6001215 * sizeof(int), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime0 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_lineitem1<<<gridsize, blocksize>>>(d_iatt5_llinenum, d_nout_result, d_oatt5_llinenum, d_oatt1_countlli);
    }
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_lineitem1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_lineitem1")
        }
    }

    std::clock_t stop_totalKernelTime0 = std::clock();
    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    /// cudaMemcpy( oatt5_llinenum.data(), d_oatt5_llinenum, 6001215 * sizeof(int), cudaMemcpyDeviceToHost);
    /// cudaMemcpy( oatt1_countlli.data(), d_oatt1_countlli, 6001215 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt5_llinenum, d_oatt5_llinenum, 6001215 * sizeof(int), cudaMemcpyDeviceToHost);  ///
    cudaMemcpy( oatt1_countlli, d_oatt1_countlli, 6001215 * sizeof(int), cudaMemcpyDeviceToHost);  ///
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt5_llinenum);
    cudaFree( d_nout_result);
    cudaFree( d_oatt5_llinenum);
    cudaFree( d_oatt1_countlli);
    cudaFreeHost( iatt5_llinenum );  ///
    cudaFreeHost( oatt5_llinenum );  ///
    cudaFreeHost( oatt1_countlli );  ///
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda free! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda free")
        }
    }

    std::clock_t start_finish3 = std::clock();
    printf("\nResult: %i tuples\n", nout_result);
    if((nout_result > 6001215)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("l_linenumber: ");
        printf("%8i", oatt5_llinenum[pv]);
        printf("  ");
        printf("count_l_linenumber: ");
        printf("%8i", oatt1_countlli[pv]);
        printf("  ");
        printf("\n");
    }
    if((nout_result > 10)) {
        printf("[...]\n");
    }
    printf("\n");
    std::clock_t stop_finish3 = std::clock();

    /// My Reduce
    std::cout << "MY REDUCE ON CPU (single-cpu-threaded)" << std::endl;
    std::clock_t start_cpu_reduce = std::clock();
    std::unordered_map<int, int> ht;
    for ( int pv = 0; (pv < nout_result); pv += 1 ) {
        ht[oatt5_llinenum[pv]] += oatt1_countlli[pv];
    }
    for (const auto& ele : ht) {
        printf("l_linenumber: ");
        printf("%8i", ele.first);
        printf("  ");
        printf("count_l_linenumber: ");
        printf("%8i", ele.second);
        printf("  ");
        printf("\n");
    }
    std::clock_t stop_cpu_reduce = std::clock();


    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish3 - start_finish3) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime0 - start_totalKernelTime0) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "reduce on CPU (single-cpu-threaded)", (stop_cpu_reduce - start_cpu_reduce) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
