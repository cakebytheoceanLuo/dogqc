/// My Query 27
/// select l_orderkey, count(*) --> l_orderkey is the 1st attribute in lineitem table
/// from lineitem
/// group by l_orderkey
/// order by l_orderkey
#include <map>
#include <cassert>
//#define COLLISION_PRINT

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
    int att2_lorderke;
};

__device__ bool operator==(const apayl2& lhs, const apayl2& rhs) {
    return lhs.att2_lorderke == rhs.att2_lorderke;
}

constexpr int SHARED_MEMORY_HT_SIZE = 1024;  /// In shared memory
constexpr int LINEITEM_SIZE = 6001215; const std::string file_path = "mmdb/tpch-dbgen-sf1/lineitem_l_orderkey";      /// SF1
//constexpr int LINEITEM_SIZE = 59986052;  const std::string file_path = "mmdb/tpch-dbgen-sf10/lineitem_l_orderkey";     /// SF10
constexpr int GLOBAL_HT_SIZE = LINEITEM_SIZE * 2;  /// In global memory
//constexpr int GLOBAL_HT_SIZE = 4194304;  /// In global memory

__device__ void sm_to_gm(agg_ht_sm<apayl2>* aht2, int* agg1, agg_ht<apayl2>* g_aht2, int* g_agg1) {
    /// Copy the shared memory hash table (pre-aggreagation) into the global hash table.
    /// <-- START: first half of the kernel 2
    int att2_lorderke;
    int att1_countlor;

    int tid_aggregation2 = 0;
    unsigned loopVar = threadIdx.x;  ///
    unsigned step = blockDim.x;  ///
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation2 = loopVar;
        active = (loopVar < SHARED_MEMORY_HT_SIZE);  ///
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
            att2_lorderke = payl.att2_lorderke;
        }
        if(active) {
            att1_countlor = agg1[tid_aggregation2];
        }
        /// <-- END: first half of the kernel 2

        /// <-- START: second half of the kernel 1
        /// Insert to global hash table.
        int bucket = 0;
        if(active) {
            uint64_t hash2 = 0;
            hash2 = 0;
            if(active) {
                hash2 = hash ( (hash2 + ((uint64_t)att2_lorderke)));
            }
            apayl2 payl;
            payl.att2_lorderke = att2_lorderke;
            int bucketFound = 0;
            int numLookups = 0;
            while(!(bucketFound)) {
                bucket = hashAggregateGetBucket ( g_aht2, GLOBAL_HT_SIZE, hash2, numLookups, &(payl));  ////
                apayl2 probepayl = g_aht2[bucket].payload;  ////
                bucketFound = 1;
                bucketFound &= ((payl.att2_lorderke == probepayl.att2_lorderke));
            }
        }
        if(active) {
            atomicAdd(&(g_agg1[bucket]), ((int)att1_countlor));  ////
        }

        /// <-- END: second half of the kernel 1
        loopVar += step;
    }
}

