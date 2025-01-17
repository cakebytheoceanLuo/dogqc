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
struct jpayl8 {
    int att6_ocustkey;
};
struct apayl10 {
    str_t att30_cntrycod;
};

__global__ void krnl_orders1(
    int* iatt6_ocustkey, agg_ht<jpayl8>* jht8) {
    int att6_ocustkey;

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
            att6_ocustkey = iatt6_ocustkey[tid_orders1];
        }
        // -------- hash join build (opId: 8) --------
        if(active) {
            uint64_t hash8;
            hash8 = 0;
            if(active) {
                hash8 = hash ( (hash8 + ((uint64_t)att6_ocustkey)));
            }
            int bucket = 0;
            jpayl8 payl8;
            payl8.att6_ocustkey = att6_ocustkey;
            int bucketFound = 0;
            int numLookups = 0;
            while(!(bucketFound)) {
                bucket = hashAggregateGetBucket ( jht8, 3000000, hash8, numLookups, &(payl8));
                jpayl8 probepayl = jht8[bucket].payload;
                bucketFound = 1;
                bucketFound &= ((payl8.att6_ocustkey == probepayl.att6_ocustkey));
            }
        }
        loopVar += step;
    }

}

__global__ void krnl_customer2(
    size_t* iatt18_cphone_offset, char* iatt18_cphone_char, float* iatt19_cacctbal, float* agg1, int* agg2) {
    str_t att18_cphone;
    float att19_cacctbal;
    str_t c1 = stringConstant ( "17", 2);
    str_t c2 = stringConstant ( "18", 2);
    str_t c3 = stringConstant ( "30", 2);
    str_t c4 = stringConstant ( "29", 2);
    str_t c5 = stringConstant ( "23", 2);
    str_t c6 = stringConstant ( "31", 2);
    str_t c7 = stringConstant ( "13", 2);

    int tid_customer1 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_customer1 = loopVar;
        active = (loopVar < 150000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att18_cphone = stringScan ( iatt18_cphone_offset, iatt18_cphone_char, tid_customer1);
            att19_cacctbal = iatt19_cacctbal[tid_customer1];
        }
        // -------- selection (opId: 3) --------
        if(active) {
            active = ((att19_cacctbal > 0.00) && (stringEquals ( stringSubstring ( att18_cphone, 1, 2), c1) || (stringEquals ( stringSubstring ( att18_cphone, 1, 2), c2) || (stringEquals ( stringSubstring ( att18_cphone, 1, 2), c3) || (stringEquals ( stringSubstring ( att18_cphone, 1, 2), c4) || (stringEquals ( stringSubstring ( att18_cphone, 1, 2), c5) || (stringEquals ( stringSubstring ( att18_cphone, 1, 2), c6) || stringEquals ( stringSubstring ( att18_cphone, 1, 2), c7))))))));
        }
        // -------- aggregation (opId: 4) --------
        int bucket = 0;
        if(active) {
            atomicAdd(&(agg1[bucket]), ((float)att19_cacctbal));
            atomicAdd(&(agg2[bucket]), ((int)1));
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation4(
    float* agg1, int* agg2, int* nout_inner7, float* itm_inner7_avg) {
    float att1_avg;
    int att2_countagg;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation4 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation4 = loopVar;
        active = (loopVar < 1);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 4) --------
        if(active) {
            att1_avg = agg1[tid_aggregation4];
            att2_countagg = agg2[tid_aggregation4];
            att1_avg = (att1_avg / ((float)att2_countagg));
        }
        // -------- nested join: materialize inner  (opId: 7) --------
        int wp;
        int writeMask;
        int numProj;
        writeMask = __ballot_sync(ALL_LANES,active);
        numProj = __popc(writeMask);
        if((warplane == 0)) {
            wp = atomicAdd(nout_inner7, numProj);
        }
        wp = __shfl_sync(ALL_LANES,wp,0);
        wp = (wp + __popc((writeMask & prefixlanes)));
        if(active) {
            itm_inner7_avg[wp] = att1_avg;
        }
        loopVar += step;
    }

}

