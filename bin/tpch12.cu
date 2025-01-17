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
    int att3_lorderke;
    str_t att17_lshipmod;
};
struct apayl7 {
    str_t att17_lshipmod;
};

__global__ void krnl_lineitem1(
    int* iatt3_lorderke, unsigned* iatt13_lshipdat, unsigned* iatt14_lcommitd, unsigned* iatt15_lreceipt, size_t* iatt17_lshipmod_offset, char* iatt17_lshipmod_char, multi_ht* jht4, jpayl4* jht4_payload) {
    int att3_lorderke;
    unsigned att13_lshipdat;
    unsigned att14_lcommitd;
    unsigned att15_lreceipt;
    str_t att17_lshipmod;
    str_t c1 = stringConstant ( "SHIP", 4);
    str_t c2 = stringConstant ( "MAIL", 4);

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
            att3_lorderke = iatt3_lorderke[tid_lineitem1];
            att13_lshipdat = iatt13_lshipdat[tid_lineitem1];
            att14_lcommitd = iatt14_lcommitd[tid_lineitem1];
            att15_lreceipt = iatt15_lreceipt[tid_lineitem1];
            att17_lshipmod = stringScan ( iatt17_lshipmod_offset, iatt17_lshipmod_char, tid_lineitem1);
        }
        // -------- selection (opId: 2) --------
        if(active) {
            active = ((stringEquals ( att17_lshipmod, c1) || stringEquals ( att17_lshipmod, c2)) && ((att14_lcommitd < att15_lreceipt) && ((att13_lshipdat < att14_lcommitd) && ((att15_lreceipt >= 19940101) && (att15_lreceipt < 19950101)))));
        }
        // -------- hash join build (opId: 4) --------
        if(active) {
            uint64_t hash4 = 0;
            if(active) {
                hash4 = 0;
                if(active) {
                    hash4 = hash ( (hash4 + ((uint64_t)att3_lorderke)));
                }
            }
            hashCountMulti ( jht4, 840170, hash4);
        }
        loopVar += step;
    }

}

__global__ void krnl_lineitem1_ins(
    int* iatt3_lorderke, unsigned* iatt13_lshipdat, unsigned* iatt14_lcommitd, unsigned* iatt15_lreceipt, size_t* iatt17_lshipmod_offset, char* iatt17_lshipmod_char, multi_ht* jht4, jpayl4* jht4_payload, int* offs4) {
    int att3_lorderke;
    unsigned att13_lshipdat;
    unsigned att14_lcommitd;
    unsigned att15_lreceipt;
    str_t att17_lshipmod;
    str_t c1 = stringConstant ( "SHIP", 4);
    str_t c2 = stringConstant ( "MAIL", 4);

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
            att3_lorderke = iatt3_lorderke[tid_lineitem1];
            att13_lshipdat = iatt13_lshipdat[tid_lineitem1];
            att14_lcommitd = iatt14_lcommitd[tid_lineitem1];
            att15_lreceipt = iatt15_lreceipt[tid_lineitem1];
            att17_lshipmod = stringScan ( iatt17_lshipmod_offset, iatt17_lshipmod_char, tid_lineitem1);
        }
        // -------- selection (opId: 2) --------
        if(active) {
            active = ((stringEquals ( att17_lshipmod, c1) || stringEquals ( att17_lshipmod, c2)) && ((att14_lcommitd < att15_lreceipt) && ((att13_lshipdat < att14_lcommitd) && ((att15_lreceipt >= 19940101) && (att15_lreceipt < 19950101)))));
        }
        // -------- hash join build (opId: 4) --------
        if(active) {
            uint64_t hash4 = 0;
            if(active) {
                hash4 = 0;
                if(active) {
                    hash4 = hash ( (hash4 + ((uint64_t)att3_lorderke)));
                }
            }
            jpayl4 payl;
            payl.att3_lorderke = att3_lorderke;
            payl.att17_lshipmod = att17_lshipmod;
            hashInsertMulti ( jht4, jht4_payload, offs4, 840170, hash4, &(payl));
        }
        loopVar += step;
    }

}

