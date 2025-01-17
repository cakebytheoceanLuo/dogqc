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
struct jpayl5 {
    int att2_lorderke;
};
struct apayl6 {
    str_t att23_oorderpr;
};

__global__ void krnl_lineitem1(
    int* iatt2_lorderke, unsigned* iatt13_lcommitd, unsigned* iatt14_lreceipt, agg_ht<jpayl5>* jht5) {
    int att2_lorderke;
    unsigned att13_lcommitd;
    unsigned att14_lreceipt;

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
            att2_lorderke = iatt2_lorderke[tid_lineitem1];
            att13_lcommitd = iatt13_lcommitd[tid_lineitem1];
            att14_lreceipt = iatt14_lreceipt[tid_lineitem1];
        }
        // -------- selection (opId: 2) --------
        if(active) {
            active = (att13_lcommitd < att14_lreceipt);
        }
        // -------- hash join build (opId: 5) --------
        if(active) {
            uint64_t hash5;
            hash5 = 0;
            if(active) {
                hash5 = hash ( (hash5 + ((uint64_t)att2_lorderke)));
            }
            int bucket = 0;
            jpayl5 payl5;
            payl5.att2_lorderke = att2_lorderke;
            int bucketFound = 0;
            int numLookups = 0;
            while(!(bucketFound)) {
                bucket = hashAggregateGetBucket ( jht5, 1500303, hash5, numLookups, &(payl5));
                jpayl5 probepayl = jht5[bucket].payload;
                bucketFound = 1;
                bucketFound &= ((payl5.att2_lorderke == probepayl.att2_lorderke));
            }
        }
        loopVar += step;
    }

}

__global__ void krnl_orders3(
    int* iatt18_oorderke, unsigned* iatt22_oorderda, size_t* iatt23_oorderpr_offset, char* iatt23_oorderpr_char, agg_ht<jpayl5>* jht5, agg_ht<apayl6>* aht6, int* agg1) {
    int att18_oorderke;
    unsigned att22_oorderda;
    str_t att23_oorderpr;
    int att2_lorderke;

    int tid_orders1 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_orders1 = loopVar;
        active = (loopVar < 1500000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att18_oorderke = iatt18_oorderke[tid_orders1];
            att22_oorderda = iatt22_oorderda[tid_orders1];
            att23_oorderpr = stringScan ( iatt23_oorderpr_offset, iatt23_oorderpr_char, tid_orders1);
        }
        // -------- selection (opId: 4) --------
        if(active) {
            active = ((att22_oorderda < 19931001) && (att22_oorderda >= 19930701));
        }
        // -------- hash join probe (opId: 5) --------
        if(active) {
            uint64_t hash5 = 0;
            hash5 = 0;
            if(active) {
                hash5 = hash ( (hash5 + ((uint64_t)att18_oorderke)));
            }
            int numLookups5 = 0;
            int location5 = 0;
            int filterMatch5 = 0;
            int activeProbe5 = 1;
            while((!(filterMatch5) && activeProbe5)) {
                activeProbe5 = hashAggregateFindBucket ( jht5, 1500303, hash5, numLookups5, location5);
                if(activeProbe5) {
                    jpayl5 probepayl = jht5[location5].payload;
                    att2_lorderke = probepayl.att2_lorderke;
                    filterMatch5 = 1;
                    filterMatch5 &= ((att2_lorderke == att18_oorderke));
                }
            }
            active &= (filterMatch5);
        }
        // -------- aggregation (opId: 6) --------
        int bucket = 0;
        if(active) {
            uint64_t hash6 = 0;
            hash6 = 0;
            hash6 = hash ( (hash6 + stringHash ( att23_oorderpr)));
            apayl6 payl;
            payl.att23_oorderpr = att23_oorderpr;
            int bucketFound = 0;
            int numLookups = 0;
            while(!(bucketFound)) {
                bucket = hashAggregateGetBucket ( aht6, 200, hash6, numLookups, &(payl));
                apayl6 probepayl = aht6[bucket].payload;
                bucketFound = 1;
                bucketFound &= (stringEquals ( payl.att23_oorderpr, probepayl.att23_oorderpr));
            }
        }
        if(active) {
            atomicAdd(&(agg1[bucket]), ((int)1));
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation6(
    agg_ht<apayl6>* aht6, int* agg1, int* nout_result, str_offs* oatt23_oorderpr_offset, char* iatt23_oorderpr_char, int* oatt1_ordercou) {
    str_t att23_oorderpr;
    int att1_ordercou;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation6 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation6 = loopVar;
        active = (loopVar < 200);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 6) --------
        if(active) {
            active &= ((aht6[tid_aggregation6].lock.lock == OnceLock::LOCK_DONE));
        }
        if(active) {
            apayl6 payl = aht6[tid_aggregation6].payload;
            att23_oorderpr = payl.att23_oorderpr;
        }
        if(active) {
            att1_ordercou = agg1[tid_aggregation6];
        }
        // -------- projection (no code) (opId: 7) --------
        // -------- materialize (opId: 8) --------
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
            oatt23_oorderpr_offset[wp] = toStringOffset ( iatt23_oorderpr_char, att23_oorderpr);
            oatt1_ordercou[wp] = att1_ordercou;
        }
        loopVar += step;
    }

}

