; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 4
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefixes=AVX

define void @main(<16 x i32> %0, i32 %1) {
; SSE-LABEL: main:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movd %edi, %xmm4
; SSE-NEXT:    movss {{.*#+}} xmm0 = [1,0,0,0]
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,0],xmm4[1,0]
; SSE-NEXT:    paddd %xmm0, %xmm0
; SSE-NEXT:    paddd %xmm1, %xmm1
; SSE-NEXT:    paddd %xmm3, %xmm3
; SSE-NEXT:    paddd %xmm2, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[0,1,1,3]
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,0],xmm1[1,0]
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[1,3]
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[3,0],xmm2[1,0]
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,2],xmm2[1,3]
; SSE-NEXT:    shufps {{.*#+}} xmm2 = xmm2[3,0],xmm3[1,0]
; SSE-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,2],xmm3[1,3]
; SSE-NEXT:    xorps %xmm2, %xmm0
; SSE-NEXT:    xorps %xmm4, %xmm1
; SSE-NEXT:    xorps %xmm0, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm1[2,3,2,3]
; SSE-NEXT:    pxor %xmm1, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,1,1]
; SSE-NEXT:    pxor %xmm0, %xmm1
; SSE-NEXT:    movd %xmm1, 0
; SSE-NEXT:    retq
;
; AVX-LABEL: main:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vpblendd {{.*#+}} xmm2 = xmm2[0],xmm0[1,2,3]
; AVX-NEXT:    movl $1, %eax
; AVX-NEXT:    vpinsrd $1, %eax, %xmm2, %xmm2
; AVX-NEXT:    vpinsrd $3, %edi, %xmm2, %xmm2
; AVX-NEXT:    vpblendd {{.*#+}} ymm0 = ymm2[0,1,2,3],ymm0[4,5,6,7]
; AVX-NEXT:    vpaddd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    vpaddd %ymm1, %ymm1, %ymm1
; AVX-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,1,1,3,3,5,5,7]
; AVX-NEXT:    vpermd %ymm0, %ymm2, %ymm2
; AVX-NEXT:    vperm2i128 {{.*#+}} ymm0 = ymm0[2,3],ymm1[0,1]
; AVX-NEXT:    vpshufd {{.*#+}} ymm0 = ymm0[3,3,3,3,7,7,7,7]
; AVX-NEXT:    vpshufd {{.*#+}} ymm1 = ymm1[0,1,1,3,4,5,5,7]
; AVX-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm1[1,2,3],ymm0[4],ymm1[5,6,7]
; AVX-NEXT:    vpxor %ymm0, %ymm2, %ymm0
; AVX-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,2,3]
; AVX-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,1,1]
; AVX-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovd %xmm0, 0
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
entry:
  %2 = insertelement <16 x i32> %0, i32 1, i64 1
  %3 = insertelement <16 x i32> %2, i32 %1, i64 3
  %4 = insertelement <16 x i32> %3, i32 0, i64 0
  %5 = shl <16 x i32> %4, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %6 = shufflevector <16 x i32> %5, <16 x i32> zeroinitializer, <16 x i32> <i32 0, i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7, i32 9, i32 9, i32 11, i32 11, i32 13, i32 13, i32 15>
  %7 = tail call i32 @llvm.vector.reduce.xor.v16i32(<16 x i32> %6)
  store i32 %7, ptr null, align 4
  ret void
}
declare i32 @llvm.vector.reduce.xor.v16i32(<16 x i32>)