__global__ void krnl_lineitem1(
    int* iatt2_lorderke, agg_ht<apayl2>* g_aht2, int* g_agg1) {  ///

    /// local block memory cache : ONLY FOR A BLOCK'S THREADS!!!
    extern __shared__ char shared_memory[];
    agg_ht_sm<apayl2>* aht2 = (agg_ht_sm<apayl2> *)shared_memory;  ///
    int* agg1 = (int*)(shared_memory + sizeof(agg_ht_sm<apayl2>) * SHARED_MEMORY_HT_SIZE);  ///
    volatile __shared__ int HT_FULL_FLAG; HT_FULL_FLAG = 0;  ////
#ifdef COLLISION_PRINT
    __shared__ int num_collision; num_collision = 0;
#endif

    initSMAggHT(aht2,SHARED_MEMORY_HT_SIZE);
    initSMAggArray(agg1,SHARED_MEMORY_HT_SIZE);
    __syncthreads();

    /// The first old kenrel
    int att2_lorderke;

    int tid_lineitem1 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_lineitem1 = loopVar;
        active = (loopVar < LINEITEM_SIZE);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att2_lorderke = iatt2_lorderke[tid_lineitem1];
        }
        // -------- aggregation (opId: 2) --------
        int bucket = 0;
        if(active) {
            uint64_t hash2 = 0;
            hash2 = 0;
            if(active) {
                hash2 = hash ( (hash2 + ((uint64_t)att2_lorderke)));
            }
            apayl2 payl;
            payl.att2_lorderke = att2_lorderke;
            int bucketFound = 0;
            int numLookups = 0;
            while(!(bucketFound)) {
                bucket = hashAggregateGetBucket ( aht2,SHARED_MEMORY_HT_SIZE, hash2, numLookups, &(payl));  ///
                if (bucket != -1) {  ////
                    apayl2 probepayl = aht2[bucket].payload;
                    bucketFound = 1;
                    bucketFound &= ((payl.att2_lorderke == probepayl.att2_lorderke));
                } else {
                    assert(bucketFound == 0);  ////
                    loopVar -= step;
                    atomicAdd((int *)&HT_FULL_FLAG, 1);  ////
                    break;  ////
                }
            }
#ifdef COLLISION_PRINT
            atomicAdd(&num_collision, numLookups - 1);
#endif
        }
        if(active && bucket != -1) {  ////
            atomicAdd(&(agg1[bucket]), ((int)1));
        }

        /// Implication and Disjunction: P->Q <=>  ^P OR Q
        /// bucket==-1 -> HT_FULL_FLAG!=0
        assert(bucket != -1 || HT_FULL_FLAG != 0);

        //// insert the tuple into the global memory hash table.
        __syncthreads();  ////
        if (HT_FULL_FLAG != 0) {
            sm_to_gm(aht2, agg1, g_aht2, g_agg1);
            __threadfence_block(); /// Ensure the ordering:
            initSMAggHT(aht2,SHARED_MEMORY_HT_SIZE);
            initSMAggArray(agg1,SHARED_MEMORY_HT_SIZE);
            if (threadIdx.x == 0) HT_FULL_FLAG = 0;
            __syncthreads();  ////
        }
        ////
        loopVar += step;
    }

    __syncthreads();  ///
#ifdef COLLISION_PRINT
    if (threadIdx.x == 0) {
        /// Allow only one print per block here.
        printf("In Block %d: num_collision: %d\n", blockIdx.x, num_collision);
    }
#endif
    sm_to_gm(aht2, agg1, g_aht2, g_agg1);
}

__global__ void krnl_aggregation2(
        agg_ht<apayl2>* aht2, int* agg1, int* nout_result, int* oatt2_lorderke, int* oatt1_countlor) {
    int att2_lorderke;
    int att1_countlor;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation2 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation2 = loopVar;
        active = (loopVar < GLOBAL_HT_SIZE);
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
            att2_lorderke = payl.att2_lorderke;
        }
        if(active) {
            att1_countlor = agg1[tid_aggregation2];
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
            oatt2_lorderke[wp] = att2_lorderke;
            oatt1_countlor[wp] = att1_countlor;
        }
        loopVar += step;
    }

}