__global__ void krnl_customer25(
    int* iatt22_ccustkey, size_t* iatt26_cphone_offset, char* iatt26_cphone_char, float* iatt27_cacctbal, int* nout_inner7, float* itm_inner7_avg, agg_ht<jpayl8>* jht8, agg_ht<apayl10>* aht10, int* agg3, float* agg4) {
    int att22_ccustkey;
    str_t att26_cphone;
    float att27_cacctbal;
    str_t c8 = stringConstant ( "17", 2);
    str_t c9 = stringConstant ( "18", 2);
    str_t c10 = stringConstant ( "30", 2);
    str_t c11 = stringConstant ( "29", 2);
    str_t c12 = stringConstant ( "23", 2);
    str_t c13 = stringConstant ( "31", 2);
    str_t c14 = stringConstant ( "13", 2);
    float att1_avg;
    int att6_ocustkey;
    str_t att30_cntrycod;

    int tid_customer2 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_customer2 = loopVar;
        active = (loopVar < 150000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att22_ccustkey = iatt22_ccustkey[tid_customer2];
            att26_cphone = stringScan ( iatt26_cphone_offset, iatt26_cphone_char, tid_customer2);
            att27_cacctbal = iatt27_cacctbal[tid_customer2];
        }
        // -------- selection (opId: 6) --------
        if(active) {
            active = (stringEquals ( stringSubstring ( att26_cphone, 1, 2), c8) || (stringEquals ( stringSubstring ( att26_cphone, 1, 2), c9) || (stringEquals ( stringSubstring ( att26_cphone, 1, 2), c10) || (stringEquals ( stringSubstring ( att26_cphone, 1, 2), c11) || (stringEquals ( stringSubstring ( att26_cphone, 1, 2), c12) || (stringEquals ( stringSubstring ( att26_cphone, 1, 2), c13) || stringEquals ( stringSubstring ( att26_cphone, 1, 2), c14)))))));
        }
        // -------- nested join: loop inner  (opId: 7) --------
        int outerActive7 = active;
        for ( int tid_inner70 = 0; (tid_inner70 < *(nout_inner7)); (tid_inner70++)) {
            active = outerActive7;
            if(active) {
                att1_avg = itm_inner7_avg[tid_inner70];
            }
            if(active) {
                active = (att27_cacctbal > att1_avg);
            }
            // -------- hash join probe (opId: 8) --------
            if(active) {
                uint64_t hash8 = 0;
                hash8 = 0;
                if(active) {
                    hash8 = hash ( (hash8 + ((uint64_t)att22_ccustkey)));
                }
                int numLookups8 = 0;
                int location8 = 0;
                int filterMatch8 = 0;
                int activeProbe8 = 1;
                while((!(filterMatch8) && activeProbe8)) {
                    activeProbe8 = hashAggregateFindBucket ( jht8, 3000000, hash8, numLookups8, location8);
                    if(activeProbe8) {
                        jpayl8 probepayl = jht8[location8].payload;
                        att6_ocustkey = probepayl.att6_ocustkey;
                        filterMatch8 = 1;
                        filterMatch8 &= ((att6_ocustkey == att22_ccustkey));
                    }
                }
                active &= (!(filterMatch8));
            }
            // -------- map (opId: 9) --------
            if(active) {
                att30_cntrycod = stringSubstring ( att26_cphone, 1, 2);
            }
            // -------- aggregation (opId: 10) --------
            int bucket = 0;
            if(active) {
                uint64_t hash10 = 0;
                hash10 = 0;
                hash10 = hash ( (hash10 + stringHash ( att30_cntrycod)));
                apayl10 payl;
                payl.att30_cntrycod = att30_cntrycod;
                int bucketFound = 0;
                int numLookups = 0;
                while(!(bucketFound)) {
                    bucket = hashAggregateGetBucket ( aht10, 3000000, hash10, numLookups, &(payl));
                    apayl10 probepayl = aht10[bucket].payload;
                    bucketFound = 1;
                    bucketFound &= (stringEquals ( payl.att30_cntrycod, probepayl.att30_cntrycod));
                }
            }
            if(active) {
                atomicAdd(&(agg3[bucket]), ((int)1));
                atomicAdd(&(agg4[bucket]), ((float)att27_cacctbal));
            }
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation10(
    agg_ht<apayl10>* aht10, int* agg3, float* agg4, int* nout_result, str_offs* oatt30_cntrycod_offset, char* iatt26_cphone_char, int* oatt3_numcust, float* oatt4_totacctb) {
    str_t att30_cntrycod;
    int att3_numcust;
    float att4_totacctb;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation10 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation10 = loopVar;
        active = (loopVar < 3000000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 10) --------
        if(active) {
            active &= ((aht10[tid_aggregation10].lock.lock == OnceLock::LOCK_DONE));
        }
        if(active) {
            apayl10 payl = aht10[tid_aggregation10].payload;
            att30_cntrycod = payl.att30_cntrycod;
        }
        if(active) {
            att3_numcust = agg3[tid_aggregation10];
            att4_totacctb = agg4[tid_aggregation10];
        }
        // -------- materialize (opId: 11) --------
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
            oatt30_cntrycod_offset[wp] = toStringOffset ( iatt26_cphone_char, att30_cntrycod);
            oatt3_numcust[wp] = att3_numcust;
            oatt4_totacctb[wp] = att4_totacctb;
        }
        loopVar += step;
    }

}

