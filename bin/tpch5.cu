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
struct jpayl13 {
    int att2_ssuppkey;
    int att5_snationk;
};
struct jpayl5 {
    int att9_rregionk;
};
struct jpayl7 {
    int att12_nnationk;
    str_t att13_nname;
};
struct jpayl10 {
    int att12_nnationk;
    str_t att13_nname;
    int att16_ccustkey;
};
struct jpayl12 {
    int att12_nnationk;
    str_t att13_nname;
    int att24_oorderke;
};
struct apayl15 {
    str_t att13_nname;
};

__global__ void krnl_supplier1(
    int* iatt2_ssuppkey, int* iatt5_snationk, unique_ht<jpayl13>* jht13) {
    int att2_ssuppkey;
    int att5_snationk;

    int tid_supplier1 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_supplier1 = loopVar;
        active = (loopVar < 10000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att2_ssuppkey = iatt2_ssuppkey[tid_supplier1];
            att5_snationk = iatt5_snationk[tid_supplier1];
        }
        // -------- hash join build (opId: 13) --------
        if(active) {
            jpayl13 payl13;
            payl13.att2_ssuppkey = att2_ssuppkey;
            payl13.att5_snationk = att5_snationk;
            uint64_t hash13;
            hash13 = 0;
            if(active) {
                hash13 = hash ( (hash13 + ((uint64_t)att2_ssuppkey)));
            }
            if(active) {
                hash13 = hash ( (hash13 + ((uint64_t)att5_snationk)));
            }
            hashBuildUnique ( jht13, 20000, hash13, &(payl13));
        }
        loopVar += step;
    }

}

__global__ void krnl_region2(
    int* iatt9_rregionk, size_t* iatt10_rname_offset, char* iatt10_rname_char, unique_ht<jpayl5>* jht5) {
    int att9_rregionk;
    str_t att10_rname;
    str_t c1 = stringConstant ( "ASIA", 4);

    int tid_region1 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_region1 = loopVar;
        active = (loopVar < 5);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att9_rregionk = iatt9_rregionk[tid_region1];
            att10_rname = stringScan ( iatt10_rname_offset, iatt10_rname_char, tid_region1);
        }
        // -------- selection (opId: 3) --------
        if(active) {
            active = stringEquals ( att10_rname, c1);
        }
        // -------- hash join build (opId: 5) --------
        if(active) {
            jpayl5 payl5;
            payl5.att9_rregionk = att9_rregionk;
            uint64_t hash5;
            hash5 = 0;
            if(active) {
                hash5 = hash ( (hash5 + ((uint64_t)att9_rregionk)));
            }
            hashBuildUnique ( jht5, 10, hash5, &(payl5));
        }
        loopVar += step;
    }

}

__global__ void krnl_nation4(
    int* iatt12_nnationk, size_t* iatt13_nname_offset, char* iatt13_nname_char, int* iatt14_nregionk, unique_ht<jpayl5>* jht5, unique_ht<jpayl7>* jht7) {
    int att12_nnationk;
    str_t att13_nname;
    int att14_nregionk;
    int att9_rregionk;

    int tid_nation1 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_nation1 = loopVar;
        active = (loopVar < 25);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att12_nnationk = iatt12_nnationk[tid_nation1];
            att13_nname = stringScan ( iatt13_nname_offset, iatt13_nname_char, tid_nation1);
            att14_nregionk = iatt14_nregionk[tid_nation1];
        }
        // -------- hash join probe (opId: 5) --------
        uint64_t hash5 = 0;
        if(active) {
            hash5 = 0;
            if(active) {
                hash5 = hash ( (hash5 + ((uint64_t)att14_nregionk)));
            }
        }
        jpayl5* probepayl5;
        int numLookups5 = 0;
        if(active) {
            active = hashProbeUnique ( jht5, 10, hash5, numLookups5, &(probepayl5));
        }
        int bucketFound5 = 0;
        int probeActive5 = active;
        while((probeActive5 && !(bucketFound5))) {
            jpayl5 jprobepayl5 = *(probepayl5);
            att9_rregionk = jprobepayl5.att9_rregionk;
            bucketFound5 = 1;
            bucketFound5 &= ((att9_rregionk == att14_nregionk));
            if(!(bucketFound5)) {
                probeActive5 = hashProbeUnique ( jht5, 10, hash5, numLookups5, &(probepayl5));
            }
        }
        active = bucketFound5;
        // -------- hash join build (opId: 7) --------
        if(active) {
            jpayl7 payl7;
            payl7.att12_nnationk = att12_nnationk;
            payl7.att13_nname = att13_nname;
            uint64_t hash7;
            hash7 = 0;
            if(active) {
                hash7 = hash ( (hash7 + ((uint64_t)att12_nnationk)));
            }
            hashBuildUnique ( jht7, 10, hash7, &(payl7));
        }
        loopVar += step;
    }

}

