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
    int att3_nnationk;
};
struct jpayl6 {
    int att7_ssuppkey;
};
struct jpayl13 {
    int att21_nnationk;
};
struct jpayl15 {
    int att25_ssuppkey;
};
struct apayl17 {
    int att32_pspartke;
};

__global__ void krnl_nation1(
    int* iatt3_nnationk, size_t* iatt4_nname_offset, char* iatt4_nname_char, unique_ht<jpayl4>* jht4) {
    int att3_nnationk;
    str_t att4_nname;
    str_t c1 = stringConstant ( "GERMANY", 7);

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
            att3_nnationk = iatt3_nnationk[tid_nation1];
            att4_nname = stringScan ( iatt4_nname_offset, iatt4_nname_char, tid_nation1);
        }
        // -------- selection (opId: 2) --------
        if(active) {
            active = stringEquals ( att4_nname, c1);
        }
        // -------- hash join build (opId: 4) --------
        if(active) {
            jpayl4 payl4;
            payl4.att3_nnationk = att3_nnationk;
            uint64_t hash4;
            hash4 = 0;
            if(active) {
                hash4 = hash ( (hash4 + ((uint64_t)att3_nnationk)));
            }
            hashBuildUnique ( jht4, 50, hash4, &(payl4));
        }
        loopVar += step;
    }

}

__global__ void krnl_supplier3(
    int* iatt7_ssuppkey, int* iatt10_snationk, unique_ht<jpayl4>* jht4, unique_ht<jpayl6>* jht6) {
    int att7_ssuppkey;
    int att10_snationk;
    int att3_nnationk;

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
            att7_ssuppkey = iatt7_ssuppkey[tid_supplier1];
            att10_snationk = iatt10_snationk[tid_supplier1];
        }
        // -------- hash join probe (opId: 4) --------
        uint64_t hash4 = 0;
        if(active) {
            hash4 = 0;
            if(active) {
                hash4 = hash ( (hash4 + ((uint64_t)att10_snationk)));
            }
        }
        jpayl4* probepayl4;
        int numLookups4 = 0;
        if(active) {
            active = hashProbeUnique ( jht4, 50, hash4, numLookups4, &(probepayl4));
        }
        int bucketFound4 = 0;
        int probeActive4 = active;
        while((probeActive4 && !(bucketFound4))) {
            jpayl4 jprobepayl4 = *(probepayl4);
            att3_nnationk = jprobepayl4.att3_nnationk;
            bucketFound4 = 1;
            bucketFound4 &= ((att3_nnationk == att10_snationk));
            if(!(bucketFound4)) {
                probeActive4 = hashProbeUnique ( jht4, 50, hash4, numLookups4, &(probepayl4));
            }
        }
        active = bucketFound4;
        // -------- hash join build (opId: 6) --------
        if(active) {
            jpayl6 payl6;
            payl6.att7_ssuppkey = att7_ssuppkey;
            uint64_t hash6;
            hash6 = 0;
            if(active) {
                hash6 = hash ( (hash6 + ((uint64_t)att7_ssuppkey)));
            }
            hashBuildUnique ( jht6, 20000, hash6, &(payl6));
        }
        loopVar += step;
    }

}

