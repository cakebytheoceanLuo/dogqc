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
    int att2_ccustkey;
};
struct jpayl8 {
    int att10_oorderke;
    unsigned att14_oorderda;
    int att17_oshippri;
};
struct apayl10 {
    int att19_lorderke;
    unsigned att14_oorderda;
    int att17_oshippri;
};

__global__ void krnl_customer1(
    int* iatt2_ccustkey, size_t* iatt8_cmktsegm_offset, char* iatt8_cmktsegm_char, unique_ht<jpayl5>* jht5) {
    int att2_ccustkey;
    str_t att8_cmktsegm;
    str_t c1 = stringConstant ( "BUILDING", 8);

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
            att2_ccustkey = iatt2_ccustkey[tid_customer1];
            att8_cmktsegm = stringScan ( iatt8_cmktsegm_offset, iatt8_cmktsegm_char, tid_customer1);
        }
        // -------- selection (opId: 2) --------
        if(active) {
            active = stringEquals ( att8_cmktsegm, c1);
        }
        // -------- hash join build (opId: 5) --------
        if(active) {
            jpayl5 payl5;
            payl5.att2_ccustkey = att2_ccustkey;
            uint64_t hash5;
            hash5 = 0;
            if(active) {
                hash5 = hash ( (hash5 + ((uint64_t)att2_ccustkey)));
            }
            hashBuildUnique ( jht5, 60000, hash5, &(payl5));
        }
        loopVar += step;
    }

}

__global__ void krnl_orders3(
    int* iatt10_oorderke, int* iatt11_ocustkey, unsigned* iatt14_oorderda, int* iatt17_oshippri, unique_ht<jpayl5>* jht5, unique_ht<jpayl8>* jht8) {
    int att10_oorderke;
    int att11_ocustkey;
    unsigned att14_oorderda;
    int att17_oshippri;
    int att2_ccustkey;

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
            att10_oorderke = iatt10_oorderke[tid_orders1];
            att11_ocustkey = iatt11_ocustkey[tid_orders1];
            att14_oorderda = iatt14_oorderda[tid_orders1];
            att17_oshippri = iatt17_oshippri[tid_orders1];
        }
        // -------- selection (opId: 4) --------
        if(active) {
            active = (att14_oorderda < 19950315);
        }
        // -------- hash join probe (opId: 5) --------
        uint64_t hash5 = 0;
        if(active) {
            hash5 = 0;
            if(active) {
                hash5 = hash ( (hash5 + ((uint64_t)att11_ocustkey)));
            }
        }
        jpayl5* probepayl5;
        int numLookups5 = 0;
        if(active) {
            active = hashProbeUnique ( jht5, 60000, hash5, numLookups5, &(probepayl5));
        }
        int bucketFound5 = 0;
        int probeActive5 = active;
        while((probeActive5 && !(bucketFound5))) {
            jpayl5 jprobepayl5 = *(probepayl5);
            att2_ccustkey = jprobepayl5.att2_ccustkey;
            bucketFound5 = 1;
            bucketFound5 &= ((att2_ccustkey == att11_ocustkey));
            if(!(bucketFound5)) {
                probeActive5 = hashProbeUnique ( jht5, 60000, hash5, numLookups5, &(probepayl5));
            }
        }
        active = bucketFound5;
        // -------- hash join build (opId: 8) --------
        if(active) {
            jpayl8 payl8;
            payl8.att10_oorderke = att10_oorderke;
            payl8.att14_oorderda = att14_oorderda;
            payl8.att17_oshippri = att17_oshippri;
            uint64_t hash8;
            hash8 = 0;
            if(active) {
                hash8 = hash ( (hash8 + ((uint64_t)att10_oorderke)));
            }
            hashBuildUnique ( jht8, 285000, hash8, &(payl8));
        }
        loopVar += step;
    }

}