__global__ void krnl_customer6(
    int* iatt16_ccustkey, int* iatt19_cnationk, unique_ht<jpayl7>* jht7, unique_ht<jpayl10>* jht10) {
    int att16_ccustkey;
    int att19_cnationk;
    int att12_nnationk;
    str_t att13_nname;

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
            att16_ccustkey = iatt16_ccustkey[tid_customer1];
            att19_cnationk = iatt19_cnationk[tid_customer1];
        }
        // -------- hash join probe (opId: 7) --------
        uint64_t hash7 = 0;
        if(active) {
            hash7 = 0;
            if(active) {
                hash7 = hash ( (hash7 + ((uint64_t)att19_cnationk)));
            }
        }
        jpayl7* probepayl7;
        int numLookups7 = 0;
        if(active) {
            active = hashProbeUnique ( jht7, 10, hash7, numLookups7, &(probepayl7));
        }
        int bucketFound7 = 0;
        int probeActive7 = active;
        while((probeActive7 && !(bucketFound7))) {
            jpayl7 jprobepayl7 = *(probepayl7);
            att12_nnationk = jprobepayl7.att12_nnationk;
            att13_nname = jprobepayl7.att13_nname;
            bucketFound7 = 1;
            bucketFound7 &= ((att12_nnationk == att19_cnationk));
            if(!(bucketFound7)) {
                probeActive7 = hashProbeUnique ( jht7, 10, hash7, numLookups7, &(probepayl7));
            }
        }
        active = bucketFound7;
        // -------- hash join build (opId: 10) --------
        if(active) {
            jpayl10 payl10;
            payl10.att12_nnationk = att12_nnationk;
            payl10.att13_nname = att13_nname;
            payl10.att16_ccustkey = att16_ccustkey;
            uint64_t hash10;
            hash10 = 0;
            if(active) {
                hash10 = hash ( (hash10 + ((uint64_t)att16_ccustkey)));
            }
            hashBuildUnique ( jht10, 60000, hash10, &(payl10));
        }
        loopVar += step;
    }

}

