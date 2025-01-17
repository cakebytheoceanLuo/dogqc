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
struct apayl4 {
    int att5_lsuppkey;
};
struct jpayl9 {
    float att2_totalrev;
};
struct jpayl11 {
    float att2_totalrev;
    int att22_lsuppkey;
};

__global__ void krnl_lineitem1(
    int* iatt5_lsuppkey, float* iatt8_lextende, float* iatt9_ldiscoun, unsigned* iatt13_lshipdat, agg_ht<apayl4>* aht4, float* agg1) {
    int att5_lsuppkey;
    float att8_lextende;
    float att9_ldiscoun;
    unsigned att13_lshipdat;
    float att19_revenue;

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
            att5_lsuppkey = iatt5_lsuppkey[tid_lineitem1];
            att8_lextende = iatt8_lextende[tid_lineitem1];
            att9_ldiscoun = iatt9_ldiscoun[tid_lineitem1];
            att13_lshipdat = iatt13_lshipdat[tid_lineitem1];
        }
        // -------- selection (opId: 2) --------
        if(active) {
            active = ((att13_lshipdat >= 19960101) && (att13_lshipdat < 19960401));
        }
        // -------- map (opId: 3) --------
        if(active) {
            att19_revenue = (att8_lextende * ((float)1.0 - att9_ldiscoun));
        }
        // -------- aggregation (opId: 4) --------
        int bucket = 0;
        if(active) {
            uint64_t hash4 = 0;
            hash4 = 0;
            if(active) {
                hash4 = hash ( (hash4 + ((uint64_t)att5_lsuppkey)));
            }
            apayl4 payl;
            payl.att5_lsuppkey = att5_lsuppkey;
            int bucketFound = 0;
            int numLookups = 0;
            while(!(bucketFound)) {
                bucket = hashAggregateGetBucket ( aht4, 2000000, hash4, numLookups, &(payl));
                apayl4 probepayl = aht4[bucket].payload;
                bucketFound = 1;
                bucketFound &= ((payl.att5_lsuppkey == probepayl.att5_lsuppkey));
            }
        }
        if(active) {
            atomicAdd(&(agg1[bucket]), ((float)att19_revenue));
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation4(
    agg_ht<apayl4>* aht4, float* agg1, int* nout_revenue, int* itm_revenue_l_suppkey, float* itm_revenue_sum_revenue) {
    int att5_lsuppkey;
    float att1_sumreven;
    unsigned warplane = (threadIdx.x % 32);
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

    int tid_aggregation4 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation4 = loopVar;
        active = (loopVar < 2000000);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 4) --------
        if(active) {
            active &= ((aht4[tid_aggregation4].lock.lock == OnceLock::LOCK_DONE));
        }
        if(active) {
            apayl4 payl = aht4[tid_aggregation4].payload;
            att5_lsuppkey = payl.att5_lsuppkey;
        }
        if(active) {
            att1_sumreven = agg1[tid_aggregation4];
        }
        // -------- materialize (opId: 5) --------
        int wp;
        int writeMask;
        int numProj;
        writeMask = __ballot_sync(ALL_LANES,active);
        numProj = __popc(writeMask);
        if((warplane == 0)) {
            wp = atomicAdd(nout_revenue, numProj);
        }
        wp = __shfl_sync(ALL_LANES,wp,0);
        wp = (wp + __popc((writeMask & prefixlanes)));
        if(active) {
            itm_revenue_l_suppkey[wp] = att5_lsuppkey;
            itm_revenue_sum_revenue[wp] = att1_sumreven;
        }
        loopVar += step;
    }

}

__global__ void krnl_revenue6(
    float* itm_revenue_sum_revenue, int* nout_revenue, float* agg2) {
    float att21_sumreven;

    int tid_revenue1 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_revenue1 = loopVar;
        active = (loopVar < *(nout_revenue));
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att21_sumreven = itm_revenue_sum_revenue[tid_revenue1];
        }
        // -------- aggregation (opId: 7) --------
        int bucket = 0;
        if(active) {
            atomicMax(&(agg2[bucket]), ((float)att21_sumreven));
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation7(
    float* agg2, multi_ht* jht9, jpayl9* jht9_payload) {
    float att2_totalrev;

    int tid_aggregation7 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation7 = loopVar;
        active = (loopVar < 1);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 7) --------
        if(active) {
            att2_totalrev = agg2[tid_aggregation7];
        }
        // -------- hash join build (opId: 9) --------
        if(active) {
            uint64_t hash9 = 0;
            if(active) {
                hash9 = 0;
                if(active) {
                    hash9 = hash ( (hash9 + ((uint64_t)att2_totalrev)));
                }
            }
            hashCountMulti ( jht9, 2, hash9);
        }
        loopVar += step;
    }

}