__global__ void krnl_lineitem6(
    int* iatt19_lorderke, float* iatt24_lextende, float* iatt25_ldiscoun, unsigned* iatt29_lshipdat, unique_ht<jpayl8>* jht8, agg_ht<apayl10>* aht10, float* agg1) {
    int att19_lorderke;
    float att24_lextende;
    float att25_ldiscoun;
    unsigned att29_lshipdat;
    int att10_oorderke;
    unsigned att14_oorderda;
    int att17_oshippri;
    float att35_revenue;

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
            att19_lorderke = iatt19_lorderke[tid_lineitem1];
            att24_lextende = iatt24_lextende[tid_lineitem1];
            att25_ldiscoun = iatt25_ldiscoun[tid_lineitem1];
            att29_lshipdat = iatt29_lshipdat[tid_lineitem1];
        }
        // -------- selection (opId: 7) --------
        if(active) {
            active = (att29_lshipdat > 19950315);
        }
        // -------- hash join probe (opId: 8) --------
        uint64_t hash8 = 0;
        if(active) {
            hash8 = 0;
            if(active) {
                hash8 = hash ( (hash8 + ((uint64_t)att19_lorderke)));
            }
        }
        jpayl8* probepayl8;
        int numLookups8 = 0;
        if(active) {
            active = hashProbeUnique ( jht8, 285000, hash8, numLookups8, &(probepayl8));
        }
        int bucketFound8 = 0;
        int probeActive8 = active;
        while((probeActive8 && !(bucketFound8))) {
            jpayl8 jprobepayl8 = *(probepayl8);
            att10_oorderke = jprobepayl8.att10_oorderke;
            att14_oorderda = jprobepayl8.att14_oorderda;
            att17_oshippri = jprobepayl8.att17_oshippri;
            bucketFound8 = 1;
            bucketFound8 &= ((att10_oorderke == att19_lorderke));
            if(!(bucketFound8)) {
                probeActive8 = hashProbeUnique ( jht8, 285000, hash8, numLookups8, &(probepayl8));
            }
        }
        active = bucketFound8;
        // -------- map (opId: 9) --------
        if(active) {
            att35_revenue = (att24_lextende * ((float)1.0f - att25_ldiscoun));
        }
        // -------- aggregation (opId: 10) --------
        int bucket = 0;
        if(active) {
            uint64_t hash10 = 0;
            hash10 = 0;
            if(active) {
                hash10 = hash ( (hash10 + ((uint64_t)att19_lorderke)));
            }
            if(active) {
                hash10 = hash ( (hash10 + ((uint64_t)att14_oorderda)));
            }
            if(active) {
                hash10 = hash ( (hash10 + ((uint64_t)att17_oshippri)));
            }
            apayl10 payl;
            payl.att19_lorderke = att19_lorderke;
            payl.att14_oorderda = att14_oorderda;
            payl.att17_oshippri = att17_oshippri;
            int bucketFound = 0;
            int numLookups = 0;
            while(!(bucketFound)) {
                bucket = hashAggregateGetBucket ( aht10, 300060, hash10, numLookups, &(payl));
                apayl10 probepayl = aht10[bucket].payload;
                bucketFound = 1;
                bucketFound &= ((payl.att19_lorderke == probepayl.att19_lorderke));
                bucketFound &= ((payl.att14_oorderda == probepayl.att14_oorderda));
                bucketFound &= ((payl.att17_oshippri == probepayl.att17_oshippri));
            }
        }
        if(active) {
            atomicAdd(&(agg1[bucket]), ((float)att35_revenue));
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation10(
    agg_ht<apayl10>* aht10, float* agg1, int* nout_result, int* oatt19_lorderke, unsigned* oatt14_oorderda, int* oatt17_oshippri, float* oatt1_sumrev) {
    int att19_lorderke;
    unsigned att14_oorderda;
    int att17_oshippri;
    float att1_sumrev;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation10 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation10 = loopVar;
        active = (loopVar < 300060);
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
            att19_lorderke = payl.att19_lorderke;
            att14_oorderda = payl.att14_oorderda;
            att17_oshippri = payl.att17_oshippri;
        }
        if(active) {
            att1_sumrev = agg1[tid_aggregation10];
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
            oatt19_lorderke[wp] = att19_lorderke;
            oatt14_oorderda[wp] = att14_oorderda;
            oatt17_oshippri[wp] = att17_oshippri;
            oatt1_sumrev[wp] = att1_sumrev;
        }
        loopVar += step;
    }

}