__global__ void krnl_partsupp5(
    int* iatt15_pssuppke, int* iatt16_psavailq, float* iatt17_pssupply, unique_ht<jpayl6>* jht6, float* agg1) {
    int att15_pssuppke;
    int att16_psavailq;
    float att17_pssupply;
    int att7_ssuppkey;
    float att19_suppval;

    int tid_partsupp1 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_partsupp1 = loopVar;
        active = (loopVar < 800000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att15_pssuppke = iatt15_pssuppke[tid_partsupp1];
            att16_psavailq = iatt16_psavailq[tid_partsupp1];
            att17_pssupply = iatt17_pssupply[tid_partsupp1];
        }
        // -------- hash join probe (opId: 6) --------
        uint64_t hash6 = 0;
        if(active) {
            hash6 = 0;
            if(active) {
                hash6 = hash ( (hash6 + ((uint64_t)att15_pssuppke)));
            }
        }
        jpayl6* probepayl6;
        int numLookups6 = 0;
        if(active) {
            active = hashProbeUnique ( jht6, 20000, hash6, numLookups6, &(probepayl6));
        }
        int bucketFound6 = 0;
        int probeActive6 = active;
        while((probeActive6 && !(bucketFound6))) {
            jpayl6 jprobepayl6 = *(probepayl6);
            att7_ssuppkey = jprobepayl6.att7_ssuppkey;
            bucketFound6 = 1;
            bucketFound6 &= ((att7_ssuppkey == att15_pssuppke));
            if(!(bucketFound6)) {
                probeActive6 = hashProbeUnique ( jht6, 20000, hash6, numLookups6, &(probepayl6));
            }
        }
        active = bucketFound6;
        // -------- map (opId: 7) --------
        if(active) {
            att19_suppval = (att17_pssupply * att16_psavailq);
        }
        // -------- aggregation (opId: 8) --------
        int bucket = 0;
        if(active) {
            atomicAdd(&(agg1[bucket]), ((float)att19_suppval));
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation8(
    float* agg1, int* nout_inner18, float* itm_inner18_lim_suppval) {
    float att1_sumsuppv;
    float att20_limsuppv;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation8 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation8 = loopVar;
        active = (loopVar < 1);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 8) --------
        if(active) {
            att1_sumsuppv = agg1[tid_aggregation8];
        }
        // -------- map (opId: 9) --------
        if(active) {
            att20_limsuppv = (att1_sumsuppv * 0.0001f);
        }
        // -------- nested join: materialize inner  (opId: 18) --------
        int wp;
        int writeMask;
        int numProj;
        writeMask = __ballot_sync(ALL_LANES,active);
        numProj = __popc(writeMask);
        if((warplane == 0)) {
            wp = atomicAdd(nout_inner18, numProj);
        }
        wp = __shfl_sync(ALL_LANES,wp,0);
        wp = (wp + __popc((writeMask & prefixlanes)));
        if(active) {
            itm_inner18_lim_suppval[wp] = att20_limsuppv;
        }
        loopVar += step;
    }

}

__global__ void krnl_nation210(
    int* iatt21_nnationk, size_t* iatt22_nname_offset, char* iatt22_nname_char, unique_ht<jpayl13>* jht13) {
    int att21_nnationk;
    str_t att22_nname;
    str_t c2 = stringConstant ( "GERMANY", 7);

    int tid_nation2 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_nation2 = loopVar;
        active = (loopVar < 25);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att21_nnationk = iatt21_nnationk[tid_nation2];
            att22_nname = stringScan ( iatt22_nname_offset, iatt22_nname_char, tid_nation2);
        }
        // -------- selection (opId: 11) --------
        if(active) {
            active = stringEquals ( att22_nname, c2);
        }
        // -------- hash join build (opId: 13) --------
        if(active) {
            jpayl13 payl13;
            payl13.att21_nnationk = att21_nnationk;
            uint64_t hash13;
            hash13 = 0;
            if(active) {
                hash13 = hash ( (hash13 + ((uint64_t)att21_nnationk)));
            }
            hashBuildUnique ( jht13, 50, hash13, &(payl13));
        }
        loopVar += step;
    }

}

__global__ void krnl_supplier212(
    int* iatt25_ssuppkey, int* iatt28_snationk, unique_ht<jpayl13>* jht13, unique_ht<jpayl15>* jht15) {
    int att25_ssuppkey;
    int att28_snationk;
    int att21_nnationk;

    int tid_supplier2 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_supplier2 = loopVar;
        active = (loopVar < 10000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att25_ssuppkey = iatt25_ssuppkey[tid_supplier2];
            att28_snationk = iatt28_snationk[tid_supplier2];
        }
        // -------- hash join probe (opId: 13) --------
        uint64_t hash13 = 0;
        if(active) {
            hash13 = 0;
            if(active) {
                hash13 = hash ( (hash13 + ((uint64_t)att28_snationk)));
            }
        }
        jpayl13* probepayl13;
        int numLookups13 = 0;
        if(active) {
            active = hashProbeUnique ( jht13, 50, hash13, numLookups13, &(probepayl13));
        }
        int bucketFound13 = 0;
        int probeActive13 = active;
        while((probeActive13 && !(bucketFound13))) {
            jpayl13 jprobepayl13 = *(probepayl13);
            att21_nnationk = jprobepayl13.att21_nnationk;
            bucketFound13 = 1;
            bucketFound13 &= ((att21_nnationk == att28_snationk));
            if(!(bucketFound13)) {
                probeActive13 = hashProbeUnique ( jht13, 50, hash13, numLookups13, &(probepayl13));
            }
        }
        active = bucketFound13;
        // -------- hash join build (opId: 15) --------
        if(active) {
            jpayl15 payl15;
            payl15.att25_ssuppkey = att25_ssuppkey;
            uint64_t hash15;
            hash15 = 0;
            if(active) {
                hash15 = hash ( (hash15 + ((uint64_t)att25_ssuppkey)));
            }
            hashBuildUnique ( jht15, 20000, hash15, &(payl15));
        }
        loopVar += step;
    }

}