__global__ void krnl_orders3(
    int* iatt19_oorderke, size_t* iatt24_oorderpr_offset, char* iatt24_oorderpr_char, multi_ht* jht4, jpayl4* jht4_payload, agg_ht<apayl7>* aht7, float* agg1, float* agg2) {
    int att19_oorderke;
    str_t att24_oorderpr;
    unsigned warplane = (threadIdx.x % 32);
    int att3_lorderke;
    str_t att17_lshipmod;
    float att28_lowline;
    str_t c3 = stringConstant ( "1-URGENT", 8);
    str_t c4 = stringConstant ( "2-HIGH", 6);
    float att29_highline;
    str_t c5 = stringConstant ( "1-URGENT", 8);
    str_t c6 = stringConstant ( "2-HIGH", 6);

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
            att19_oorderke = iatt19_oorderke[tid_orders1];
            att24_oorderpr = stringScan ( iatt24_oorderpr_offset, iatt24_oorderpr_char, tid_orders1);
        }
        // -------- hash join probe (opId: 4) --------
        // -------- multiprobe multi broadcast (opId: 4) --------
        int matchEnd4 = 0;
        int matchEndBuf4 = 0;
        int matchOffset4 = 0;
        int matchOffsetBuf4 = 0;
        int probeActive4 = active;
        int att19_oorderke_bcbuf4;
        str_t att24_oorderpr_bcbuf4;
        uint64_t hash4 = 0;
        if(probeActive4) {
            hash4 = 0;
            if(active) {
                hash4 = hash ( (hash4 + ((uint64_t)att19_oorderke)));
            }
            probeActive4 = hashProbeMulti ( jht4, 840170, hash4, matchOffsetBuf4, matchEndBuf4);
        }
        unsigned activeProbes4 = __ballot_sync(ALL_LANES,probeActive4);
        int num4 = 0;
        num4 = (matchEndBuf4 - matchOffsetBuf4);
        unsigned wideProbes4 = __ballot_sync(ALL_LANES,(num4 >= 32));
        att19_oorderke_bcbuf4 = att19_oorderke;
        att24_oorderpr_bcbuf4 = att24_oorderpr;
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
            att19_oorderke = __shfl_sync(ALL_LANES,att19_oorderke_bcbuf4,broadcastLane);
            att24_oorderpr = __shfl_sync(ALL_LANES,att24_oorderpr_bcbuf4,broadcastLane);
            probeActive4 = (matchOffset4 < matchEnd4);
            while(__any_sync(ALL_LANES,probeActive4)) {
                active = probeActive4;
                active = 0;
                jpayl4 payl;
                if(probeActive4) {
                    payl = jht4_payload[matchOffset4];
                    att3_lorderke = payl.att3_lorderke;
                    att17_lshipmod = payl.att17_lshipmod;
                    active = 1;
                    active &= ((att3_lorderke == att19_oorderke));
                    matchOffset4 += 32;
                    probeActive4 &= ((matchOffset4 < matchEnd4));
                }
                // -------- map (opId: 5) --------
                if(active) {
                    float casevar1227;
                    if((!(stringEquals ( att24_oorderpr, c3)) && !(stringEquals ( att24_oorderpr, c4)))) {
                        casevar1227 = 1;
                    }
                    else {
                        casevar1227 = 0;
                    }
                    att28_lowline = casevar1227;
                }
                // -------- map (opId: 6) --------
                if(active) {
                    float casevar1215;
                    if((stringEquals ( att24_oorderpr, c5) || stringEquals ( att24_oorderpr, c6))) {
                        casevar1215 = 1;
                    }
                    else {
                        casevar1215 = 0;
                    }
                    att29_highline = casevar1215;
                }
                // -------- aggregation (opId: 7) --------
                int bucket = 0;
                if(active) {
                    uint64_t hash7 = 0;
                    hash7 = 0;
                    hash7 = hash ( (hash7 + stringHash ( att17_lshipmod)));
                    apayl7 payl;
                    payl.att17_lshipmod = att17_lshipmod;
                    int bucketFound = 0;
                    int numLookups = 0;
                    while(!(bucketFound)) {
                        bucket = hashAggregateGetBucket ( aht7, 14, hash7, numLookups, &(payl));
                        apayl7 probepayl = aht7[bucket].payload;
                        bucketFound = 1;
                        bucketFound &= (stringEquals ( payl.att17_lshipmod, probepayl.att17_lshipmod));
                    }
                }
                if(active) {
                    atomicAdd(&(agg1[bucket]), ((float)att29_highline));
                    atomicAdd(&(agg2[bucket]), ((float)att28_lowline));
                }
            }
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation7(
    agg_ht<apayl7>* aht7, float* agg1, float* agg2, int* nout_result, str_offs* oatt17_lshipmod_offset, char* iatt17_lshipmod_char, float* oatt1_highline, float* oatt2_lowlinec) {
    str_t att17_lshipmod;
    float att1_highline;
    float att2_lowlinec;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation7 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation7 = loopVar;
        active = (loopVar < 14);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 7) --------
        if(active) {
            active &= ((aht7[tid_aggregation7].lock.lock == OnceLock::LOCK_DONE));
        }
        if(active) {
            apayl7 payl = aht7[tid_aggregation7].payload;
            att17_lshipmod = payl.att17_lshipmod;
        }
        if(active) {
            att1_highline = agg1[tid_aggregation7];
            att2_lowlinec = agg2[tid_aggregation7];
        }
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
            oatt17_lshipmod_offset[wp] = toStringOffset ( iatt17_lshipmod_char, att17_lshipmod);
            oatt1_highline[wp] = att1_highline;
            oatt2_lowlinec[wp] = att2_lowlinec;
        }
        loopVar += step;
    }

}