__global__ void krnl_orders8(
    int* iatt24_oorderke, int* iatt25_ocustkey, unsigned* iatt28_oorderda, unique_ht<jpayl10>* jht10, unique_ht<jpayl12>* jht12) {
    int att24_oorderke;
    int att25_ocustkey;
    unsigned att28_oorderda;
    int att12_nnationk;
    str_t att13_nname;
    int att16_ccustkey;

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
            att24_oorderke = iatt24_oorderke[tid_orders1];
            att25_ocustkey = iatt25_ocustkey[tid_orders1];
            att28_oorderda = iatt28_oorderda[tid_orders1];
        }
        // -------- selection (opId: 9) --------
        if(active) {
            active = ((att28_oorderda >= 19940101) && (att28_oorderda < 19950101));
        }
        // -------- hash join probe (opId: 10) --------
        uint64_t hash10 = 0;
        if(active) {
            hash10 = 0;
            if(active) {
                hash10 = hash ( (hash10 + ((uint64_t)att25_ocustkey)));
            }
        }
        jpayl10* probepayl10;
        int numLookups10 = 0;
        if(active) {
            active = hashProbeUnique ( jht10, 60000, hash10, numLookups10, &(probepayl10));
        }
        int bucketFound10 = 0;
        int probeActive10 = active;
        while((probeActive10 && !(bucketFound10))) {
            jpayl10 jprobepayl10 = *(probepayl10);
            att12_nnationk = jprobepayl10.att12_nnationk;
            att13_nname = jprobepayl10.att13_nname;
            att16_ccustkey = jprobepayl10.att16_ccustkey;
            bucketFound10 = 1;
            bucketFound10 &= ((att16_ccustkey == att25_ocustkey));
            if(!(bucketFound10)) {
                probeActive10 = hashProbeUnique ( jht10, 60000, hash10, numLookups10, &(probepayl10));
            }
        }
        active = bucketFound10;
        // -------- hash join build (opId: 12) --------
        if(active) {
            jpayl12 payl12;
            payl12.att12_nnationk = att12_nnationk;
            payl12.att13_nname = att13_nname;
            payl12.att24_oorderke = att24_oorderke;
            uint64_t hash12;
            hash12 = 0;
            if(active) {
                hash12 = hash ( (hash12 + ((uint64_t)att24_oorderke)));
            }
            hashBuildUnique ( jht12, 84000, hash12, &(payl12));
        }
        loopVar += step;
    }

}