__global__ void krnl_partsupp214(
    int* iatt32_pspartke, int* iatt33_pssuppke, int* iatt34_psavailq, float* iatt35_pssupply, unique_ht<jpayl15>* jht15, agg_ht<apayl17>* aht17, float* agg2) {
    int att32_pspartke;
    int att33_pssuppke;
    int att34_psavailq;
    float att35_pssupply;
    int att25_ssuppkey;
    float att37_suppval2;

    int tid_partsupp2 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_partsupp2 = loopVar;
        active = (loopVar < 800000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att32_pspartke = iatt32_pspartke[tid_partsupp2];
            att33_pssuppke = iatt33_pssuppke[tid_partsupp2];
            att34_psavailq = iatt34_psavailq[tid_partsupp2];
            att35_pssupply = iatt35_pssupply[tid_partsupp2];
        }
        // -------- hash join probe (opId: 15) --------
        uint64_t hash15 = 0;
        if(active) {
            hash15 = 0;
            if(active) {
                hash15 = hash ( (hash15 + ((uint64_t)att33_pssuppke)));
            }
        }
        jpayl15* probepayl15;
        int numLookups15 = 0;
        if(active) {
            active = hashProbeUnique ( jht15, 20000, hash15, numLookups15, &(probepayl15));
        }
        int bucketFound15 = 0;
        int probeActive15 = active;
        while((probeActive15 && !(bucketFound15))) {
            jpayl15 jprobepayl15 = *(probepayl15);
            att25_ssuppkey = jprobepayl15.att25_ssuppkey;
            bucketFound15 = 1;
            bucketFound15 &= ((att25_ssuppkey == att33_pssuppke));
            if(!(bucketFound15)) {
                probeActive15 = hashProbeUnique ( jht15, 20000, hash15, numLookups15, &(probepayl15));
            }
        }
        active = bucketFound15;
        // -------- map (opId: 16) --------
        if(active) {
            att37_suppval2 = (att35_pssupply * att34_psavailq);
        }
        // -------- aggregation (opId: 17) --------
        int bucket = 0;
        if(active) {
            uint64_t hash17 = 0;
            hash17 = 0;
            if(active) {
                hash17 = hash ( (hash17 + ((uint64_t)att32_pspartke)));
            }
            apayl17 payl;
            payl.att32_pspartke = att32_pspartke;
            int bucketFound = 0;
            int numLookups = 0;
            while(!(bucketFound)) {
                bucket = hashAggregateGetBucket ( aht17, 1600000, hash17, numLookups, &(payl));
                apayl17 probepayl = aht17[bucket].payload;
                bucketFound = 1;
                bucketFound &= ((payl.att32_pspartke == probepayl.att32_pspartke));
            }
        }
        if(active) {
            atomicAdd(&(agg2[bucket]), ((float)att37_suppval2));
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation17(
    agg_ht<apayl17>* aht17, float* agg2, int* nout_inner18, float* itm_inner18_lim_suppval, int* nout_result, int* oatt32_pspartke, float* oatt2_sumsuppv) {
    int att32_pspartke;
    float att2_sumsuppv;
    float att20_limsuppv;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation17 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation17 = loopVar;
        active = (loopVar < 1600000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 17) --------
        if(active) {
            active &= ((aht17[tid_aggregation17].lock.lock == OnceLock::LOCK_DONE));
        }
        if(active) {
            apayl17 payl = aht17[tid_aggregation17].payload;
            att32_pspartke = payl.att32_pspartke;
        }
        if(active) {
            att2_sumsuppv = agg2[tid_aggregation17];
        }
        // -------- nested join: loop inner  (opId: 18) --------
        int outerActive18 = active;
        for ( int tid_inner180 = 0; (tid_inner180 < *(nout_inner18)); (tid_inner180++)) {
            active = outerActive18;
            if(active) {
                att20_limsuppv = itm_inner18_lim_suppval[tid_inner180];
            }
            if(active) {
                active = (att2_sumsuppv > att20_limsuppv);
            }
            // -------- projection (no code) (opId: 19) --------
            // -------- materialize (opId: 20) --------
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
                oatt32_pspartke[wp] = att32_pspartke;
                oatt2_sumsuppv[wp] = att2_sumsuppv;
            }
        }
        loopVar += step;
    }

}