__global__ void krnl_aggregation7_ins(
    float* agg2, multi_ht* jht9, jpayl9* jht9_payload, int* offs9) {
    float att2_totalrev;

    int tid_aggregation7 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_aggregation7 = loopVar;
        active = (loopVar < 1);
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
        }
        // -------- scan aggregation ht (opId: 7) --------
        if(active) {
            att2_totalrev = agg2[tid_aggregation7];
        }
        // -------- hash join build (opId: 9) --------
        if(active) {
            uint64_t hash9 = 0;
            if(active) {
                hash9 = 0;
                if(active) {
                    hash9 = hash ( (hash9 + ((uint64_t)att2_totalrev)));
                }
            }
            jpayl9 payl;
            payl.att2_totalrev = att2_totalrev;
            hashInsertMulti ( jht9, jht9_payload, offs9, 2, hash9, &(payl));
        }
        loopVar += step;
    }

}

__global__ void krnl_revenue28(
    int* itm_revenue_l_suppkey, float* itm_revenue_sum_revenue, int* nout_revenue, multi_ht* jht9, jpayl9* jht9_payload, multi_ht* jht11, jpayl11* jht11_payload) {
    int att22_lsuppkey;
    float att23_sumreven;
    unsigned warplane = (threadIdx.x % 32);
    float att2_totalrev;

    int tid_revenue2 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_revenue2 = loopVar;
        active = (loopVar < *(nout_revenue));
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att22_lsuppkey = itm_revenue_l_suppkey[tid_revenue2];
            att23_sumreven = itm_revenue_sum_revenue[tid_revenue2];
        }
        // -------- hash join probe (opId: 9) --------
        // -------- multiprobe multi broadcast (opId: 9) --------
        int matchEnd9 = 0;
        int matchEndBuf9 = 0;
        int matchOffset9 = 0;
        int matchOffsetBuf9 = 0;
        int probeActive9 = active;
        int att22_lsuppkey_bcbuf9;
        float att23_sumreven_bcbuf9;
        uint64_t hash9 = 0;
        if(probeActive9) {
            hash9 = 0;
            if(active) {
                hash9 = hash ( (hash9 + ((uint64_t)att23_sumreven)));
            }
            probeActive9 = hashProbeMulti ( jht9, 2, hash9, matchOffsetBuf9, matchEndBuf9);
        }
        unsigned activeProbes9 = __ballot_sync(ALL_LANES,probeActive9);
        int num9 = 0;
        num9 = (matchEndBuf9 - matchOffsetBuf9);
        unsigned wideProbes9 = __ballot_sync(ALL_LANES,(num9 >= 32));
        att22_lsuppkey_bcbuf9 = att22_lsuppkey;
        att23_sumreven_bcbuf9 = att23_sumreven;
        while((activeProbes9 > 0)) {
            unsigned tupleLane;
            unsigned broadcastLane;
            int numFilled = 0;
            int num = 0;
            while(((numFilled < 32) && activeProbes9)) {
                if((wideProbes9 > 0)) {
                    tupleLane = (__ffs(wideProbes9) - 1);
                    wideProbes9 -= (1 << tupleLane);
                }
                else {
                    tupleLane = (__ffs(activeProbes9) - 1);
                }
                num = __shfl_sync(ALL_LANES,num9,tupleLane);
                if((numFilled && ((numFilled + num) > 32))) {
                    break;
                }
                if((warplane >= numFilled)) {
                    broadcastLane = tupleLane;
                    matchOffset9 = (warplane - numFilled);
                }
                numFilled += num;
                activeProbes9 -= (1 << tupleLane);
            }
            matchOffset9 += __shfl_sync(ALL_LANES,matchOffsetBuf9,broadcastLane);
            matchEnd9 = __shfl_sync(ALL_LANES,matchEndBuf9,broadcastLane);
            att22_lsuppkey = __shfl_sync(ALL_LANES,att22_lsuppkey_bcbuf9,broadcastLane);
            att23_sumreven = __shfl_sync(ALL_LANES,att23_sumreven_bcbuf9,broadcastLane);
            probeActive9 = (matchOffset9 < matchEnd9);
            while(__any_sync(ALL_LANES,probeActive9)) {
                active = probeActive9;
                active = 0;
                jpayl9 payl;
                if(probeActive9) {
                    payl = jht9_payload[matchOffset9];
                    att2_totalrev = payl.att2_totalrev;
                    active = 1;
                    active &= ((att2_totalrev == att23_sumreven));
                    matchOffset9 += 32;
                    probeActive9 &= ((matchOffset9 < matchEnd9));
                }
                // -------- hash join build (opId: 11) --------
                if(active) {
                    uint64_t hash11 = 0;
                    if(active) {
                        hash11 = 0;
                        if(active) {
                            hash11 = hash ( (hash11 + ((uint64_t)att22_lsuppkey)));
                        }
                    }
                    hashCountMulti ( jht11, 2000000, hash11);
                }
            }
        }
        loopVar += step;
    }

}