__global__ void krnl_lineitem11(
    int* iatt33_lorderke, int* iatt35_lsuppkey, float* iatt38_lextende, float* iatt39_ldiscoun, unique_ht<jpayl12>* jht12, unique_ht<jpayl13>* jht13, agg_ht<apayl15>* aht15, float* agg1) {
    int att33_lorderke;
    int att35_lsuppkey;
    float att38_lextende;
    float att39_ldiscoun;
    int att12_nnationk;
    str_t att13_nname;
    int att24_oorderke;
    int att2_ssuppkey;
    int att5_snationk;
    float att49_revenue;

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
            att33_lorderke = iatt33_lorderke[tid_lineitem1];
            att35_lsuppkey = iatt35_lsuppkey[tid_lineitem1];
            att38_lextende = iatt38_lextende[tid_lineitem1];
            att39_ldiscoun = iatt39_ldiscoun[tid_lineitem1];
        }
        // -------- hash join probe (opId: 12) --------
        uint64_t hash12 = 0;
        if(active) {
            hash12 = 0;
            if(active) {
                hash12 = hash ( (hash12 + ((uint64_t)att33_lorderke)));
            }
        }
        jpayl12* probepayl12;
        int numLookups12 = 0;
        if(active) {
            active = hashProbeUnique ( jht12, 84000, hash12, numLookups12, &(probepayl12));
        }
        int bucketFound12 = 0;
        int probeActive12 = active;
        while((probeActive12 && !(bucketFound12))) {
            jpayl12 jprobepayl12 = *(probepayl12);
            att12_nnationk = jprobepayl12.att12_nnationk;
            att13_nname = jprobepayl12.att13_nname;
            att24_oorderke = jprobepayl12.att24_oorderke;
            bucketFound12 = 1;
            bucketFound12 &= ((att24_oorderke == att33_lorderke));
            if(!(bucketFound12)) {
                probeActive12 = hashProbeUnique ( jht12, 84000, hash12, numLookups12, &(probepayl12));
            }
        }
        active = bucketFound12;
        // -------- hash join probe (opId: 13) --------
        uint64_t hash13 = 0;
        if(active) {
            hash13 = 0;
            if(active) {
                hash13 = hash ( (hash13 + ((uint64_t)att35_lsuppkey)));
            }
            if(active) {
                hash13 = hash ( (hash13 + ((uint64_t)att12_nnationk)));
            }
        }
        jpayl13* probepayl13;
        int numLookups13 = 0;
        if(active) {
            active = hashProbeUnique ( jht13, 20000, hash13, numLookups13, &(probepayl13));
        }
        int bucketFound13 = 0;
        int probeActive13 = active;
        while((probeActive13 && !(bucketFound13))) {
            jpayl13 jprobepayl13 = *(probepayl13);
            att2_ssuppkey = jprobepayl13.att2_ssuppkey;
            att5_snationk = jprobepayl13.att5_snationk;
            bucketFound13 = 1;
            bucketFound13 &= ((att2_ssuppkey == att35_lsuppkey));
            bucketFound13 &= ((att5_snationk == att12_nnationk));
            if(!(bucketFound13)) {
                probeActive13 = hashProbeUnique ( jht13, 20000, hash13, numLookups13, &(probepayl13));
            }
        }
        active = bucketFound13;
        // -------- map (opId: 14) --------
        if(active) {
            att49_revenue = (att38_lextende * ((float)1.0f - att39_ldiscoun));
        }
        // -------- aggregation (opId: 15) --------
        int bucket = 0;
        if(active) {
            uint64_t hash15 = 0;
            hash15 = 0;
            hash15 = hash ( (hash15 + stringHash ( att13_nname)));
            apayl15 payl;
            payl.att13_nname = att13_nname;
            int bucketFound = 0;
            int numLookups = 0;
            while(!(bucketFound)) {
                bucket = hashAggregateGetBucket ( aht15, 10802, hash15, numLookups, &(payl));
                apayl15 probepayl = aht15[bucket].payload;
                bucketFound = 1;
                bucketFound &= (stringEquals ( payl.att13_nname, probepayl.att13_nname));
            }
        }
        if(active) {
            atomicAdd(&(agg1[bucket]), ((float)att49_revenue));
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation15(
    agg_ht<apayl15>* aht15, float* agg1, int* nout_result, str_offs* oatt13_nname_offset, char* iatt13_nname_char, float* oatt1_sumrev) {
    str_t att13_nname;
    float att1_sumrev;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation15 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation15 = loopVar;
        active = (loopVar < 10802);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 15) --------
        if(active) {
            active &= ((aht15[tid_aggregation15].lock.lock == OnceLock::LOCK_DONE));
        }
        if(active) {
            apayl15 payl = aht15[tid_aggregation15].payload;
            att13_nname = payl.att13_nname;
        }
        if(active) {
            att1_sumrev = agg1[tid_aggregation15];
        }
        // -------- materialize (opId: 16) --------
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
            oatt13_nname_offset[wp] = toStringOffset ( iatt13_nname_char, att13_nname);
            oatt1_sumrev[wp] = att1_sumrev;
        }
        loopVar += step;
    }

}