int main() {
    int* iatt3_nnationk;
    iatt3_nnationk = ( int*) map_memory_file ( "mmdb/nation_n_nationkey" );
    size_t* iatt4_nname_offset;
    iatt4_nname_offset = ( size_t*) map_memory_file ( "mmdb/nation_n_name_offset" );
    char* iatt4_nname_char;
    iatt4_nname_char = ( char*) map_memory_file ( "mmdb/nation_n_name_char" );
    int* iatt7_ssuppkey;
    iatt7_ssuppkey = ( int*) map_memory_file ( "mmdb/supplier_s_suppkey" );
    int* iatt10_snationk;
    iatt10_snationk = ( int*) map_memory_file ( "mmdb/supplier_s_nationkey" );
    int* iatt15_pssuppke;
    iatt15_pssuppke = ( int*) map_memory_file ( "mmdb/partsupp_ps_suppkey" );
    int* iatt16_psavailq;
    iatt16_psavailq = ( int*) map_memory_file ( "mmdb/partsupp_ps_availqty" );
    float* iatt17_pssupply;
    iatt17_pssupply = ( float*) map_memory_file ( "mmdb/partsupp_ps_supplycost" );
    int* iatt21_nnationk;
    iatt21_nnationk = ( int*) map_memory_file ( "mmdb/nation_n_nationkey" );
    size_t* iatt22_nname_offset;
    iatt22_nname_offset = ( size_t*) map_memory_file ( "mmdb/nation_n_name_offset" );
    char* iatt22_nname_char;
    iatt22_nname_char = ( char*) map_memory_file ( "mmdb/nation_n_name_char" );
    int* iatt25_ssuppkey;
    iatt25_ssuppkey = ( int*) map_memory_file ( "mmdb/supplier_s_suppkey" );
    int* iatt28_snationk;
    iatt28_snationk = ( int*) map_memory_file ( "mmdb/supplier_s_nationkey" );
    int* iatt32_pspartke;
    iatt32_pspartke = ( int*) map_memory_file ( "mmdb/partsupp_ps_partkey" );
    int* iatt33_pssuppke;
    iatt33_pssuppke = ( int*) map_memory_file ( "mmdb/partsupp_ps_suppkey" );
    int* iatt34_psavailq;
    iatt34_psavailq = ( int*) map_memory_file ( "mmdb/partsupp_ps_availqty" );
    float* iatt35_pssupply;
    iatt35_pssupply = ( float*) map_memory_file ( "mmdb/partsupp_ps_supplycost" );

    int nout_inner18;
    int nout_result;
    std::vector < int > oatt32_pspartke(800000);
    std::vector < float > oatt2_sumsuppv(800000);

    // wake up gpu
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in wake up gpu! " << cudaGetErrorString( err ) << std::endl;
            ERROR("wake up gpu")
        }
    }

    int* d_iatt3_nnationk;
    cudaMalloc((void**) &d_iatt3_nnationk, 25* sizeof(int) );
    size_t* d_iatt4_nname_offset;
    cudaMalloc((void**) &d_iatt4_nname_offset, (25 + 1)* sizeof(size_t) );
    char* d_iatt4_nname_char;
    cudaMalloc((void**) &d_iatt4_nname_char, 186* sizeof(char) );
    int* d_iatt7_ssuppkey;
    cudaMalloc((void**) &d_iatt7_ssuppkey, 10000* sizeof(int) );
    int* d_iatt10_snationk;
    cudaMalloc((void**) &d_iatt10_snationk, 10000* sizeof(int) );
    int* d_iatt15_pssuppke;
    cudaMalloc((void**) &d_iatt15_pssuppke, 800000* sizeof(int) );
    int* d_iatt16_psavailq;
    cudaMalloc((void**) &d_iatt16_psavailq, 800000* sizeof(int) );
    float* d_iatt17_pssupply;
    cudaMalloc((void**) &d_iatt17_pssupply, 800000* sizeof(float) );
    int* d_nout_inner18;
    cudaMalloc((void**) &d_nout_inner18, 1* sizeof(int) );
    float* d_itm_inner18_lim_suppval;
    cudaMalloc((void**) &d_itm_inner18_lim_suppval, 1* sizeof(float) );
    int* d_iatt21_nnationk;
    d_iatt21_nnationk = d_iatt3_nnationk;
    size_t* d_iatt22_nname_offset;
    d_iatt22_nname_offset = d_iatt4_nname_offset;
    char* d_iatt22_nname_char;
    d_iatt22_nname_char = d_iatt4_nname_char;
    int* d_iatt25_ssuppkey;
    d_iatt25_ssuppkey = d_iatt7_ssuppkey;
    int* d_iatt28_snationk;
    d_iatt28_snationk = d_iatt10_snationk;
    int* d_iatt32_pspartke;
    cudaMalloc((void**) &d_iatt32_pspartke, 800000* sizeof(int) );
    int* d_iatt33_pssuppke;
    d_iatt33_pssuppke = d_iatt15_pssuppke;
    int* d_iatt34_psavailq;
    d_iatt34_psavailq = d_iatt16_psavailq;
    float* d_iatt35_pssupply;
    d_iatt35_pssupply = d_iatt17_pssupply;
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    int* d_oatt32_pspartke;
    cudaMalloc((void**) &d_oatt32_pspartke, 800000* sizeof(int) );
    float* d_oatt2_sumsuppv;
    cudaMalloc((void**) &d_oatt2_sumsuppv, 800000* sizeof(float) );
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

    unique_ht<jpayl4>* d_jht4;
    cudaMalloc((void**) &d_jht4, 50* sizeof(unique_ht<jpayl4>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht4, 50);
    }
    unique_ht<jpayl6>* d_jht6;
    cudaMalloc((void**) &d_jht6, 20000* sizeof(unique_ht<jpayl6>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht6, 20000);
    }
    float* d_agg1;
    cudaMalloc((void**) &d_agg1, 1* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg1, 0.0f, 1);
    }
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_nout_inner18, 0, 1);
    }
    unique_ht<jpayl13>* d_jht13;
    cudaMalloc((void**) &d_jht13, 50* sizeof(unique_ht<jpayl13>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht13, 50);
    }
    unique_ht<jpayl15>* d_jht15;
    cudaMalloc((void**) &d_jht15, 20000* sizeof(unique_ht<jpayl15>) );
    {
        int gridsize=920;
        int blocksize=128;
        initUniqueHT<<<gridsize, blocksize>>>(d_jht15, 20000);
    }
    agg_ht<apayl17>* d_aht17;
    cudaMalloc((void**) &d_aht17, 1600000* sizeof(agg_ht<apayl17>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_aht17, 1600000);
    }
    float* d_agg2;
    cudaMalloc((void**) &d_agg2, 1600000* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg2, 0.0f, 1600000);
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

    cudaMemcpy( d_iatt3_nnationk, iatt3_nnationk, 25 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt4_nname_offset, iatt4_nname_offset, (25 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt4_nname_char, iatt4_nname_char, 186 * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt7_ssuppkey, iatt7_ssuppkey, 10000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt10_snationk, iatt10_snationk, 10000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt15_pssuppke, iatt15_pssuppke, 800000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt16_psavailq, iatt16_psavailq, 800000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt17_pssupply, iatt17_pssupply, 800000 * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt32_pspartke, iatt32_pspartke, 800000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime95 = std::clock();
    std::clock_t start_krnl_nation196 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_nation1<<<gridsize, blocksize>>>(d_iatt3_nnationk, d_iatt4_nname_offset, d_iatt4_nname_char, d_jht4);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_nation196 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_nation1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_nation1")
        }
    }

    std::clock_t start_krnl_supplier397 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_supplier3<<<gridsize, blocksize>>>(d_iatt7_ssuppkey, d_iatt10_snationk, d_jht4, d_jht6);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_supplier397 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_supplier3! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_supplier3")
        }
    }

    std::clock_t start_krnl_partsupp598 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_partsupp5<<<gridsize, blocksize>>>(d_iatt15_pssuppke, d_iatt16_psavailq, d_iatt17_pssupply, d_jht6, d_agg1);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_partsupp598 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_partsupp5! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_partsupp5")
        }
    }

    std::clock_t start_krnl_aggregation899 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation8<<<gridsize, blocksize>>>(d_agg1, d_nout_inner18, d_itm_inner18_lim_suppval);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation899 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation8! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation8")
        }
    }

    std::clock_t start_krnl_nation210100 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_nation210<<<gridsize, blocksize>>>(d_iatt21_nnationk, d_iatt22_nname_offset, d_iatt22_nname_char, d_jht13);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_nation210100 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_nation210! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_nation210")
        }
    }

    std::clock_t start_krnl_supplier212101 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_supplier212<<<gridsize, blocksize>>>(d_iatt25_ssuppkey, d_iatt28_snationk, d_jht13, d_jht15);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_supplier212101 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_supplier212! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_supplier212")
        }
    }

    std::clock_t start_krnl_partsupp214102 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_partsupp214<<<gridsize, blocksize>>>(d_iatt32_pspartke, d_iatt33_pssuppke, d_iatt34_psavailq, d_iatt35_pssupply, d_jht15, d_aht17, d_agg2);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_partsupp214102 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_partsupp214! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_partsupp214")
        }
    }

    std::clock_t start_krnl_aggregation17103 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation17<<<gridsize, blocksize>>>(d_aht17, d_agg2, d_nout_inner18, d_itm_inner18_lim_suppval, d_nout_result, d_oatt32_pspartke, d_oatt2_sumsuppv);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation17103 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation17! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation17")
        }
    }

    std::clock_t stop_totalKernelTime95 = std::clock();
    cudaMemcpy( &nout_inner18, d_nout_inner18, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt32_pspartke.data(), d_oatt32_pspartke, 800000 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt2_sumsuppv.data(), d_oatt2_sumsuppv, 800000 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt3_nnationk);
    cudaFree( d_iatt4_nname_offset);
    cudaFree( d_iatt4_nname_char);
    cudaFree( d_jht4);
    cudaFree( d_iatt7_ssuppkey);
    cudaFree( d_iatt10_snationk);
    cudaFree( d_jht6);
    cudaFree( d_iatt15_pssuppke);
    cudaFree( d_iatt16_psavailq);
    cudaFree( d_iatt17_pssupply);
    cudaFree( d_agg1);
    cudaFree( d_nout_inner18);
    cudaFree( d_itm_inner18_lim_suppval);
    cudaFree( d_jht13);
    cudaFree( d_jht15);
    cudaFree( d_iatt32_pspartke);
    cudaFree( d_aht17);
    cudaFree( d_agg2);
    cudaFree( d_nout_result);
    cudaFree( d_oatt32_pspartke);
    cudaFree( d_oatt2_sumsuppv);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda free! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda free")
        }
    }

    std::clock_t start_finish104 = std::clock();
    printf("\nResult: %i tuples\n", nout_result);
    if((nout_result > 800000)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("ps_partkey: ");
        printf("%8i", oatt32_pspartke[pv]);
        printf("  ");
        printf("sum_suppval2: ");
        printf("%15.2f", oatt2_sumsuppv[pv]);
        printf("  ");
        printf("\n");
    }
    if((nout_result > 10)) {
        printf("[...]\n");
    }
    printf("\n");
    std::clock_t stop_finish104 = std::clock();

    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "krnl_nation1", (stop_krnl_nation196 - start_krnl_nation196) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_supplier3", (stop_krnl_supplier397 - start_krnl_supplier397) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_partsupp5", (stop_krnl_partsupp598 - start_krnl_partsupp598) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation8", (stop_krnl_aggregation899 - start_krnl_aggregation899) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_nation210", (stop_krnl_nation210100 - start_krnl_nation210100) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_supplier212", (stop_krnl_supplier212101 - start_krnl_supplier212101) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_partsupp214", (stop_krnl_partsupp214102 - start_krnl_partsupp214102) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation17", (stop_krnl_aggregation17103 - start_krnl_aggregation17103) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish104 - start_finish104) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime95 - start_totalKernelTime95) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