__global__ void krnl_revenue28_ins(
    int* itm_revenue_l_suppkey, float* itm_revenue_sum_revenue, int* nout_revenue, multi_ht* jht9, jpayl9* jht9_payload, multi_ht* jht11, jpayl11* jht11_payload, int* offs11) {
    int att22_lsuppkey;
    float att23_sumreven;
    unsigned warplane = (threadIdx.x % 32);
    float att2_totalrev;

    int tid_revenue2 = 0;
    unsigned loopVar = ((blockIdx.x * blockDim.x) + threadIdx.x);
    unsigned step = (blockDim.x * gridDim.x);
    unsigned flushPipeline = 0;
    int active = 0;
    while(!(flushPipeline)) {
        tid_revenue2 = loopVar;
        active = (loopVar < *(nout_revenue));
        // flush pipeline if no new elements
        flushPipeline = !(__ballot_sync(ALL_LANES,active));
        if(active) {
            att22_lsuppkey = itm_revenue_l_suppkey[tid_revenue2];
            att23_sumreven = itm_revenue_sum_revenue[tid_revenue2];
        }
        // -------- hash join probe (opId: 9) --------
        // -------- multiprobe multi broadcast (opId: 9) --------
        int matchEnd9 = 0;
        int matchEndBuf9 = 0;
        int matchOffset9 = 0;
        int matchOffsetBuf9 = 0;
        int probeActive9 = active;
        int att22_lsuppkey_bcbuf9;
        float att23_sumreven_bcbuf9;
        uint64_t hash9 = 0;
        if(probeActive9) {
            hash9 = 0;
            if(active) {
                hash9 = hash ( (hash9 + ((uint64_t)att23_sumreven)));
            }
            probeActive9 = hashProbeMulti ( jht9, 2, hash9, matchOffsetBuf9, matchEndBuf9);
        }
        unsigned activeProbes9 = __ballot_sync(ALL_LANES,probeActive9);
        int num9 = 0;
        num9 = (matchEndBuf9 - matchOffsetBuf9);
        unsigned wideProbes9 = __ballot_sync(ALL_LANES,(num9 >= 32));
        att22_lsuppkey_bcbuf9 = att22_lsuppkey;
        att23_sumreven_bcbuf9 = att23_sumreven;
        while((activeProbes9 > 0)) {
            unsigned tupleLane;
            unsigned broadcastLane;
            int numFilled = 0;
            int num = 0;
            while(((numFilled < 32) && activeProbes9)) {
                if((wideProbes9 > 0)) {
                    tupleLane = (__ffs(wideProbes9) - 1);
                    wideProbes9 -= (1 << tupleLane);
                }
                else {
                    tupleLane = (__ffs(activeProbes9) - 1);
                }
                num = __shfl_sync(ALL_LANES,num9,tupleLane);
                if((numFilled && ((numFilled + num) > 32))) {
                    break;
                }
                if((warplane >= numFilled)) {
                    broadcastLane = tupleLane;
                    matchOffset9 = (warplane - numFilled);
                }
                numFilled += num;
                activeProbes9 -= (1 << tupleLane);
            }
            matchOffset9 += __shfl_sync(ALL_LANES,matchOffsetBuf9,broadcastLane);
            matchEnd9 = __shfl_sync(ALL_LANES,matchEndBuf9,broadcastLane);
            att22_lsuppkey = __shfl_sync(ALL_LANES,att22_lsuppkey_bcbuf9,broadcastLane);
            att23_sumreven = __shfl_sync(ALL_LANES,att23_sumreven_bcbuf9,broadcastLane);
            probeActive9 = (matchOffset9 < matchEnd9);
            while(__any_sync(ALL_LANES,probeActive9)) {
                active = probeActive9;
                active = 0;
                jpayl9 payl;
                if(probeActive9) {
                    payl = jht9_payload[matchOffset9];
                    att2_totalrev = payl.att2_totalrev;
                    active = 1;
                    active &= ((att2_totalrev == att23_sumreven));
                    matchOffset9 += 32;
                    probeActive9 &= ((matchOffset9 < matchEnd9));
                }
                // -------- hash join build (opId: 11) --------
                if(active) {
                    uint64_t hash11 = 0;
                    if(active) {
                        hash11 = 0;
                        if(active) {
                            hash11 = hash ( (hash11 + ((uint64_t)att22_lsuppkey)));
                        }
                    }
                    jpayl11 payl;
                    payl.att2_totalrev = att2_totalrev;
                    payl.att22_lsuppkey = att22_lsuppkey;
                    hashInsertMulti ( jht11, jht11_payload, offs11, 2000000, hash11, &(payl));
                }
            }
        }
        loopVar += step;
    }

}