int main() {
    int* iatt2_lorderke;
    iatt2_lorderke = ( int*) map_memory_file ( "mmdb/lineitem_l_orderkey" );
    unsigned* iatt13_lcommitd;
    iatt13_lcommitd = ( unsigned*) map_memory_file ( "mmdb/lineitem_l_commitdate" );
    unsigned* iatt14_lreceipt;
    iatt14_lreceipt = ( unsigned*) map_memory_file ( "mmdb/lineitem_l_receiptdate" );
    int* iatt18_oorderke;
    iatt18_oorderke = ( int*) map_memory_file ( "mmdb/orders_o_orderkey" );
    unsigned* iatt22_oorderda;
    iatt22_oorderda = ( unsigned*) map_memory_file ( "mmdb/orders_o_orderdate" );
    size_t* iatt23_oorderpr_offset;
    iatt23_oorderpr_offset = ( size_t*) map_memory_file ( "mmdb/orders_o_orderpriority_offset" );
    char* iatt23_oorderpr_char;
    iatt23_oorderpr_char = ( char*) map_memory_file ( "mmdb/orders_o_orderpriority_char" );

    int nout_result;
    std::vector < str_offs > oatt23_oorderpr_offset(100);
    std::vector < int > oatt1_ordercou(100);

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
    cudaMalloc((void**) &d_iatt2_lorderke, 6001215* sizeof(int) );
    unsigned* d_iatt13_lcommitd;
    cudaMalloc((void**) &d_iatt13_lcommitd, 6001215* sizeof(unsigned) );
    unsigned* d_iatt14_lreceipt;
    cudaMalloc((void**) &d_iatt14_lreceipt, 6001215* sizeof(unsigned) );
    int* d_iatt18_oorderke;
    cudaMalloc((void**) &d_iatt18_oorderke, 1500000* sizeof(int) );
    unsigned* d_iatt22_oorderda;
    cudaMalloc((void**) &d_iatt22_oorderda, 1500000* sizeof(unsigned) );
    size_t* d_iatt23_oorderpr_offset;
    cudaMalloc((void**) &d_iatt23_oorderpr_offset, (1500000 + 1)* sizeof(size_t) );
    char* d_iatt23_oorderpr_char;
    cudaMalloc((void**) &d_iatt23_oorderpr_char, 12599838* sizeof(char) );
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    str_offs* d_oatt23_oorderpr_offset;
    cudaMalloc((void**) &d_oatt23_oorderpr_offset, 100* sizeof(str_offs) );
    int* d_oatt1_ordercou;
    cudaMalloc((void**) &d_oatt1_ordercou, 100* sizeof(int) );
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

    agg_ht<jpayl5>* d_jht5;
    cudaMalloc((void**) &d_jht5, 1500303* sizeof(agg_ht<jpayl5>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_jht5, 1500303);
    }
    agg_ht<apayl6>* d_aht6;
    cudaMalloc((void**) &d_aht6, 200* sizeof(agg_ht<apayl6>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_aht6, 200);
    }
    int* d_agg1;
    cudaMalloc((void**) &d_agg1, 200* sizeof(int) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg1, 0, 200);
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

    cudaMemcpy( d_iatt2_lorderke, iatt2_lorderke, 6001215 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt13_lcommitd, iatt13_lcommitd, 6001215 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt14_lreceipt, iatt14_lreceipt, 6001215 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt18_oorderke, iatt18_oorderke, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt22_oorderda, iatt22_oorderda, 1500000 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt23_oorderpr_offset, iatt23_oorderpr_offset, (1500000 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt23_oorderpr_char, iatt23_oorderpr_char, 12599838 * sizeof(char), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime29 = std::clock();
    std::clock_t start_krnl_lineitem130 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_lineitem1<<<gridsize, blocksize>>>(d_iatt2_lorderke, d_iatt13_lcommitd, d_iatt14_lreceipt, d_jht5);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_lineitem130 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_lineitem1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_lineitem1")
        }
    }

    std::clock_t start_krnl_orders331 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_orders3<<<gridsize, blocksize>>>(d_iatt18_oorderke, d_iatt22_oorderda, d_iatt23_oorderpr_offset, d_iatt23_oorderpr_char, d_jht5, d_aht6, d_agg1);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_orders331 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_orders3! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_orders3")
        }
    }

    std::clock_t start_krnl_aggregation632 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation6<<<gridsize, blocksize>>>(d_aht6, d_agg1, d_nout_result, d_oatt23_oorderpr_offset, d_iatt23_oorderpr_char, d_oatt1_ordercou);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation632 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation6! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation6")
        }
    }

    std::clock_t stop_totalKernelTime29 = std::clock();
    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt23_oorderpr_offset.data(), d_oatt23_oorderpr_offset, 100 * sizeof(str_offs), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt1_ordercou.data(), d_oatt1_ordercou, 100 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt2_lorderke);
    cudaFree( d_iatt13_lcommitd);
    cudaFree( d_iatt14_lreceipt);
    cudaFree( d_jht5);
    cudaFree( d_iatt18_oorderke);
    cudaFree( d_iatt22_oorderda);
    cudaFree( d_iatt23_oorderpr_offset);
    cudaFree( d_iatt23_oorderpr_char);
    cudaFree( d_aht6);
    cudaFree( d_agg1);
    cudaFree( d_nout_result);
    cudaFree( d_oatt23_oorderpr_offset);
    cudaFree( d_oatt1_ordercou);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda free! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda free")
        }
    }

    std::clock_t start_finish33 = std::clock();
    printf("\nResult: %i tuples\n", nout_result);
    if((nout_result > 100)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("o_orderpriority: ");
        stringPrint ( iatt23_oorderpr_char, oatt23_oorderpr_offset[pv]);
        printf("  ");
        printf("order_count: ");
        printf("%8i", oatt1_ordercou[pv]);
        printf("  ");
        printf("\n");
    }
    if((nout_result > 10)) {
        printf("[...]\n");
    }
    printf("\n");
    std::clock_t stop_finish33 = std::clock();

    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "krnl_lineitem1", (stop_krnl_lineitem130 - start_krnl_lineitem130) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_orders3", (stop_krnl_orders331 - start_krnl_orders331) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation6", (stop_krnl_aggregation632 - start_krnl_aggregation632) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish33 - start_finish33) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime29 - start_totalKernelTime29) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
