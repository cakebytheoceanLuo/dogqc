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
struct jpayl4 {
    int att2_oorderke;
    int att3_ocustkey;
};
struct apayl5 {
    int att11_ccustkey;
};

__global__ void krnl_orders1(
    int* iatt2_oorderke, int* iatt3_ocustkey, size_t* iatt10_ocomment_offset, char* iatt10_ocomment_char, multi_ht* jht4, jpayl4* jht4_payload) {
    int att2_oorderke;
    int att3_ocustkey;
    str_t att10_ocomment;
    str_t c1 = stringConstant ( "%special%requests%", 18);

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
            att2_oorderke = iatt2_oorderke[tid_orders1];
            att3_ocustkey = iatt3_ocustkey[tid_orders1];
            att10_ocomment = stringScan ( iatt10_ocomment_offset, iatt10_ocomment_char, tid_orders1);
        }
        // -------- selection (opId: 2) --------
        if(active) {
            active = !(stringLikeCheck ( att10_ocomment, c1));
        }
        // -------- hash join build (opId: 4) --------
        if(active) {
            uint64_t hash4 = 0;
            if(active) {
                hash4 = 0;
                if(active) {
                    hash4 = hash ( (hash4 + ((uint64_t)att3_ocustkey)));
                }
            }
            hashCountMulti ( jht4, 3000000, hash4);
        }
        loopVar += step;
    }

}

__global__ void krnl_orders1_ins(
    int* iatt2_oorderke, int* iatt3_ocustkey, size_t* iatt10_ocomment_offset, char* iatt10_ocomment_char, multi_ht* jht4, jpayl4* jht4_payload, int* offs4) {
    int att2_oorderke;
    int att3_ocustkey;
    str_t att10_ocomment;
    str_t c1 = stringConstant ( "%special%requests%", 18);

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
            att2_oorderke = iatt2_oorderke[tid_orders1];
            att3_ocustkey = iatt3_ocustkey[tid_orders1];
            att10_ocomment = stringScan ( iatt10_ocomment_offset, iatt10_ocomment_char, tid_orders1);
        }
        // -------- selection (opId: 2) --------
        if(active) {
            active = !(stringLikeCheck ( att10_ocomment, c1));
        }
        // -------- hash join build (opId: 4) --------
        if(active) {
            uint64_t hash4 = 0;
            if(active) {
                hash4 = 0;
                if(active) {
                    hash4 = hash ( (hash4 + ((uint64_t)att3_ocustkey)));
                }
            }
            jpayl4 payl;
            payl.att2_oorderke = att2_oorderke;
            payl.att3_ocustkey = att3_ocustkey;
            hashInsertMulti ( jht4, jht4_payload, offs4, 3000000, hash4, &(payl));
        }
        loopVar += step;
    }

}