__global__ void krnl_supplier10(
    int* iatt24_ssuppkey, size_t* iatt25_sname_offset, char* iatt25_sname_char, size_t* iatt26_saddress_offset, char* iatt26_saddress_char, size_t* iatt28_sphone_offset, char* iatt28_sphone_char, multi_ht* jht11, jpayl11* jht11_payload, int* nout_result, int* oatt24_ssuppkey, str_offs* oatt25_sname_offset, str_offs* oatt26_saddress_offset, str_offs* oatt28_sphone_offset, float* oatt2_totalrev) {
    int att24_ssuppkey;
    str_t att25_sname;
    str_t att26_saddress;
    str_t att28_sphone;
    unsigned warplane = (threadIdx.x % 32);
    float att2_totalrev;
    int att22_lsuppkey;
    unsigned prefixlanes = (0xffffffff >> (32 - warplane));

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
            att24_ssuppkey = iatt24_ssuppkey[tid_supplier1];
            att25_sname = stringScan ( iatt25_sname_offset, iatt25_sname_char, tid_supplier1);
            att26_saddress = stringScan ( iatt26_saddress_offset, iatt26_saddress_char, tid_supplier1);
            att28_sphone = stringScan ( iatt28_sphone_offset, iatt28_sphone_char, tid_supplier1);
        }
        // -------- hash join probe (opId: 11) --------
        // -------- multiprobe multi broadcast (opId: 11) --------
        int matchEnd11 = 0;
        int matchEndBuf11 = 0;
        int matchOffset11 = 0;
        int matchOffsetBuf11 = 0;
        int probeActive11 = active;
        int att24_ssuppkey_bcbuf11;
        str_t att25_sname_bcbuf11;
        str_t att26_saddress_bcbuf11;
        str_t att28_sphone_bcbuf11;
        uint64_t hash11 = 0;
        if(probeActive11) {
            hash11 = 0;
            if(active) {
                hash11 = hash ( (hash11 + ((uint64_t)att24_ssuppkey)));
            }
            probeActive11 = hashProbeMulti ( jht11, 2000000, hash11, matchOffsetBuf11, matchEndBuf11);
        }
        unsigned activeProbes11 = __ballot_sync(ALL_LANES,probeActive11);
        int num11 = 0;
        num11 = (matchEndBuf11 - matchOffsetBuf11);
        unsigned wideProbes11 = __ballot_sync(ALL_LANES,(num11 >= 32));
        att24_ssuppkey_bcbuf11 = att24_ssuppkey;
        att25_sname_bcbuf11 = att25_sname;
        att26_saddress_bcbuf11 = att26_saddress;
        att28_sphone_bcbuf11 = att28_sphone;
        while((activeProbes11 > 0)) {
            unsigned tupleLane;
            unsigned broadcastLane;
            int numFilled = 0;
            int num = 0;
            while(((numFilled < 32) && activeProbes11)) {
                if((wideProbes11 > 0)) {
                    tupleLane = (__ffs(wideProbes11) - 1);
                    wideProbes11 -= (1 << tupleLane);
                }
                else {
                    tupleLane = (__ffs(activeProbes11) - 1);
                }
                num = __shfl_sync(ALL_LANES,num11,tupleLane);
                if((numFilled && ((numFilled + num) > 32))) {
                    break;
                }
                if((warplane >= numFilled)) {
                    broadcastLane = tupleLane;
                    matchOffset11 = (warplane - numFilled);
                }
                numFilled += num;
                activeProbes11 -= (1 << tupleLane);
            }
            matchOffset11 += __shfl_sync(ALL_LANES,matchOffsetBuf11,broadcastLane);
            matchEnd11 = __shfl_sync(ALL_LANES,matchEndBuf11,broadcastLane);
            att24_ssuppkey = __shfl_sync(ALL_LANES,att24_ssuppkey_bcbuf11,broadcastLane);
            att25_sname = __shfl_sync(ALL_LANES,att25_sname_bcbuf11,broadcastLane);
            att26_saddress = __shfl_sync(ALL_LANES,att26_saddress_bcbuf11,broadcastLane);
            att28_sphone = __shfl_sync(ALL_LANES,att28_sphone_bcbuf11,broadcastLane);
            probeActive11 = (matchOffset11 < matchEnd11);
            while(__any_sync(ALL_LANES,probeActive11)) {
                active = probeActive11;
                active = 0;
                jpayl11 payl;
                if(probeActive11) {
                    payl = jht11_payload[matchOffset11];
                    att2_totalrev = payl.att2_totalrev;
                    att22_lsuppkey = payl.att22_lsuppkey;
                    active = 1;
                    active &= ((att22_lsuppkey == att24_ssuppkey));
                    matchOffset11 += 32;
                    probeActive11 &= ((matchOffset11 < matchEnd11));
                }
                // -------- projection (no code) (opId: 12) --------
                // -------- materialize (opId: 13) --------
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
                    oatt24_ssuppkey[wp] = att24_ssuppkey;
                    oatt25_sname_offset[wp] = toStringOffset ( iatt25_sname_char, att25_sname);
                    oatt26_saddress_offset[wp] = toStringOffset ( iatt26_saddress_char, att26_saddress);
                    oatt28_sphone_offset[wp] = toStringOffset ( iatt28_sphone_char, att28_sphone);
                    oatt2_totalrev[wp] = att2_totalrev;
                }
            }
        }
        loopVar += step;
    }

}