int main() {
    int* iatt2_ccustkey;
    iatt2_ccustkey = ( int*) map_memory_file ( "mmdb/customer_c_custkey" );
    size_t* iatt8_cmktsegm_offset;
    iatt8_cmktsegm_offset = ( size_t*) map_memory_file ( "mmdb/customer_c_mktsegment_offset" );
    char* iatt8_cmktsegm_char;
    iatt8_cmktsegm_char = ( char*) map_memory_file ( "mmdb/customer_c_mktsegment_char" );
    int* iatt10_oorderke;
    iatt10_oorderke = ( int*) map_memory_file ( "mmdb/orders_o_orderkey" );
    int* iatt11_ocustkey;
    iatt11_ocustkey = ( int*) map_memory_file ( "mmdb/orders_o_custkey" );
    unsigned* iatt14_oorderda;
    iatt14_oorderda = ( unsigned*) map_memory_file ( "mmdb/orders_o_orderdate" );
    int* iatt17_oshippri;
    iatt17_oshippri = ( int*) map_memory_file ( "mmdb/orders_o_shippriority" );
    int* iatt19_lorderke;
    iatt19_lorderke = ( int*) map_memory_file ( "mmdb/lineitem_l_orderkey" );
    float* iatt24_lextende;
    iatt24_lextende = ( float*) map_memory_file ( "mmdb/lineitem_l_extendedprice" );
    float* iatt25_ldiscoun;
    iatt25_ldiscoun = ( float*) map_memory_file ( "mmdb/lineitem_l_discount" );
    unsigned* iatt29_lshipdat;
    iatt29_lshipdat = ( unsigned*) map_memory_file ( "mmdb/lineitem_l_shipdate" );

    int nout_result;
    std::vector < int > oatt19_lorderke(150030);
    std::vector < unsigned > oatt14_oorderda(150030);
    std::vector < int > oatt17_oshippri(150030);
    std::vector < float > oatt1_sumrev(150030);

    // wake up gpu
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in wake up gpu! " << cudaGetErrorString( err ) << std::endl;
            ERROR("wake up gpu")
        }
    }

    int* d_iatt2_ccustkey;
    cudaMalloc((void**) &d_iatt2_ccustkey, 150000* sizeof(int) );
    size_t* d_iatt8_cmktsegm_offset;
    cudaMalloc((void**) &d_iatt8_cmktsegm_offset, (150000 + 1)* sizeof(size_t) );
    char* d_iatt8_cmktsegm_char;
    cudaMalloc((void**) &d_iatt8_cmktsegm_char, 1349619* sizeof(char) );
    int* d_iatt10_oorderke;
    cudaMalloc((void**) &d_iatt10_oorderke, 1500000* sizeof(int) );
    int* d_iatt11_ocustkey;
    cudaMalloc((void**) &d_iatt11_ocustkey, 1500000* sizeof(int) );
    unsigned* d_iatt14_oorderda;
    cudaMalloc((void**) &d_iatt14_oorderda, 1500000* sizeof(unsigned) );
    int* d_iatt17_oshippri;
    cudaMalloc((void**) &d_iatt17_oshippri, 1500000* sizeof(int) );
    int* d_iatt19_lorderke;
    cudaMalloc((void**) &d_iatt19_lorderke, 6001215* sizeof(int) );
    float* d_iatt24_lextende;
    cudaMalloc((void**) &d_iatt24_lextende, 6001215* sizeof(float) );
    float* d_iatt25_ldiscoun;
    cudaMalloc((void**) &d_iatt25_ldiscoun, 6001215* sizeof(float) );
    unsigned* d_iatt29_lshipdat;
    cudaMalloc((void**) &d_iatt29_lshipdat, 6001215* sizeof(unsigned) );
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    int* d_oatt19_lorderke;
    cudaMalloc((void**) &d_oatt19_lorderke, 150030* sizeof(int) );
    unsigned* d_oatt14_oorderda;
    cudaMalloc((void**) &d_oatt14_oorderda, 150030* sizeof(unsigned) );
    int* d_oatt17_oshippri;
    cudaMalloc((void**) &d_oatt17_oshippri, 150030* sizeof(int) );
    float* d_oatt1_sumrev;
    cudaMalloc((void**) &d_oatt1_sumrev, 150030* sizeof(float) );
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

    unique_ht<jpayl5>* d_jht5;
    cudaMalloc((void**) &d_jht5, 60000* sizeof(unique_ht<jpayl5>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht5, 60000);
    }
    unique_ht<jpayl8>* d_jht8;
    cudaMalloc((void**) &d_jht8, 285000* sizeof(unique_ht<jpayl8>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht8, 285000);
    }
    agg_ht<apayl10>* d_aht10;
    cudaMalloc((void**) &d_aht10, 300060* sizeof(agg_ht<apayl10>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_aht10, 300060);
    }
    float* d_agg1;
    cudaMalloc((void**) &d_agg1, 300060* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg1, 0.0f, 300060);
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

    cudaMemcpy( d_iatt2_ccustkey, iatt2_ccustkey, 150000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt8_cmktsegm_offset, iatt8_cmktsegm_offset, (150000 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt8_cmktsegm_char, iatt8_cmktsegm_char, 1349619 * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt10_oorderke, iatt10_oorderke, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt11_ocustkey, iatt11_ocustkey, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt14_oorderda, iatt14_oorderda, 1500000 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt17_oshippri, iatt17_oshippri, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt19_lorderke, iatt19_lorderke, 6001215 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt24_lextende, iatt24_lextende, 6001215 * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt25_ldiscoun, iatt25_ldiscoun, 6001215 * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt29_lshipdat, iatt29_lshipdat, 6001215 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime23 = std::clock();
    std::clock_t start_krnl_customer124 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_customer1<<<gridsize, blocksize>>>(d_iatt2_ccustkey, d_iatt8_cmktsegm_offset, d_iatt8_cmktsegm_char, d_jht5);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_customer124 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_customer1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_customer1")
        }
    }

    std::clock_t start_krnl_orders325 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_orders3<<<gridsize, blocksize>>>(d_iatt10_oorderke, d_iatt11_ocustkey, d_iatt14_oorderda, d_iatt17_oshippri, d_jht5, d_jht8);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_orders325 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_orders3! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_orders3")
        }
    }

    std::clock_t start_krnl_lineitem626 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_lineitem6<<<gridsize, blocksize>>>(d_iatt19_lorderke, d_iatt24_lextende, d_iatt25_ldiscoun, d_iatt29_lshipdat, d_jht8, d_aht10, d_agg1);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_lineitem626 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_lineitem6! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_lineitem6")
        }
    }

    std::clock_t start_krnl_aggregation1027 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation10<<<gridsize, blocksize>>>(d_aht10, d_agg1, d_nout_result, d_oatt19_lorderke, d_oatt14_oorderda, d_oatt17_oshippri, d_oatt1_sumrev);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation1027 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation10! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation10")
        }
    }

    std::clock_t stop_totalKernelTime23 = std::clock();
    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt19_lorderke.data(), d_oatt19_lorderke, 150030 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt14_oorderda.data(), d_oatt14_oorderda, 150030 * sizeof(unsigned), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt17_oshippri.data(), d_oatt17_oshippri, 150030 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt1_sumrev.data(), d_oatt1_sumrev, 150030 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt2_ccustkey);
    cudaFree( d_iatt8_cmktsegm_offset);
    cudaFree( d_iatt8_cmktsegm_char);
    cudaFree( d_jht5);
    cudaFree( d_iatt10_oorderke);
    cudaFree( d_iatt11_ocustkey);
    cudaFree( d_iatt14_oorderda);
    cudaFree( d_iatt17_oshippri);
    cudaFree( d_jht8);
    cudaFree( d_iatt19_lorderke);
    cudaFree( d_iatt24_lextende);
    cudaFree( d_iatt25_ldiscoun);
    cudaFree( d_iatt29_lshipdat);
    cudaFree( d_aht10);
    cudaFree( d_agg1);
    cudaFree( d_nout_result);
    cudaFree( d_oatt19_lorderke);
    cudaFree( d_oatt14_oorderda);
    cudaFree( d_oatt17_oshippri);
    cudaFree( d_oatt1_sumrev);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda free! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda free")
        }
    }

    std::clock_t start_finish28 = std::clock();
    printf("\nResult: %i tuples\n", nout_result);
    if((nout_result > 150030)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("l_orderkey: ");
        printf("%8i", oatt19_lorderke[pv]);
        printf("  ");
        printf("o_orderdate: ");
        printf("%10i", oatt14_oorderda[pv]);
        printf("  ");
        printf("o_shippriority: ");
        printf("%8i", oatt17_oshippri[pv]);
        printf("  ");
        printf("sum_rev: ");
        printf("%15.2f", oatt1_sumrev[pv]);
        printf("  ");
        printf("\n");
    }
    if((nout_result > 10)) {
        printf("[...]\n");
    }
    printf("\n");
    std::clock_t stop_finish28 = std::clock();

    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "krnl_customer1", (stop_krnl_customer124 - start_krnl_customer124) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_orders3", (stop_krnl_orders325 - start_krnl_orders325) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_lineitem6", (stop_krnl_lineitem626 - start_krnl_lineitem626) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation10", (stop_krnl_aggregation1027 - start_krnl_aggregation1027) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish28 - start_finish28) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime23 - start_totalKernelTime23) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