__global__ void krnl_customer3(
    int* iatt11_ccustkey, multi_ht* jht4, jpayl4* jht4_payload, agg_ht<apayl5>* aht5, int* agg1) {
    int att11_ccustkey;
    unsigned warplane = (threadIdx.x % 32);
    int att2_oorderke;
    int att3_ocustkey;

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
            att11_ccustkey = iatt11_ccustkey[tid_customer1];
        }
        // -------- hash join probe (opId: 4) --------
        // -------- multiprobe multi broadcast (opId: 4) --------
        int matchEnd4 = 0;
        int matchEndBuf4 = 0;
        int matchOffset4 = 0;
        int matchOffsetBuf4 = 0;
        int probeActive4 = active;
        int att11_ccustkey_bcbuf4;
        uint64_t hash4 = 0;
        if(probeActive4) {
            hash4 = 0;
            if(active) {
                hash4 = hash ( (hash4 + ((uint64_t)att11_ccustkey)));
            }
            probeActive4 = hashProbeMulti ( jht4, 3000000, hash4, matchOffsetBuf4, matchEndBuf4);
        }
        unsigned activeProbes4 = __ballot_sync(ALL_LANES,probeActive4);
        int num4 = 0;
        num4 = (matchEndBuf4 - matchOffsetBuf4);
        unsigned wideProbes4 = __ballot_sync(ALL_LANES,(num4 >= 32));
        att11_ccustkey_bcbuf4 = att11_ccustkey;
        while((activeProbes4 > 0)) {
            unsigned tupleLane;
            unsigned broadcastLane;
            int numFilled = 0;
            int num = 0;
            while(((numFilled < 32) && activeProbes4)) {
                if((wideProbes4 > 0)) {
                    tupleLane = (__ffs(wideProbes4) - 1);
                    wideProbes4 -= (1 << tupleLane);
                }
                else {
                    tupleLane = (__ffs(activeProbes4) - 1);
                }
                num = __shfl_sync(ALL_LANES,num4,tupleLane);
                if((numFilled && ((numFilled + num) > 32))) {
                    break;
                }
                if((warplane >= numFilled)) {
                    broadcastLane = tupleLane;
                    matchOffset4 = (warplane - numFilled);
                }
                numFilled += num;
                activeProbes4 -= (1 << tupleLane);
            }
            matchOffset4 += __shfl_sync(ALL_LANES,matchOffsetBuf4,broadcastLane);
            matchEnd4 = __shfl_sync(ALL_LANES,matchEndBuf4,broadcastLane);
            att11_ccustkey = __shfl_sync(ALL_LANES,att11_ccustkey_bcbuf4,broadcastLane);
            probeActive4 = (matchOffset4 < matchEnd4);
            while(__any_sync(ALL_LANES,probeActive4)) {
                active = probeActive4;
                active = 0;
                jpayl4 payl;
                if(probeActive4) {
                    payl = jht4_payload[matchOffset4];
                    att2_oorderke = payl.att2_oorderke;
                    att3_ocustkey = payl.att3_ocustkey;
                    active = 1;
                    active &= ((att3_ocustkey == att11_ccustkey));
                    matchOffset4 += 32;
                    probeActive4 &= ((matchOffset4 < matchEnd4));
                }
                // -------- aggregation (opId: 5) --------
                int bucket = 0;
                if(active) {
                    uint64_t hash5 = 0;
                    hash5 = 0;
                    if(active) {
                        hash5 = hash ( (hash5 + ((uint64_t)att11_ccustkey)));
                    }
                    apayl5 payl;
                    payl.att11_ccustkey = att11_ccustkey;
                    int bucketFound = 0;
                    int numLookups = 0;
                    while(!(bucketFound)) {
                        bucket = hashAggregateGetBucket ( aht5, 3000000, hash5, numLookups, &(payl));
                        apayl5 probepayl = aht5[bucket].payload;
                        bucketFound = 1;
                        bucketFound &= ((payl.att11_ccustkey == probepayl.att11_ccustkey));
                    }
                }
                if(active) {
                    atomicAdd(&(agg1[bucket]), ((int)1));
                }
            }
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation5(
    agg_ht<apayl5>* aht5, int* agg1, int* nout_result, int* oatt11_ccustkey, int* oatt1_ccount) {
    int att11_ccustkey;
    int att1_ccount;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation5 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation5 = loopVar;
        active = (loopVar < 3000000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 5) --------
        if(active) {
            active &= ((aht5[tid_aggregation5].lock.lock == OnceLock::LOCK_DONE));
        }
        if(active) {
            apayl5 payl = aht5[tid_aggregation5].payload;
            att11_ccustkey = payl.att11_ccustkey;
        }
        if(active) {
            att1_ccount = agg1[tid_aggregation5];
        }
        // -------- materialize (opId: 6) --------
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
            oatt11_ccustkey[wp] = att11_ccustkey;
            oatt1_ccount[wp] = att1_ccount;
        }
        loopVar += step;
    }

}