int main() {
    int* iatt5_lsuppkey;
    iatt5_lsuppkey = ( int*) map_memory_file ( "mmdb/lineitem_l_suppkey" );
    float* iatt8_lextende;
    iatt8_lextende = ( float*) map_memory_file ( "mmdb/lineitem_l_extendedprice" );
    float* iatt9_ldiscoun;
    iatt9_ldiscoun = ( float*) map_memory_file ( "mmdb/lineitem_l_discount" );
    unsigned* iatt13_lshipdat;
    iatt13_lshipdat = ( unsigned*) map_memory_file ( "mmdb/lineitem_l_shipdate" );
    int* iatt24_ssuppkey;
    iatt24_ssuppkey = ( int*) map_memory_file ( "mmdb/supplier_s_suppkey" );
    size_t* iatt25_sname_offset;
    iatt25_sname_offset = ( size_t*) map_memory_file ( "mmdb/supplier_s_name_offset" );
    char* iatt25_sname_char;
    iatt25_sname_char = ( char*) map_memory_file ( "mmdb/supplier_s_name_char" );
    size_t* iatt26_saddress_offset;
    iatt26_saddress_offset = ( size_t*) map_memory_file ( "mmdb/supplier_s_address_offset" );
    char* iatt26_saddress_char;
    iatt26_saddress_char = ( char*) map_memory_file ( "mmdb/supplier_s_address_char" );
    size_t* iatt28_sphone_offset;
    iatt28_sphone_offset = ( size_t*) map_memory_file ( "mmdb/supplier_s_phone_offset" );
    char* iatt28_sphone_char;
    iatt28_sphone_char = ( char*) map_memory_file ( "mmdb/supplier_s_phone_char" );

    int nout_revenue;
    int nout_result;
    std::vector < int > oatt24_ssuppkey(1000000);
    std::vector < str_offs > oatt25_sname_offset(1000000);
    std::vector < str_offs > oatt26_saddress_offset(1000000);
    std::vector < str_offs > oatt28_sphone_offset(1000000);
    std::vector < float > oatt2_totalrev(1000000);

    // wake up gpu
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in wake up gpu! " << cudaGetErrorString( err ) << std::endl;
            ERROR("wake up gpu")
        }
    }

    int* d_iatt5_lsuppkey;
    cudaMalloc((void**) &d_iatt5_lsuppkey, 6001215* sizeof(int) );
    float* d_iatt8_lextende;
    cudaMalloc((void**) &d_iatt8_lextende, 6001215* sizeof(float) );
    float* d_iatt9_ldiscoun;
    cudaMalloc((void**) &d_iatt9_ldiscoun, 6001215* sizeof(float) );
    unsigned* d_iatt13_lshipdat;
    cudaMalloc((void**) &d_iatt13_lshipdat, 6001215* sizeof(unsigned) );
    int* d_nout_revenue;
    cudaMalloc((void**) &d_nout_revenue, 1* sizeof(int) );
    int* d_itm_revenue_l_suppkey;
    cudaMalloc((void**) &d_itm_revenue_l_suppkey, 1000000* sizeof(int) );
    float* d_itm_revenue_sum_revenue;
    cudaMalloc((void**) &d_itm_revenue_sum_revenue, 1000000* sizeof(float) );
    int* d_iatt24_ssuppkey;
    cudaMalloc((void**) &d_iatt24_ssuppkey, 10000* sizeof(int) );
    size_t* d_iatt25_sname_offset;
    cudaMalloc((void**) &d_iatt25_sname_offset, (10000 + 1)* sizeof(size_t) );
    char* d_iatt25_sname_char;
    cudaMalloc((void**) &d_iatt25_sname_char, 180009* sizeof(char) );
    size_t* d_iatt26_saddress_offset;
    cudaMalloc((void**) &d_iatt26_saddress_offset, (10000 + 1)* sizeof(size_t) );
    char* d_iatt26_saddress_char;
    cudaMalloc((void**) &d_iatt26_saddress_char, 249461* sizeof(char) );
    size_t* d_iatt28_sphone_offset;
    cudaMalloc((void**) &d_iatt28_sphone_offset, (10000 + 1)* sizeof(size_t) );
    char* d_iatt28_sphone_char;
    cudaMalloc((void**) &d_iatt28_sphone_char, 150009* sizeof(char) );
    int* d_nout_result;
    cudaMalloc((void**) &d_nout_result, 1* sizeof(int) );
    int* d_oatt24_ssuppkey;
    cudaMalloc((void**) &d_oatt24_ssuppkey, 1000000* sizeof(int) );
    str_offs* d_oatt25_sname_offset;
    cudaMalloc((void**) &d_oatt25_sname_offset, 1000000* sizeof(str_offs) );
    str_offs* d_oatt26_saddress_offset;
    cudaMalloc((void**) &d_oatt26_saddress_offset, 1000000* sizeof(str_offs) );
    str_offs* d_oatt28_sphone_offset;
    cudaMalloc((void**) &d_oatt28_sphone_offset, 1000000* sizeof(str_offs) );
    float* d_oatt2_totalrev;
    cudaMalloc((void**) &d_oatt2_totalrev, 1000000* sizeof(float) );
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

    agg_ht<apayl4>* d_aht4;
    cudaMalloc((void**) &d_aht4, 2000000* sizeof(agg_ht<apayl4>) );
    {
        int gridsize=920;
        int blocksize=128;
        initAggHT<<<gridsize, blocksize>>>(d_aht4, 2000000);
    }
    float* d_agg1;
    cudaMalloc((void**) &d_agg1, 2000000* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg1, 0.0f, 2000000);
    }
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_nout_revenue, 0, 1);
    }
    float* d_agg2;
    cudaMalloc((void**) &d_agg2, 1* sizeof(float) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_agg2, FLT_MIN, 1);
    }
    multi_ht* d_jht9;
    cudaMalloc((void**) &d_jht9, 2* sizeof(multi_ht) );
    jpayl9* d_jht9_payload;
    cudaMalloc((void**) &d_jht9_payload, 2* sizeof(jpayl9) );
    {
        int gridsize=920;
        int blocksize=128;
        initMultiHT<<<gridsize, blocksize>>>(d_jht9, 2);
    }
    int* d_offs9;
    cudaMalloc((void**) &d_offs9, 1* sizeof(int) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_offs9, 0, 1);
    }
    multi_ht* d_jht11;
    cudaMalloc((void**) &d_jht11, 2000000* sizeof(multi_ht) );
    jpayl11* d_jht11_payload;
    cudaMalloc((void**) &d_jht11_payload, 2000000* sizeof(jpayl11) );
    {
        int gridsize=920;
        int blocksize=128;
        initMultiHT<<<gridsize, blocksize>>>(d_jht11, 2000000);
    }
    int* d_offs11;
    cudaMalloc((void**) &d_offs11, 1* sizeof(int) );
    {
        int gridsize=920;
        int blocksize=128;
        initArray<<<gridsize, blocksize>>>(d_offs11, 0, 1);
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

    cudaMemcpy( d_iatt5_lsuppkey, iatt5_lsuppkey, 6001215 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt8_lextende, iatt8_lextende, 6001215 * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt9_ldiscoun, iatt9_ldiscoun, 6001215 * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt13_lshipdat, iatt13_lshipdat, 6001215 * sizeof(unsigned), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt24_ssuppkey, iatt24_ssuppkey, 10000 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt25_sname_offset, iatt25_sname_offset, (10000 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt25_sname_char, iatt25_sname_char, 180009 * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt26_saddress_offset, iatt26_saddress_offset, (10000 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt26_saddress_char, iatt26_saddress_char, 249461 * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt28_sphone_offset, iatt28_sphone_offset, (10000 + 1) * sizeof(size_t), cudaMemcpyHostToDevice);
    cudaMemcpy( d_iatt28_sphone_char, iatt28_sphone_char, 150009 * sizeof(char), cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy in! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy in")
        }
    }

    std::clock_t start_totalKernelTime126 = std::clock();
    std::clock_t start_krnl_lineitem1127 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_lineitem1<<<gridsize, blocksize>>>(d_iatt5_lsuppkey, d_iatt8_lextende, d_iatt9_ldiscoun, d_iatt13_lshipdat, d_aht4, d_agg1);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_lineitem1127 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_lineitem1! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_lineitem1")
        }
    }

    std::clock_t start_krnl_aggregation4128 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation4<<<gridsize, blocksize>>>(d_aht4, d_agg1, d_nout_revenue, d_itm_revenue_l_suppkey, d_itm_revenue_sum_revenue);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation4128 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation4! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation4")
        }
    }

    std::clock_t start_krnl_revenue6129 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_revenue6<<<gridsize, blocksize>>>(d_itm_revenue_sum_revenue, d_nout_revenue, d_agg2);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_revenue6129 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_revenue6! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_revenue6")
        }
    }

    std::clock_t start_krnl_aggregation7130 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation7<<<gridsize, blocksize>>>(d_agg2, d_jht9, d_jht9_payload);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation7130 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation7! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation7")
        }
    }

    std::clock_t start_scanMultiHT131 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        scanMultiHT<<<gridsize, blocksize>>>(d_jht9, 2, d_offs9);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_scanMultiHT131 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in scanMultiHT! " << cudaGetErrorString( err ) << std::endl;
            ERROR("scanMultiHT")
        }
    }

    std::clock_t start_krnl_aggregation7_ins132 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_aggregation7_ins<<<gridsize, blocksize>>>(d_agg2, d_jht9, d_jht9_payload, d_offs9);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_aggregation7_ins132 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_aggregation7_ins! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_aggregation7_ins")
        }
    }

    std::clock_t start_krnl_revenue28133 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_revenue28<<<gridsize, blocksize>>>(d_itm_revenue_l_suppkey, d_itm_revenue_sum_revenue, d_nout_revenue, d_jht9, d_jht9_payload, d_jht11, d_jht11_payload);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_revenue28133 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_revenue28! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_revenue28")
        }
    }

    std::clock_t start_scanMultiHT134 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        scanMultiHT<<<gridsize, blocksize>>>(d_jht11, 2000000, d_offs11);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_scanMultiHT134 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in scanMultiHT! " << cudaGetErrorString( err ) << std::endl;
            ERROR("scanMultiHT")
        }
    }

    std::clock_t start_krnl_revenue28_ins135 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_revenue28_ins<<<gridsize, blocksize>>>(d_itm_revenue_l_suppkey, d_itm_revenue_sum_revenue, d_nout_revenue, d_jht9, d_jht9_payload, d_jht11, d_jht11_payload, d_offs11);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_revenue28_ins135 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_revenue28_ins! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_revenue28_ins")
        }
    }

    std::clock_t start_krnl_supplier10136 = std::clock();
    {
        int gridsize=920;
        int blocksize=128;
        krnl_supplier10<<<gridsize, blocksize>>>(d_iatt24_ssuppkey, d_iatt25_sname_offset, d_iatt25_sname_char, d_iatt26_saddress_offset, d_iatt26_saddress_char, d_iatt28_sphone_offset, d_iatt28_sphone_char, d_jht11, d_jht11_payload, d_nout_result, d_oatt24_ssuppkey, d_oatt25_sname_offset, d_oatt26_saddress_offset, d_oatt28_sphone_offset, d_oatt2_totalrev);
    }
    cudaDeviceSynchronize();
    std::clock_t stop_krnl_supplier10136 = std::clock();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in krnl_supplier10! " << cudaGetErrorString( err ) << std::endl;
            ERROR("krnl_supplier10")
        }
    }

    std::clock_t stop_totalKernelTime126 = std::clock();
    cudaMemcpy( &nout_revenue, d_nout_revenue, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( &nout_result, d_nout_result, 1 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt24_ssuppkey.data(), d_oatt24_ssuppkey, 1000000 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt25_sname_offset.data(), d_oatt25_sname_offset, 1000000 * sizeof(str_offs), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt26_saddress_offset.data(), d_oatt26_saddress_offset, 1000000 * sizeof(str_offs), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt28_sphone_offset.data(), d_oatt28_sphone_offset, 1000000 * sizeof(str_offs), cudaMemcpyDeviceToHost);
    cudaMemcpy( oatt2_totalrev.data(), d_oatt2_totalrev, 1000000 * sizeof(float), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda memcpy out! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda memcpy out")
        }
    }

    cudaFree( d_iatt5_lsuppkey);
    cudaFree( d_iatt8_lextende);
    cudaFree( d_iatt9_ldiscoun);
    cudaFree( d_iatt13_lshipdat);
    cudaFree( d_aht4);
    cudaFree( d_agg1);
    cudaFree( d_nout_revenue);
    cudaFree( d_itm_revenue_l_suppkey);
    cudaFree( d_itm_revenue_sum_revenue);
    cudaFree( d_agg2);
    cudaFree( d_jht9);
    cudaFree( d_jht9_payload);
    cudaFree( d_offs9);
    cudaFree( d_jht11);
    cudaFree( d_jht11_payload);
    cudaFree( d_offs11);
    cudaFree( d_iatt24_ssuppkey);
    cudaFree( d_iatt25_sname_offset);
    cudaFree( d_iatt25_sname_char);
    cudaFree( d_iatt26_saddress_offset);
    cudaFree( d_iatt26_saddress_char);
    cudaFree( d_iatt28_sphone_offset);
    cudaFree( d_iatt28_sphone_char);
    cudaFree( d_nout_result);
    cudaFree( d_oatt24_ssuppkey);
    cudaFree( d_oatt25_sname_offset);
    cudaFree( d_oatt26_saddress_offset);
    cudaFree( d_oatt28_sphone_offset);
    cudaFree( d_oatt2_totalrev);
    cudaDeviceSynchronize();
    {
        cudaError err = cudaGetLastError();
        if(err != cudaSuccess) {
            std::cerr << "Cuda Error in cuda free! " << cudaGetErrorString( err ) << std::endl;
            ERROR("cuda free")
        }
    }

    std::clock_t start_finish137 = std::clock();
    printf("\nResult: %i tuples\n", nout_result);
    if((nout_result > 1000000)) {
        ERROR("Index out of range. Output size larger than allocated with expected result number.")
    }
    for ( int pv = 0; ((pv < 10) && (pv < nout_result)); pv += 1) {
        printf("s_suppkey: ");
        printf("%8i", oatt24_ssuppkey[pv]);
        printf("  ");
        printf("s_name: ");
        stringPrint ( iatt25_sname_char, oatt25_sname_offset[pv]);
        printf("  ");
        printf("s_address: ");
        stringPrint ( iatt26_saddress_char, oatt26_saddress_offset[pv]);
        printf("  ");
        printf("s_phone: ");
        stringPrint ( iatt28_sphone_char, oatt28_sphone_offset[pv]);
        printf("  ");
        printf("total_revenue: ");
        printf("%15.2f", oatt2_totalrev[pv]);
        printf("  ");
        printf("\n");
    }
    if((nout_result > 10)) {
        printf("[...]\n");
    }
    printf("\n");
    std::clock_t stop_finish137 = std::clock();

    printf("<timing>\n");
    printf ( "%32s: %6.1f ms\n", "krnl_lineitem1", (stop_krnl_lineitem1127 - start_krnl_lineitem1127) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation4", (stop_krnl_aggregation4128 - start_krnl_aggregation4128) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_revenue6", (stop_krnl_revenue6129 - start_krnl_revenue6129) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation7", (stop_krnl_aggregation7130 - start_krnl_aggregation7130) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "scanMultiHT", (stop_scanMultiHT131 - start_scanMultiHT131) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_aggregation7_ins", (stop_krnl_aggregation7_ins132 - start_krnl_aggregation7_ins132) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_revenue28", (stop_krnl_revenue28133 - start_krnl_revenue28133) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "scanMultiHT", (stop_scanMultiHT134 - start_scanMultiHT134) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_revenue28_ins", (stop_krnl_revenue28_ins135 - start_krnl_revenue28_ins135) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "krnl_supplier10", (stop_krnl_supplier10136 - start_krnl_supplier10136) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "finish", (stop_finish137 - start_finish137) / (double) (CLOCKS_PER_SEC / 1000) );
    printf ( "%32s: %6.1f ms\n", "totalKernelTime", (stop_totalKernelTime126 - start_totalKernelTime126) / (double) (CLOCKS_PER_SEC / 1000) );
    printf("</timing>\n");
}