int main() {
    int* iatt6_ocustkey;
    iatt6_ocustkey = ( int*) map_memory_file ( "mmdb/orders_o_custkey" );
    size_t* iatt18_cphone_offset;
    iatt18_cphone_offset = ( size_t*) map_memory_file ( "mmdb/customer_c_phone_offset" );
    char* iatt18_cphone_char;
    iatt18_cphone_char = ( char*) map_memory_file ( "mmdb/customer_c_phone_char" );
    float* iatt19_cacctbal;
    iatt19_cacctbal = ( float*) map_memory_file ( "mmdb/customer_c_acctbal" );
    int* iatt22_ccustkey;
    iatt22_ccustkey = ( int*) map_memory_file ( "mmdb/customer_c_custkey" );
    size_t* iatt26_cphone_offset;
    iatt26_cphone_offset = ( size_t*) map_memory_file ( "mmdb/customer_c_phone_offset" );
    char* iatt26_cphone_char;
    iatt26_cphone_char = ( char*) map_memory_file ( "mmdb/customer_c_phone_char" );
    float* iatt27_cacctbal;
    iatt27_cacctbal = ( float*) map_memory_file ( "mmdb/customer_c_acctbal" );

    int nout_inner7;
    int nout_result;
    std::vector < str_offs > oatt30_cntrycod_offset(1500000);
    std::vector < int > oatt3_numcust(1500000);
    std::vector < float > oatt4_totacctb(1500000);

    // wake up gpu
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in wake up gpu! " << cudaGetErrorString( err ) << std::endl;
            ERROR("wake up gpu")
        }
    }

    int* d_iatt6_ocustkey;
    cudaMalloc((void**) &d_iatt6_ocustkey, 1500000* sizeof(int) );
    size_t* d_iatt18_cphone_offset;
    cudaMalloc((void**) &d_iatt18_cphone_offset, (150000 + 1)* sizeof(size_t) );
    char* d_iatt18_cphone_char;
    cudaMalloc((void**) &d_iatt18_cphone_char, 2250009* sizeof(char) );
    float* d_iatt19_cacctbal;
    cudaMalloc((void**) &d_iatt19_cacctbal, 150000* sizeof(float) );
    int* d_nout_inner7;
    cudaMalloc((void**) &d_nout_inner7, 1* sizeof(int) );
    float* d_itm_inner7_avg;
    cudaMalloc((void**) &d_itm_inner7_avg, 1* sizeof(float) );
    int* d_iatt22_ccustkey;
    cudaMalloc((void**) &d_iatt22_ccustkey, 150000* sizeof(int) );
    size_t* d_iatt26_cphone_offset;
    d_iatt26_cphone_offset = d_iatt18_cphone_offset;
    char* d_iatt26_cphone_char;
    d_iatt26_cphone_char = d_iatt18_cphone_char;
    float* d_iatt27_cacctbal;
    d_iatt27_cacctbal = d_iatt19_cacctbal;
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    str_offs* d_oatt30_cntrycod_offset;
    cudaMalloc((void**) &d_oatt30_cntrycod_offset, 1500000* sizeof(str_offs) );
    int* d_oatt3_numcust;
    cudaMalloc((void**) &d_oatt3_numcust, 1500000* sizeof(int) );
    float* d_oatt4_totacctb;
    cudaMalloc((void**) &d_oatt4_totacctb, 1500000* sizeof(float) );
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

    agg_ht<jpayl8>* d_jht8;
    cudaMalloc((void**) &d_jht8, 3000000* sizeof(agg_ht<jpayl8>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_jht8, 3000000);
    }
    float* d_agg1;
    cudaMalloc((void**) &d_agg1, 1* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg1, 0.0f, 1);
    }
    int* d_agg2;
    cudaMalloc((void**) &d_agg2, 1* sizeof(int) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg2, 0, 1);
    }
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_nout_inner7, 0, 1);
    }
    agg_ht<apayl10>* d_aht10;
    cudaMalloc((void**) &d_aht10, 3000000* sizeof(agg_ht<apayl10>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_aht10, 3000000);
    }
    int* d_agg3;
    cudaMalloc((void**) &d_agg3, 3000000* sizeof(int) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg3, 0, 3000000);
    }
    float* d_agg4;
    cudaMalloc((void**) &d_agg4, 3000000* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg4, 0.0f, 3000000);
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

    cudaMemcpy( d_iatt6_ocustkey, iatt6_ocustkey, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt18_cphone_offset, iatt18_cphone_offset, (150000 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt18_cphone_char, iatt18_cphone_char, 2250009 * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt19_cacctbal, iatt19_cacctbal, 150000 * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt22_ccustkey, iatt22_ccustkey, 150000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime193 = std::clock();
    std::clock_t start_krnl_orders1194 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_orders1<<<gridsize, blocksize>>>(d_iatt6_ocustkey, d_jht8);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_orders1194 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_orders1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_orders1")
        }
    }

    std::clock_t start_krnl_customer2195 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_customer2<<<gridsize, blocksize>>>(d_iatt18_cphone_offset, d_iatt18_cphone_char, d_iatt19_cacctbal, d_agg1, d_agg2);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_customer2195 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_customer2! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_customer2")
        }
    }

    std::clock_t start_krnl_aggregation4196 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation4<<<gridsize, blocksize>>>(d_agg1, d_agg2, d_nout_inner7, d_itm_inner7_avg);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation4196 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation4! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation4")
        }
    }

    std::clock_t start_krnl_customer25197 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_customer25<<<gridsize, blocksize>>>(d_iatt22_ccustkey, d_iatt26_cphone_offset, d_iatt26_cphone_char, d_iatt27_cacctbal, d_nout_inner7, d_itm_inner7_avg, d_jht8, d_aht10, d_agg3, d_agg4);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_customer25197 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_customer25! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_customer25")
        }
    }

    std::clock_t start_krnl_aggregation10198 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation10<<<gridsize, blocksize>>>(d_aht10, d_agg3, d_agg4, d_nout_result, d_oatt30_cntrycod_offset, d_iatt26_cphone_char, d_oatt3_numcust, d_oatt4_totacctb);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation10198 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation10! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation10")
        }
    }

    std::clock_t stop_totalKernelTime193 = std::clock();
    cudaMemcpy( &nout_inner7, d_nout_inner7, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt30_cntrycod_offset.data(), d_oatt30_cntrycod_offset, 1500000 * sizeof(str_offs), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt3_numcust.data(), d_oatt3_numcust, 1500000 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt4_totacctb.data(), d_oatt4_totacctb, 1500000 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt6_ocustkey);
    cudaFree( d_jht8);
    cudaFree( d_iatt18_cphone_offset);
    cudaFree( d_iatt18_cphone_char);
    cudaFree( d_iatt19_cacctbal);
    cudaFree( d_agg1);
    cudaFree( d_agg2);
    cudaFree( d_nout_inner7);
    cudaFree( d_itm_inner7_avg);
    cudaFree( d_iatt22_ccustkey);
    cudaFree( d_aht10);
    cudaFree( d_agg3);
    cudaFree( d_agg4);
    cudaFree( d_nout_result);
    cudaFree( d_oatt30_cntrycod_offset);
    cudaFree( d_oatt3_numcust);
    cudaFree( d_oatt4_totacctb);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda free! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda free")
        }
    }

    std::clock_t start_finish199 = std::clock();
    printf("\nResult: %i tuples\n", nout_result);
    if((nout_result > 1500000)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("cntrycode: ");
        stringPrint ( iatt26_cphone_char, oatt30_cntrycod_offset[pv]);
        printf("  ");
        printf("numcust: ");
        printf("%8i", oatt3_numcust[pv]);
        printf("  ");
        printf("totacctbal: ");
        printf("%15.2f", oatt4_totacctb[pv]);
        printf("  ");
        printf("\n");
    }
    if((nout_result > 10)) {
        printf("[...]\n");
    }
    printf("\n");
    std::clock_t stop_finish199 = std::clock();

    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "krnl_orders1", (stop_krnl_orders1194 - start_krnl_orders1194) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_customer2", (stop_krnl_customer2195 - start_krnl_customer2195) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation4", (stop_krnl_aggregation4196 - start_krnl_aggregation4196) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_customer25", (stop_krnl_customer25197 - start_krnl_customer25197) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation10", (stop_krnl_aggregation10198 - start_krnl_aggregation10198) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish199 - start_finish199) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime193 - start_totalKernelTime193) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