int main() {
    int* iatt2_oorderke;
    iatt2_oorderke = ( int*) map_memory_file ( "mmdb/orders_o_orderkey" );
    int* iatt3_ocustkey;
    iatt3_ocustkey = ( int*) map_memory_file ( "mmdb/orders_o_custkey" );
    size_t* iatt10_ocomment_offset;
    iatt10_ocomment_offset = ( size_t*) map_memory_file ( "mmdb/orders_o_comment_offset" );
    char* iatt10_ocomment_char;
    iatt10_ocomment_char = ( char*) map_memory_file ( "mmdb/orders_o_comment_char" );
    int* iatt11_ccustkey;
    iatt11_ccustkey = ( int*) map_memory_file ( "mmdb/customer_c_custkey" );

    int nout_result;
    std::vector < int > oatt11_ccustkey(1500000);
    std::vector < int > oatt1_ccount(1500000);

    // wake up gpu
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in wake up gpu! " << cudaGetErrorString( err ) << std::endl;
            ERROR("wake up gpu")
        }
    }

    int* d_iatt2_oorderke;
    cudaMalloc((void**) &d_iatt2_oorderke, 1500000* sizeof(int) );
    int* d_iatt3_ocustkey;
    cudaMalloc((void**) &d_iatt3_ocustkey, 1500000* sizeof(int) );
    size_t* d_iatt10_ocomment_offset;
    cudaMalloc((void**) &d_iatt10_ocomment_offset, (1500000 + 1)* sizeof(size_t) );
    char* d_iatt10_ocomment_char;
    cudaMalloc((void**) &d_iatt10_ocomment_char, 72372224* sizeof(char) );
    int* d_iatt11_ccustkey;
    cudaMalloc((void**) &d_iatt11_ccustkey, 150000* sizeof(int) );
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    int* d_oatt11_ccustkey;
    cudaMalloc((void**) &d_oatt11_ccustkey, 1500000* sizeof(int) );
    int* d_oatt1_ccount;
    cudaMalloc((void**) &d_oatt1_ccount, 1500000* sizeof(int) );
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

    multi_ht* d_jht4;
    cudaMalloc((void**) &d_jht4, 3000000* sizeof(multi_ht) );
    jpayl4* d_jht4_payload;
    cudaMalloc((void**) &d_jht4_payload, 3000000* sizeof(jpayl4) );
    {
        int gridsize=920;
        int blocksize=128;
        initMultiHT<<<gridsize, blocksize>>>(d_jht4, 3000000);
    }
    int* d_offs4;
    cudaMalloc((void**) &d_offs4, 1* sizeof(int) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_offs4, 0, 1);
    }
    agg_ht<apayl5>* d_aht5;
    cudaMalloc((void**) &d_aht5, 3000000* sizeof(agg_ht<apayl5>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_aht5, 3000000);
    }
    int* d_agg1;
    cudaMalloc((void**) &d_agg1, 3000000* sizeof(int) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg1, 0, 3000000);
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

    cudaMemcpy( d_iatt2_oorderke, iatt2_oorderke, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt3_ocustkey, iatt3_ocustkey, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt10_ocomment_offset, iatt10_ocomment_offset, (1500000 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt10_ocomment_char, iatt10_ocomment_char, 72372224 * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt11_ccustkey, iatt11_ccustkey, 150000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime112 = std::clock();
    std::clock_t start_krnl_orders1113 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_orders1<<<gridsize, blocksize>>>(d_iatt2_oorderke, d_iatt3_ocustkey, d_iatt10_ocomment_offset, d_iatt10_ocomment_char, d_jht4, d_jht4_payload);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_orders1113 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_orders1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_orders1")
        }
    }

    std::clock_t start_scanMultiHT114 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        scanMultiHT<<<gridsize, blocksize>>>(d_jht4, 3000000, d_offs4);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_scanMultiHT114 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in scanMultiHT! " << cudaGetErrorString( err ) << std::endl;
            ERROR("scanMultiHT")
        }
    }

    std::clock_t start_krnl_orders1_ins115 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_orders1_ins<<<gridsize, blocksize>>>(d_iatt2_oorderke, d_iatt3_ocustkey, d_iatt10_ocomment_offset, d_iatt10_ocomment_char, d_jht4, d_jht4_payload, d_offs4);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_orders1_ins115 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_orders1_ins! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_orders1_ins")
        }
    }

    std::clock_t start_krnl_customer3116 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_customer3<<<gridsize, blocksize>>>(d_iatt11_ccustkey, d_jht4, d_jht4_payload, d_aht5, d_agg1);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_customer3116 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_customer3! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_customer3")
        }
    }

    std::clock_t start_krnl_aggregation5117 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation5<<<gridsize, blocksize>>>(d_aht5, d_agg1, d_nout_result, d_oatt11_ccustkey, d_oatt1_ccount);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation5117 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation5! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation5")
        }
    }

    std::clock_t stop_totalKernelTime112 = std::clock();
    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt11_ccustkey.data(), d_oatt11_ccustkey, 1500000 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt1_ccount.data(), d_oatt1_ccount, 1500000 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt2_oorderke);
    cudaFree( d_iatt3_ocustkey);
    cudaFree( d_iatt10_ocomment_offset);
    cudaFree( d_iatt10_ocomment_char);
    cudaFree( d_jht4);
    cudaFree( d_jht4_payload);
    cudaFree( d_offs4);
    cudaFree( d_iatt11_ccustkey);
    cudaFree( d_aht5);
    cudaFree( d_agg1);
    cudaFree( d_nout_result);
    cudaFree( d_oatt11_ccustkey);
    cudaFree( d_oatt1_ccount);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda free! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda free")
        }
    }

    std::clock_t start_finish118 = std::clock();
    printf("\nResult: %i tuples\n", nout_result);
    if((nout_result > 1500000)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("c_custkey: ");
        printf("%8i", oatt11_ccustkey[pv]);
        printf("  ");
        printf("c_count: ");
        printf("%8i", oatt1_ccount[pv]);
        printf("  ");
        printf("\n");
    }
    if((nout_result > 10)) {
        printf("[...]\n");
    }
    printf("\n");
    std::clock_t stop_finish118 = std::clock();

    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "krnl_orders1", (stop_krnl_orders1113 - start_krnl_orders1113) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "scanMultiHT", (stop_scanMultiHT114 - start_scanMultiHT114) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_orders1_ins", (stop_krnl_orders1_ins115 - start_krnl_orders1_ins115) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_customer3", (stop_krnl_customer3116 - start_krnl_customer3116) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation5", (stop_krnl_aggregation5117 - start_krnl_aggregation5117) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish118 - start_finish118) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime112 - start_totalKernelTime112) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