int main() {
    int* iatt3_lorderke;
    iatt3_lorderke = ( int*) map_memory_file ( "mmdb/lineitem_l_orderkey" );
    unsigned* iatt13_lshipdat;
    iatt13_lshipdat = ( unsigned*) map_memory_file ( "mmdb/lineitem_l_shipdate" );
    unsigned* iatt14_lcommitd;
    iatt14_lcommitd = ( unsigned*) map_memory_file ( "mmdb/lineitem_l_commitdate" );
    unsigned* iatt15_lreceipt;
    iatt15_lreceipt = ( unsigned*) map_memory_file ( "mmdb/lineitem_l_receiptdate" );
    size_t* iatt17_lshipmod_offset;
    iatt17_lshipmod_offset = ( size_t*) map_memory_file ( "mmdb/lineitem_l_shipmode_offset" );
    char* iatt17_lshipmod_char;
    iatt17_lshipmod_char = ( char*) map_memory_file ( "mmdb/lineitem_l_shipmode_char" );
    int* iatt19_oorderke;
    iatt19_oorderke = ( int*) map_memory_file ( "mmdb/orders_o_orderkey" );
    size_t* iatt24_oorderpr_offset;
    iatt24_oorderpr_offset = ( size_t*) map_memory_file ( "mmdb/orders_o_orderpriority_offset" );
    char* iatt24_oorderpr_char;
    iatt24_oorderpr_char = ( char*) map_memory_file ( "mmdb/orders_o_orderpriority_char" );

    int nout_result;
    std::vector < str_offs > oatt17_lshipmod_offset(7);
    std::vector < float > oatt1_highline(7);
    std::vector < float > oatt2_lowlinec(7);

    // wake up gpu
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in wake up gpu! " << cudaGetErrorString( err ) << std::endl;
            ERROR("wake up gpu")
        }
    }

    int* d_iatt3_lorderke;
    cudaMalloc((void**) &d_iatt3_lorderke, 6001215* sizeof(int) );
    unsigned* d_iatt13_lshipdat;
    cudaMalloc((void**) &d_iatt13_lshipdat, 6001215* sizeof(unsigned) );
    unsigned* d_iatt14_lcommitd;
    cudaMalloc((void**) &d_iatt14_lcommitd, 6001215* sizeof(unsigned) );
    unsigned* d_iatt15_lreceipt;
    cudaMalloc((void**) &d_iatt15_lreceipt, 6001215* sizeof(unsigned) );
    size_t* d_iatt17_lshipmod_offset;
    cudaMalloc((void**) &d_iatt17_lshipmod_offset, (6001215 + 1)* sizeof(size_t) );
    char* d_iatt17_lshipmod_char;
    cudaMalloc((void**) &d_iatt17_lshipmod_char, 25717043* sizeof(char) );
    int* d_iatt19_oorderke;
    cudaMalloc((void**) &d_iatt19_oorderke, 1500000* sizeof(int) );
    size_t* d_iatt24_oorderpr_offset;
    cudaMalloc((void**) &d_iatt24_oorderpr_offset, (1500000 + 1)* sizeof(size_t) );
    char* d_iatt24_oorderpr_char;
    cudaMalloc((void**) &d_iatt24_oorderpr_char, 12599838* sizeof(char) );
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    str_offs* d_oatt17_lshipmod_offset;
    cudaMalloc((void**) &d_oatt17_lshipmod_offset, 7* sizeof(str_offs) );
    float* d_oatt1_highline;
    cudaMalloc((void**) &d_oatt1_highline, 7* sizeof(float) );
    float* d_oatt2_lowlinec;
    cudaMalloc((void**) &d_oatt2_lowlinec, 7* sizeof(float) );
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
    cudaMalloc((void**) &d_jht4, 840170* sizeof(multi_ht) );
    jpayl4* d_jht4_payload;
    cudaMalloc((void**) &d_jht4_payload, 840170* sizeof(jpayl4) );
    {
        int gridsize=920;
        int blocksize=128;
        initMultiHT<<<gridsize, blocksize>>>(d_jht4, 840170);
    }
    int* d_offs4;
    cudaMalloc((void**) &d_offs4, 1* sizeof(int) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_offs4, 0, 1);
    }
    agg_ht<apayl7>* d_aht7;
    cudaMalloc((void**) &d_aht7, 14* sizeof(agg_ht<apayl7>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_aht7, 14);
    }
    float* d_agg1;
    cudaMalloc((void**) &d_agg1, 14* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg1, 0.0f, 14);
    }
    float* d_agg2;
    cudaMalloc((void**) &d_agg2, 14* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg2, 0.0f, 14);
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

    cudaMemcpy( d_iatt3_lorderke, iatt3_lorderke, 6001215 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt13_lshipdat, iatt13_lshipdat, 6001215 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt14_lcommitd, iatt14_lcommitd, 6001215 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt15_lreceipt, iatt15_lreceipt, 6001215 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt17_lshipmod_offset, iatt17_lshipmod_offset, (6001215 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt17_lshipmod_char, iatt17_lshipmod_char, 25717043 * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt19_oorderke, iatt19_oorderke, 1500000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt24_oorderpr_offset, iatt24_oorderpr_offset, (1500000 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt24_oorderpr_char, iatt24_oorderpr_char, 12599838 * sizeof(char), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime105 = std::clock();
    std::clock_t start_krnl_lineitem1106 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_lineitem1<<<gridsize, blocksize>>>(d_iatt3_lorderke, d_iatt13_lshipdat, d_iatt14_lcommitd, d_iatt15_lreceipt, d_iatt17_lshipmod_offset, d_iatt17_lshipmod_char, d_jht4, d_jht4_payload);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_lineitem1106 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_lineitem1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_lineitem1")
        }
    }

    std::clock_t start_scanMultiHT107 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        scanMultiHT<<<gridsize, blocksize>>>(d_jht4, 840170, d_offs4);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_scanMultiHT107 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in scanMultiHT! " << cudaGetErrorString( err ) << std::endl;
            ERROR("scanMultiHT")
        }
    }

    std::clock_t start_krnl_lineitem1_ins108 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_lineitem1_ins<<<gridsize, blocksize>>>(d_iatt3_lorderke, d_iatt13_lshipdat, d_iatt14_lcommitd, d_iatt15_lreceipt, d_iatt17_lshipmod_offset, d_iatt17_lshipmod_char, d_jht4, d_jht4_payload, d_offs4);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_lineitem1_ins108 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_lineitem1_ins! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_lineitem1_ins")
        }
    }

    std::clock_t start_krnl_orders3109 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_orders3<<<gridsize, blocksize>>>(d_iatt19_oorderke, d_iatt24_oorderpr_offset, d_iatt24_oorderpr_char, d_jht4, d_jht4_payload, d_aht7, d_agg1, d_agg2);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_orders3109 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_orders3! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_orders3")
        }
    }

    std::clock_t start_krnl_aggregation7110 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation7<<<gridsize, blocksize>>>(d_aht7, d_agg1, d_agg2, d_nout_result, d_oatt17_lshipmod_offset, d_iatt17_lshipmod_char, d_oatt1_highline, d_oatt2_lowlinec);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation7110 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation7! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation7")
        }
    }

    std::clock_t stop_totalKernelTime105 = std::clock();
    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt17_lshipmod_offset.data(), d_oatt17_lshipmod_offset, 7 * sizeof(str_offs), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt1_highline.data(), d_oatt1_highline, 7 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt2_lowlinec.data(), d_oatt2_lowlinec, 7 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt3_lorderke);
    cudaFree( d_iatt13_lshipdat);
    cudaFree( d_iatt14_lcommitd);
    cudaFree( d_iatt15_lreceipt);
    cudaFree( d_iatt17_lshipmod_offset);
    cudaFree( d_iatt17_lshipmod_char);
    cudaFree( d_jht4);
    cudaFree( d_jht4_payload);
    cudaFree( d_offs4);
    cudaFree( d_iatt19_oorderke);
    cudaFree( d_iatt24_oorderpr_offset);
    cudaFree( d_iatt24_oorderpr_char);
    cudaFree( d_aht7);
    cudaFree( d_agg1);
    cudaFree( d_agg2);
    cudaFree( d_nout_result);
    cudaFree( d_oatt17_lshipmod_offset);
    cudaFree( d_oatt1_highline);
    cudaFree( d_oatt2_lowlinec);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda free! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda free")
        }
    }

    std::clock_t start_finish111 = std::clock();
    printf("\nResult: %i tuples\n", nout_result);
    if((nout_result > 7)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("l_shipmode: ");
        stringPrint ( iatt17_lshipmod_char, oatt17_lshipmod_offset[pv]);
        printf("  ");
        printf("high_line_count: ");
        printf("%15.2f", oatt1_highline[pv]);
        printf("  ");
        printf("low_line_count: ");
        printf("%15.2f", oatt2_lowlinec[pv]);
        printf("  ");
        printf("\n");
    }
    if((nout_result > 10)) {
        printf("[...]\n");
    }
    printf("\n");
    std::clock_t stop_finish111 = std::clock();

    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "krnl_lineitem1", (stop_krnl_lineitem1106 - start_krnl_lineitem1106) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "scanMultiHT", (stop_scanMultiHT107 - start_scanMultiHT107) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_lineitem1_ins", (stop_krnl_lineitem1_ins108 - start_krnl_lineitem1_ins108) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_orders3", (stop_krnl_orders3109 - start_krnl_orders3109) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation7", (stop_krnl_aggregation7110 - start_krnl_aggregation7110) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish111 - start_finish111) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime105 - start_totalKernelTime105) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