int main() {
    int* iatt2_ssuppkey;
    iatt2_ssuppkey = ( int*) map_memory_file ( "mmdb/supplier_s_suppkey" );
    int* iatt5_snationk;
    iatt5_snationk = ( int*) map_memory_file ( "mmdb/supplier_s_nationkey" );
    int* iatt9_rregionk;
    iatt9_rregionk = ( int*) map_memory_file ( "mmdb/region_r_regionkey" );
    size_t* iatt10_rname_offset;
    iatt10_rname_offset = ( size_t*) map_memory_file ( "mmdb/region_r_name_offset" );
    char* iatt10_rname_char;
    iatt10_rname_char = ( char*) map_memory_file ( "mmdb/region_r_name_char" );
    int* iatt12_nnationk;
    iatt12_nnationk = ( int*) map_memory_file ( "mmdb/nation_n_nationkey" );
    size_t* iatt13_nname_offset;
    iatt13_nname_offset = ( size_t*) map_memory_file ( "mmdb/nation_n_name_offset" );
    char* iatt13_nname_char;
    iatt13_nname_char = ( char*) map_memory_file ( "mmdb/nation_n_name_char" );
    int* iatt14_nregionk;
    iatt14_nregionk = ( int*) map_memory_file ( "mmdb/nation_n_regionkey" );
    int* iatt16_ccustkey;
    iatt16_ccustkey = ( int*) map_memory_file ( "mmdb/customer_c_custkey" );
    int* iatt19_cnationk;
    iatt19_cnationk = ( int*) map_memory_file ( "mmdb/customer_c_nationkey" );
    int* iatt24_oorderke;
    iatt24_oorderke = ( int*) map_memory_file ( "mmdb/orders_o_orderkey" );
    int* iatt25_ocustkey;
    iatt25_ocustkey = ( int*) map_memory_file ( "mmdb/orders_o_custkey" );
    unsigned* iatt28_oorderda;
    iatt28_oorderda = ( unsigned*) map_memory_file ( "mmdb/orders_o_orderdate" );
    int* iatt33_lorderke;
    iatt33_lorderke = ( int*) map_memory_file ( "mmdb/lineitem_l_orderkey" );
    int* iatt35_lsuppkey;
    iatt35_lsuppkey = ( int*) map_memory_file ( "mmdb/lineitem_l_suppkey" );
    float* iatt38_lextende;
    iatt38_lextende = ( float*) map_memory_file ( "mmdb/lineitem_l_extendedprice" );
    float* iatt39_ldiscoun;
    iatt39_ldiscoun = ( float*) map_memory_file ( "mmdb/lineitem_l_discount" );

    int nout_result;
    std::vector < str_offs > oatt13_nname_offset(5401);
    std::vector < float > oatt1_sumrev(5401);

    // wake up gpu
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in wake up gpu! " << cudaGetErrorString( err ) << std::endl;
            ERROR("wake up gpu")
        }
    }

    int* d_iatt2_ssuppkey;
    cudaMalloc((void**) &d_iatt2_ssuppkey, 10000* sizeof(int) );
    int* d_iatt5_snationk;
    cudaMalloc((void**) &d_iatt5_snationk, 10000* sizeof(int) );
    int* d_iatt9_rregionk;
    cudaMalloc((void**) &d_iatt9_rregionk, 5* sizeof(int) );
    size_t* d_iatt10_rname_offset;
    cudaMalloc((void**) &d_iatt10_rname_offset, (5 + 1)* sizeof(size_t) );
    char* d_iatt10_rname_char;
    cudaMalloc((void**) &d_iatt10_rname_char, 43* sizeof(char) );
    int* d_iatt12_nnationk;
    cudaMalloc((void**) &d_iatt12_nnationk, 25* sizeof(int) );
    size_t* d_iatt13_nname_offset;
    cudaMalloc((void**) &d_iatt13_nname_offset, (25 + 1)* sizeof(size_t) );
    char* d_iatt13_nname_char;
    cudaMalloc((void**) &d_iatt13_nname_char, 186* sizeof(char) );
    int* d_iatt14_nregionk;
    cudaMalloc((void**) &d_iatt14_nregionk, 25* sizeof(int) );
    int* d_iatt16_ccustkey;
    cudaMalloc((void**) &d_iatt16_ccustkey, 150000* sizeof(int) );
    int* d_iatt19_cnationk;
    cudaMalloc((void**) &d_iatt19_cnationk, 150000* sizeof(int) );
    int* d_iatt24_oorderke;
    cudaMalloc((void**) &d_iatt24_oorderke, 1500000* sizeof(int) );
    int* d_iatt25_ocustkey;
    cudaMalloc((void**) &d_iatt25_ocustkey, 1500000* sizeof(int) );
    unsigned* d_iatt28_oorderda;
    cudaMalloc((void**) &d_iatt28_oorderda, 1500000* sizeof(unsigned) );
    int* d_iatt33_lorderke;
    cudaMalloc((void**) &d_iatt33_lorderke, 6001215* sizeof(int) );
    int* d_iatt35_lsuppkey;
    cudaMalloc((void**) &d_iatt35_lsuppkey, 6001215* sizeof(int) );
    float* d_iatt38_lextende;
    cudaMalloc((void**) &d_iatt38_lextende, 6001215* sizeof(float) );
    float* d_iatt39_ldiscoun;
    cudaMalloc((void**) &d_iatt39_ldiscoun, 6001215* sizeof(float) );
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    str_offs* d_oatt13_nname_offset;
    cudaMalloc((void**) &d_oatt13_nname_offset, 5401* sizeof(str_offs) );
    float* d_oatt1_sumrev;
    cudaMalloc((void**) &d_oatt1_sumrev, 5401* sizeof(float) );
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

    unique_ht<jpayl13>* d_jht13;
    cudaMalloc((void**) &d_jht13, 20000* sizeof(unique_ht<jpayl13>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht13, 20000);
    }
    unique_ht<jpayl5>* d_jht5;
    cudaMalloc((void**) &d_jht5, 10* sizeof(unique_ht<jpayl5>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht5, 10);
    }
    unique_ht<jpayl7>* d_jht7;
    cudaMalloc((void**) &d_jht7, 10* sizeof(unique_ht<jpayl7>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht7, 10);
    }
    unique_ht<jpayl10>* d_jht10;
    cudaMalloc((void**) &d_jht10, 60000* sizeof(unique_ht<jpayl10>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht10, 60000);
    }
    unique_ht<jpayl12>* d_jht12;
    cudaMalloc((void**) &d_jht12, 84000* sizeof(unique_ht<jpayl12>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht12, 84000);
    }
    agg_ht<apayl15>* d_aht15;
    cudaMalloc((void**) &d_aht15, 10802* sizeof(agg_ht<apayl15>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_aht15, 10802);
    }
    float* d_agg1;
    cudaMalloc((void**) &d_agg1, 10802* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg1, 0.0f, 10802);
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

    cudaMemcpy( d_iatt2_ssuppkey, iatt2_ssuppkey, 10000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt5_snationk, iatt5_snationk, 10000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt9_rregionk, iatt9_rregionk, 5 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt10_rname_offset, iatt10_rname_offset, (5 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt10_rname_char, iatt10_rname_char, 43 * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt12_nnationk, iatt12_nnationk, 25 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt13_nname_offset, iatt13_nname_offset, (25 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt13_nname_char, iatt13_nname_char, 186 * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt14_nregionk, iatt14_nregionk, 25 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt16_ccustkey, iatt16_ccustkey, 150000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt19_cnationk, iatt19_cnationk, 150000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt24_oorderke, iatt24_oorderke, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt25_ocustkey, iatt25_ocustkey, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt28_oorderda, iatt28_oorderda, 1500000 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt33_lorderke, iatt33_lorderke, 6001215 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt35_lsuppkey, iatt35_lsuppkey, 6001215 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt38_lextende, iatt38_lextende, 6001215 * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt39_ldiscoun, iatt39_ldiscoun, 6001215 * sizeof(float), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime34 = std::clock();
    std::clock_t start_krnl_supplier135 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_supplier1<<<gridsize, blocksize>>>(d_iatt2_ssuppkey, d_iatt5_snationk, d_jht13);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_supplier135 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_supplier1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_supplier1")
        }
    }

    std::clock_t start_krnl_region236 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_region2<<<gridsize, blocksize>>>(d_iatt9_rregionk, d_iatt10_rname_offset, d_iatt10_rname_char, d_jht5);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_region236 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_region2! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_region2")
        }
    }

    std::clock_t start_krnl_nation437 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_nation4<<<gridsize, blocksize>>>(d_iatt12_nnationk, d_iatt13_nname_offset, d_iatt13_nname_char, d_iatt14_nregionk, d_jht5, d_jht7);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_nation437 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_nation4! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_nation4")
        }
    }

    std::clock_t start_krnl_customer638 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_customer6<<<gridsize, blocksize>>>(d_iatt16_ccustkey, d_iatt19_cnationk, d_jht7, d_jht10);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_customer638 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_customer6! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_customer6")
        }
    }

    std::clock_t start_krnl_orders839 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_orders8<<<gridsize, blocksize>>>(d_iatt24_oorderke, d_iatt25_ocustkey, d_iatt28_oorderda, d_jht10, d_jht12);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_orders839 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_orders8! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_orders8")
        }
    }

    std::clock_t start_krnl_lineitem1140 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_lineitem11<<<gridsize, blocksize>>>(d_iatt33_lorderke, d_iatt35_lsuppkey, d_iatt38_lextende, d_iatt39_ldiscoun, d_jht12, d_jht13, d_aht15, d_agg1);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_lineitem1140 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_lineitem11! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_lineitem11")
        }
    }

    std::clock_t start_krnl_aggregation1541 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation15<<<gridsize, blocksize>>>(d_aht15, d_agg1, d_nout_result, d_oatt13_nname_offset, d_iatt13_nname_char, d_oatt1_sumrev);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation1541 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation15! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation15")
        }
    }

    std::clock_t stop_totalKernelTime34 = std::clock();
    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt13_nname_offset.data(), d_oatt13_nname_offset, 5401 * sizeof(str_offs), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt1_sumrev.data(), d_oatt1_sumrev, 5401 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt2_ssuppkey);
    cudaFree( d_iatt5_snationk);
    cudaFree( d_jht13);
    cudaFree( d_iatt9_rregionk);
    cudaFree( d_iatt10_rname_offset);
    cudaFree( d_iatt10_rname_char);
    cudaFree( d_jht5);
    cudaFree( d_iatt12_nnationk);
    cudaFree( d_iatt13_nname_offset);
    cudaFree( d_iatt13_nname_char);
    cudaFree( d_iatt14_nregionk);
    cudaFree( d_jht7);
    cudaFree( d_iatt16_ccustkey);
    cudaFree( d_iatt19_cnationk);
    cudaFree( d_jht10);
    cudaFree( d_iatt24_oorderke);
    cudaFree( d_iatt25_ocustkey);
    cudaFree( d_iatt28_oorderda);
    cudaFree( d_jht12);
    cudaFree( d_iatt33_lorderke);
    cudaFree( d_iatt35_lsuppkey);
    cudaFree( d_iatt38_lextende);
    cudaFree( d_iatt39_ldiscoun);
    cudaFree( d_aht15);
    cudaFree( d_agg1);
    cudaFree( d_nout_result);
    cudaFree( d_oatt13_nname_offset);
    cudaFree( d_oatt1_sumrev);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda free! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda free")
        }
    }

    std::clock_t start_finish42 = std::clock();
    printf("\nResult: %i tuples\n", nout_result);
    if((nout_result > 5401)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("n_name: ");
        stringPrint ( iatt13_nname_char, oatt13_nname_offset[pv]);
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
    std::clock_t stop_finish42 = std::clock();

    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "krnl_supplier1", (stop_krnl_supplier135 - start_krnl_supplier135) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_region2", (stop_krnl_region236 - start_krnl_region236) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_nation4", (stop_krnl_nation437 - start_krnl_nation437) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_customer6", (stop_krnl_customer638 - start_krnl_customer638) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_orders8", (stop_krnl_orders839 - start_krnl_orders839) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_lineitem11", (stop_krnl_lineitem1140 - start_krnl_lineitem1140) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation15", (stop_krnl_aggregation1541 - start_krnl_aggregation1541) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish42 - start_finish42) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime34 - start_totalKernelTime34) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