int main() {
    int* iatt2_lorderke;
    iatt2_lorderke = ( int*) map_memory_file ( file_path.c_str() );

    int nout_result;
    std::vector < int > oatt2_lorderke(LINEITEM_SIZE);
    std::vector < int > oatt1_countlor(LINEITEM_SIZE);

    // wake up gpu
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in wake up gpu! " << cudaGetErrorString( err ) << std::endl;
            ERROR("wake up gpu")
        }
    }

    int* d_iatt2_lorderke;
    cudaMalloc((void**) &d_iatt2_lorderke, LINEITEM_SIZE* sizeof(int) );
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    int* d_oatt2_lorderke;
    cudaMalloc((void**) &d_oatt2_lorderke, LINEITEM_SIZE* sizeof(int) );
    int* d_oatt1_countlor;
    cudaMalloc((void**) &d_oatt1_countlor, LINEITEM_SIZE* sizeof(int) );
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

    agg_ht<apayl2>* d_global_aht2;
    cudaMalloc((void**) &d_global_aht2, GLOBAL_HT_SIZE* sizeof(agg_ht<apayl2>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_global_aht2, GLOBAL_HT_SIZE);
    }
    int* d_global_agg1;
    cudaMalloc((void**) &d_global_agg1, GLOBAL_HT_SIZE* sizeof(int) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_global_agg1, 0, GLOBAL_HT_SIZE);
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

    cudaMemcpy( d_iatt2_lorderke, iatt2_lorderke, LINEITEM_SIZE * sizeof(int), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime0 = std::clock();
    std::clock_t start_krnl_lineitem11 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        const int shared_memory_usage = (sizeof(agg_ht_sm<apayl2>) + sizeof(int)) * SHARED_MEMORY_HT_SIZE;
        std::cout << "Shared memory usage: " << shared_memory_usage << " bytes" << std::endl;
        cudaFuncSetAttribute(krnl_lineitem1, cudaFuncAttributeMaxDynamicSharedMemorySize, /*65536*/ shared_memory_usage);
        krnl_lineitem1<<<gridsize, blocksize, shared_memory_usage>>>(d_iatt2_lorderke, d_global_aht2, d_global_agg1);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_lineitem11 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_lineitem1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_lineitem1")
        }
    }

    std::clock_t start_krnl_aggregation22 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation2<<<gridsize, blocksize>>>(d_global_aht2, d_global_agg1, d_nout_result, d_oatt2_lorderke, d_oatt1_countlor);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation22 = std::clock();
    std::clock_t stop_totalKernelTime0 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation2! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation2")
        }
    }

    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt2_lorderke.data(), d_oatt2_lorderke, LINEITEM_SIZE * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt1_countlor.data(), d_oatt1_countlor, LINEITEM_SIZE * sizeof(int), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt2_lorderke);
    cudaFree( d_nout_result);
    cudaFree( d_oatt2_lorderke);
    cudaFree( d_oatt1_countlor);
    cudaFree( d_global_aht2);
    cudaFree( d_global_agg1);
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
    if((nout_result > LINEITEM_SIZE)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("l_orderkey: ");
        printf("%8i", oatt2_lorderke[pv]);
        printf("  ");
        printf("count_l_orderkey: ");
        printf("%8i", oatt1_countlor[pv]);
        printf("  ");
        printf("\n");
    }
    if((nout_result > 10)) {
        printf("[...unsorted...]\n");
    }
    printf("\n");

    /// 40 sorted output
    std::map<int, int> ht;
    for ( int pv = 0; pv < nout_result; pv += 1) {  ///
        ht.emplace(oatt2_lorderke[pv], oatt1_countlor[pv]);
    }
    auto it = ht.begin();
    printf("\nResult: %ld tuples\n", ht.size());
    for ( int pv = 0; ((pv < 25) && (pv < ht.size())); pv += 1) {
        printf("l_orderkey: ");
        printf("%8i", it->first);
        printf("  ");
        printf("count_l_orderkey: ");
        printf("%8i", it->second);
        printf("  ");
        printf("\n");
        std::advance(it, 1);
    }
    if((ht.size() > 25)) {
        printf("[...sorted...]\n");
    }
    printf("\n");
    std::clock_t stop_finish3 = std::clock();


    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish3 - start_finish3) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_lineitem1", (stop_krnl_lineitem11 - start_krnl_lineitem11) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation2", (stop_krnl_aggregation22 - start_krnl_aggregation22) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime0 - start_totalKernelTime0) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
