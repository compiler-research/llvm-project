; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs \
; RUN:   --riscv-no-aliases < %s | FileCheck %s
declare <vscale x 1 x i16> @llvm.riscv.vwaddu.w.nxv1i16.nxv1i8(
  <vscale x 1 x i16>,
  <vscale x 1 x i8>,
  i64);

define <vscale x 1 x i16> @intrinsic_vwaddu.w_wv_nxv1i16_nxv1i16_nxv1i8(<vscale x 1 x i16> %0, <vscale x 1 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv1i16_nxv1i16_nxv1i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 1 x i16> @llvm.riscv.vwaddu.w.nxv1i16.nxv1i8(
    <vscale x 1 x i16> %0,
    <vscale x 1 x i8> %1,
    i64 %2)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 1 x i16> @llvm.riscv.vwaddu.w.mask.nxv1i16.nxv1i8(
  <vscale x 1 x i16>,
  <vscale x 1 x i16>,
  <vscale x 1 x i8>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i16> @intrinsic_vwaddu.w_mask_wv_nxv1i16_nxv1i16_nxv1i8(<vscale x 1 x i16> %0, <vscale x 1 x i16> %1, <vscale x 1 x i8> %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv1i16_nxv1i16_nxv1i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 1 x i16> @llvm.riscv.vwaddu.w.mask.nxv1i16.nxv1i8(
    <vscale x 1 x i16> %0,
    <vscale x 1 x i16> %1,
    <vscale x 1 x i8> %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vwaddu.w.nxv2i16.nxv2i8(
  <vscale x 2 x i16>,
  <vscale x 2 x i8>,
  i64);

define <vscale x 2 x i16> @intrinsic_vwaddu.w_wv_nxv2i16_nxv2i16_nxv2i8(<vscale x 2 x i16> %0, <vscale x 2 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv2i16_nxv2i16_nxv2i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 2 x i16> @llvm.riscv.vwaddu.w.nxv2i16.nxv2i8(
    <vscale x 2 x i16> %0,
    <vscale x 2 x i8> %1,
    i64 %2)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vwaddu.w.mask.nxv2i16.nxv2i8(
  <vscale x 2 x i16>,
  <vscale x 2 x i16>,
  <vscale x 2 x i8>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i16> @intrinsic_vwaddu.w_mask_wv_nxv2i16_nxv2i16_nxv2i8(<vscale x 2 x i16> %0, <vscale x 2 x i16> %1, <vscale x 2 x i8> %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv2i16_nxv2i16_nxv2i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 2 x i16> @llvm.riscv.vwaddu.w.mask.nxv2i16.nxv2i8(
    <vscale x 2 x i16> %0,
    <vscale x 2 x i16> %1,
    <vscale x 2 x i8> %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vwaddu.w.nxv4i16.nxv4i8(
  <vscale x 4 x i16>,
  <vscale x 4 x i8>,
  i64);

define <vscale x 4 x i16> @intrinsic_vwaddu.w_wv_nxv4i16_nxv4i16_nxv4i8(<vscale x 4 x i16> %0, <vscale x 4 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv4i16_nxv4i16_nxv4i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 4 x i16> @llvm.riscv.vwaddu.w.nxv4i16.nxv4i8(
    <vscale x 4 x i16> %0,
    <vscale x 4 x i8> %1,
    i64 %2)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vwaddu.w.mask.nxv4i16.nxv4i8(
  <vscale x 4 x i16>,
  <vscale x 4 x i16>,
  <vscale x 4 x i8>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i16> @intrinsic_vwaddu.w_mask_wv_nxv4i16_nxv4i16_nxv4i8(<vscale x 4 x i16> %0, <vscale x 4 x i16> %1, <vscale x 4 x i8> %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv4i16_nxv4i16_nxv4i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 4 x i16> @llvm.riscv.vwaddu.w.mask.nxv4i16.nxv4i8(
    <vscale x 4 x i16> %0,
    <vscale x 4 x i16> %1,
    <vscale x 4 x i8> %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vwaddu.w.nxv8i16.nxv8i8(
  <vscale x 8 x i16>,
  <vscale x 8 x i8>,
  i64);

define <vscale x 8 x i16> @intrinsic_vwaddu.w_wv_nxv8i16_nxv8i16_nxv8i8(<vscale x 8 x i16> %0, <vscale x 8 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv8i16_nxv8i16_nxv8i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 8 x i16> @llvm.riscv.vwaddu.w.nxv8i16.nxv8i8(
    <vscale x 8 x i16> %0,
    <vscale x 8 x i8> %1,
    i64 %2)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vwaddu.w.mask.nxv8i16.nxv8i8(
  <vscale x 8 x i16>,
  <vscale x 8 x i16>,
  <vscale x 8 x i8>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i16> @intrinsic_vwaddu.w_mask_wv_nxv8i16_nxv8i16_nxv8i8(<vscale x 8 x i16> %0, <vscale x 8 x i16> %1, <vscale x 8 x i8> %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv8i16_nxv8i16_nxv8i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 8 x i16> @llvm.riscv.vwaddu.w.mask.nxv8i16.nxv8i8(
    <vscale x 8 x i16> %0,
    <vscale x 8 x i16> %1,
    <vscale x 8 x i8> %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vwaddu.w.nxv16i16.nxv16i8(
  <vscale x 16 x i16>,
  <vscale x 16 x i8>,
  i64);

define <vscale x 16 x i16> @intrinsic_vwaddu.w_wv_nxv16i16_nxv16i16_nxv16i8(<vscale x 16 x i16> %0, <vscale x 16 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv16i16_nxv16i16_nxv16i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 16 x i16> @llvm.riscv.vwaddu.w.nxv16i16.nxv16i8(
    <vscale x 16 x i16> %0,
    <vscale x 16 x i8> %1,
    i64 %2)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vwaddu.w.mask.nxv16i16.nxv16i8(
  <vscale x 16 x i16>,
  <vscale x 16 x i16>,
  <vscale x 16 x i8>,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i16> @intrinsic_vwaddu.w_mask_wv_nxv16i16_nxv16i16_nxv16i8(<vscale x 16 x i16> %0, <vscale x 16 x i16> %1, <vscale x 16 x i8> %2, <vscale x 16 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv16i16_nxv16i16_nxv16i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 16 x i16> @llvm.riscv.vwaddu.w.mask.nxv16i16.nxv16i8(
    <vscale x 16 x i16> %0,
    <vscale x 16 x i16> %1,
    <vscale x 16 x i8> %2,
    <vscale x 16 x i1> %3,
    i64 %4)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vwaddu.w.nxv32i16.nxv32i8(
  <vscale x 32 x i16>,
  <vscale x 32 x i8>,
  i64);

define <vscale x 32 x i16> @intrinsic_vwaddu.w_wv_nxv32i16_nxv32i16_nxv32i8(<vscale x 32 x i16> %0, <vscale x 32 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv32i16_nxv32i16_nxv32i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 32 x i16> @llvm.riscv.vwaddu.w.nxv32i16.nxv32i8(
    <vscale x 32 x i16> %0,
    <vscale x 32 x i8> %1,
    i64 %2)

  ret <vscale x 32 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vwaddu.w.mask.nxv32i16.nxv32i8(
  <vscale x 32 x i16>,
  <vscale x 32 x i16>,
  <vscale x 32 x i8>,
  <vscale x 32 x i1>,
  i64);

define <vscale x 32 x i16> @intrinsic_vwaddu.w_mask_wv_nxv32i16_nxv32i16_nxv32i8(<vscale x 32 x i16> %0, <vscale x 32 x i16> %1, <vscale x 32 x i8> %2, <vscale x 32 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv32i16_nxv32i16_nxv32i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 32 x i16> @llvm.riscv.vwaddu.w.mask.nxv32i16.nxv32i8(
    <vscale x 32 x i16> %0,
    <vscale x 32 x i16> %1,
    <vscale x 32 x i8> %2,
    <vscale x 32 x i1> %3,
    i64 %4)

  ret <vscale x 32 x i16> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vwaddu.w.nxv1i32.nxv1i16(
  <vscale x 1 x i32>,
  <vscale x 1 x i16>,
  i64);

define <vscale x 1 x i32> @intrinsic_vwaddu.w_wv_nxv1i32_nxv1i32_nxv1i16(<vscale x 1 x i32> %0, <vscale x 1 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv1i32_nxv1i32_nxv1i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 1 x i32> @llvm.riscv.vwaddu.w.nxv1i32.nxv1i16(
    <vscale x 1 x i32> %0,
    <vscale x 1 x i16> %1,
    i64 %2)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vwaddu.w.mask.nxv1i32.nxv1i16(
  <vscale x 1 x i32>,
  <vscale x 1 x i32>,
  <vscale x 1 x i16>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i32> @intrinsic_vwaddu.w_mask_wv_nxv1i32_nxv1i32_nxv1i16(<vscale x 1 x i32> %0, <vscale x 1 x i32> %1, <vscale x 1 x i16> %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv1i32_nxv1i32_nxv1i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 1 x i32> @llvm.riscv.vwaddu.w.mask.nxv1i32.nxv1i16(
    <vscale x 1 x i32> %0,
    <vscale x 1 x i32> %1,
    <vscale x 1 x i16> %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vwaddu.w.nxv2i32.nxv2i16(
  <vscale x 2 x i32>,
  <vscale x 2 x i16>,
  i64);

define <vscale x 2 x i32> @intrinsic_vwaddu.w_wv_nxv2i32_nxv2i32_nxv2i16(<vscale x 2 x i32> %0, <vscale x 2 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv2i32_nxv2i32_nxv2i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 2 x i32> @llvm.riscv.vwaddu.w.nxv2i32.nxv2i16(
    <vscale x 2 x i32> %0,
    <vscale x 2 x i16> %1,
    i64 %2)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vwaddu.w.mask.nxv2i32.nxv2i16(
  <vscale x 2 x i32>,
  <vscale x 2 x i32>,
  <vscale x 2 x i16>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i32> @intrinsic_vwaddu.w_mask_wv_nxv2i32_nxv2i32_nxv2i16(<vscale x 2 x i32> %0, <vscale x 2 x i32> %1, <vscale x 2 x i16> %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv2i32_nxv2i32_nxv2i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 2 x i32> @llvm.riscv.vwaddu.w.mask.nxv2i32.nxv2i16(
    <vscale x 2 x i32> %0,
    <vscale x 2 x i32> %1,
    <vscale x 2 x i16> %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vwaddu.w.nxv4i32.nxv4i16(
  <vscale x 4 x i32>,
  <vscale x 4 x i16>,
  i64);

define <vscale x 4 x i32> @intrinsic_vwaddu.w_wv_nxv4i32_nxv4i32_nxv4i16(<vscale x 4 x i32> %0, <vscale x 4 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv4i32_nxv4i32_nxv4i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 4 x i32> @llvm.riscv.vwaddu.w.nxv4i32.nxv4i16(
    <vscale x 4 x i32> %0,
    <vscale x 4 x i16> %1,
    i64 %2)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vwaddu.w.mask.nxv4i32.nxv4i16(
  <vscale x 4 x i32>,
  <vscale x 4 x i32>,
  <vscale x 4 x i16>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i32> @intrinsic_vwaddu.w_mask_wv_nxv4i32_nxv4i32_nxv4i16(<vscale x 4 x i32> %0, <vscale x 4 x i32> %1, <vscale x 4 x i16> %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv4i32_nxv4i32_nxv4i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 4 x i32> @llvm.riscv.vwaddu.w.mask.nxv4i32.nxv4i16(
    <vscale x 4 x i32> %0,
    <vscale x 4 x i32> %1,
    <vscale x 4 x i16> %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vwaddu.w.nxv8i32.nxv8i16(
  <vscale x 8 x i32>,
  <vscale x 8 x i16>,
  i64);

define <vscale x 8 x i32> @intrinsic_vwaddu.w_wv_nxv8i32_nxv8i32_nxv8i16(<vscale x 8 x i32> %0, <vscale x 8 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv8i32_nxv8i32_nxv8i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 8 x i32> @llvm.riscv.vwaddu.w.nxv8i32.nxv8i16(
    <vscale x 8 x i32> %0,
    <vscale x 8 x i16> %1,
    i64 %2)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vwaddu.w.mask.nxv8i32.nxv8i16(
  <vscale x 8 x i32>,
  <vscale x 8 x i32>,
  <vscale x 8 x i16>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i32> @intrinsic_vwaddu.w_mask_wv_nxv8i32_nxv8i32_nxv8i16(<vscale x 8 x i32> %0, <vscale x 8 x i32> %1, <vscale x 8 x i16> %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv8i32_nxv8i32_nxv8i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 8 x i32> @llvm.riscv.vwaddu.w.mask.nxv8i32.nxv8i16(
    <vscale x 8 x i32> %0,
    <vscale x 8 x i32> %1,
    <vscale x 8 x i16> %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vwaddu.w.nxv16i32.nxv16i16(
  <vscale x 16 x i32>,
  <vscale x 16 x i16>,
  i64);

define <vscale x 16 x i32> @intrinsic_vwaddu.w_wv_nxv16i32_nxv16i32_nxv16i16(<vscale x 16 x i32> %0, <vscale x 16 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv16i32_nxv16i32_nxv16i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 16 x i32> @llvm.riscv.vwaddu.w.nxv16i32.nxv16i16(
    <vscale x 16 x i32> %0,
    <vscale x 16 x i16> %1,
    i64 %2)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vwaddu.w.mask.nxv16i32.nxv16i16(
  <vscale x 16 x i32>,
  <vscale x 16 x i32>,
  <vscale x 16 x i16>,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i32> @intrinsic_vwaddu.w_mask_wv_nxv16i32_nxv16i32_nxv16i16(<vscale x 16 x i32> %0, <vscale x 16 x i32> %1, <vscale x 16 x i16> %2, <vscale x 16 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv16i32_nxv16i32_nxv16i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 16 x i32> @llvm.riscv.vwaddu.w.mask.nxv16i32.nxv16i16(
    <vscale x 16 x i32> %0,
    <vscale x 16 x i32> %1,
    <vscale x 16 x i16> %2,
    <vscale x 16 x i1> %3,
    i64 %4)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vwaddu.w.nxv1i64.nxv1i32(
  <vscale x 1 x i64>,
  <vscale x 1 x i32>,
  i64);

define <vscale x 1 x i64> @intrinsic_vwaddu.w_wv_nxv1i64_nxv1i64_nxv1i32(<vscale x 1 x i64> %0, <vscale x 1 x i32> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv1i64_nxv1i64_nxv1i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 1 x i64> @llvm.riscv.vwaddu.w.nxv1i64.nxv1i32(
    <vscale x 1 x i64> %0,
    <vscale x 1 x i32> %1,
    i64 %2)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vwaddu.w.mask.nxv1i64.nxv1i32(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  <vscale x 1 x i32>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i64> @intrinsic_vwaddu.w_mask_wv_nxv1i64_nxv1i64_nxv1i32(<vscale x 1 x i64> %0, <vscale x 1 x i64> %1, <vscale x 1 x i32> %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv1i64_nxv1i64_nxv1i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 1 x i64> @llvm.riscv.vwaddu.w.mask.nxv1i64.nxv1i32(
    <vscale x 1 x i64> %0,
    <vscale x 1 x i64> %1,
    <vscale x 1 x i32> %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vwaddu.w.nxv2i64.nxv2i32(
  <vscale x 2 x i64>,
  <vscale x 2 x i32>,
  i64);

define <vscale x 2 x i64> @intrinsic_vwaddu.w_wv_nxv2i64_nxv2i64_nxv2i32(<vscale x 2 x i64> %0, <vscale x 2 x i32> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv2i64_nxv2i64_nxv2i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 2 x i64> @llvm.riscv.vwaddu.w.nxv2i64.nxv2i32(
    <vscale x 2 x i64> %0,
    <vscale x 2 x i32> %1,
    i64 %2)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vwaddu.w.mask.nxv2i64.nxv2i32(
  <vscale x 2 x i64>,
  <vscale x 2 x i64>,
  <vscale x 2 x i32>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i64> @intrinsic_vwaddu.w_mask_wv_nxv2i64_nxv2i64_nxv2i32(<vscale x 2 x i64> %0, <vscale x 2 x i64> %1, <vscale x 2 x i32> %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv2i64_nxv2i64_nxv2i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 2 x i64> @llvm.riscv.vwaddu.w.mask.nxv2i64.nxv2i32(
    <vscale x 2 x i64> %0,
    <vscale x 2 x i64> %1,
    <vscale x 2 x i32> %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vwaddu.w.nxv4i64.nxv4i32(
  <vscale x 4 x i64>,
  <vscale x 4 x i32>,
  i64);

define <vscale x 4 x i64> @intrinsic_vwaddu.w_wv_nxv4i64_nxv4i64_nxv4i32(<vscale x 4 x i64> %0, <vscale x 4 x i32> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv4i64_nxv4i64_nxv4i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 4 x i64> @llvm.riscv.vwaddu.w.nxv4i64.nxv4i32(
    <vscale x 4 x i64> %0,
    <vscale x 4 x i32> %1,
    i64 %2)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vwaddu.w.mask.nxv4i64.nxv4i32(
  <vscale x 4 x i64>,
  <vscale x 4 x i64>,
  <vscale x 4 x i32>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i64> @intrinsic_vwaddu.w_mask_wv_nxv4i64_nxv4i64_nxv4i32(<vscale x 4 x i64> %0, <vscale x 4 x i64> %1, <vscale x 4 x i32> %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv4i64_nxv4i64_nxv4i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 4 x i64> @llvm.riscv.vwaddu.w.mask.nxv4i64.nxv4i32(
    <vscale x 4 x i64> %0,
    <vscale x 4 x i64> %1,
    <vscale x 4 x i32> %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vwaddu.w.nxv8i64.nxv8i32(
  <vscale x 8 x i64>,
  <vscale x 8 x i32>,
  i64);

define <vscale x 8 x i64> @intrinsic_vwaddu.w_wv_nxv8i64_nxv8i64_nxv8i32(<vscale x 8 x i64> %0, <vscale x 8 x i32> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wv_nxv8i64_nxv8i64_nxv8i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 8 x i64> @llvm.riscv.vwaddu.w.nxv8i64.nxv8i32(
    <vscale x 8 x i64> %0,
    <vscale x 8 x i32> %1,
    i64 %2)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vwaddu.w.mask.nxv8i64.nxv8i32(
  <vscale x 8 x i64>,
  <vscale x 8 x i64>,
  <vscale x 8 x i32>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i64> @intrinsic_vwaddu.w_mask_wv_nxv8i64_nxv8i64_nxv8i32(<vscale x 8 x i64> %0, <vscale x 8 x i64> %1, <vscale x 8 x i32> %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wv_nxv8i64_nxv8i64_nxv8i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,tu,mu
; CHECK:       vwaddu.wv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 8 x i64> @llvm.riscv.vwaddu.w.mask.nxv8i64.nxv8i32(
    <vscale x 8 x i64> %0,
    <vscale x 8 x i64> %1,
    <vscale x 8 x i32> %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 1 x i16> @llvm.riscv.vwaddu.w.nxv1i16.i8(
  <vscale x 1 x i16>,
  i8,
  i64);

define <vscale x 1 x i16> @intrinsic_vwaddu.w_wx_nxv1i16_nxv1i16_i8(<vscale x 1 x i16> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv1i16_nxv1i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 1 x i16> @llvm.riscv.vwaddu.w.nxv1i16.i8(
    <vscale x 1 x i16> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 1 x i16> @llvm.riscv.vwaddu.w.mask.nxv1i16.i8(
  <vscale x 1 x i16>,
  <vscale x 1 x i16>,
  i8,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i16> @intrinsic_vwaddu.w_mask_wx_nxv1i16_nxv1i16_i8(<vscale x 1 x i16> %0, <vscale x 1 x i16> %1, i8 %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv1i16_nxv1i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 1 x i16> @llvm.riscv.vwaddu.w.mask.nxv1i16.i8(
    <vscale x 1 x i16> %0,
    <vscale x 1 x i16> %1,
    i8 %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vwaddu.w.nxv2i16.i8(
  <vscale x 2 x i16>,
  i8,
  i64);

define <vscale x 2 x i16> @intrinsic_vwaddu.w_wx_nxv2i16_nxv2i16_i8(<vscale x 2 x i16> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv2i16_nxv2i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 2 x i16> @llvm.riscv.vwaddu.w.nxv2i16.i8(
    <vscale x 2 x i16> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 2 x i16> @llvm.riscv.vwaddu.w.mask.nxv2i16.i8(
  <vscale x 2 x i16>,
  <vscale x 2 x i16>,
  i8,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i16> @intrinsic_vwaddu.w_mask_wx_nxv2i16_nxv2i16_i8(<vscale x 2 x i16> %0, <vscale x 2 x i16> %1, i8 %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv2i16_nxv2i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 2 x i16> @llvm.riscv.vwaddu.w.mask.nxv2i16.i8(
    <vscale x 2 x i16> %0,
    <vscale x 2 x i16> %1,
    i8 %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vwaddu.w.nxv4i16.i8(
  <vscale x 4 x i16>,
  i8,
  i64);

define <vscale x 4 x i16> @intrinsic_vwaddu.w_wx_nxv4i16_nxv4i16_i8(<vscale x 4 x i16> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv4i16_nxv4i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 4 x i16> @llvm.riscv.vwaddu.w.nxv4i16.i8(
    <vscale x 4 x i16> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 4 x i16> @llvm.riscv.vwaddu.w.mask.nxv4i16.i8(
  <vscale x 4 x i16>,
  <vscale x 4 x i16>,
  i8,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i16> @intrinsic_vwaddu.w_mask_wx_nxv4i16_nxv4i16_i8(<vscale x 4 x i16> %0, <vscale x 4 x i16> %1, i8 %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv4i16_nxv4i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 4 x i16> @llvm.riscv.vwaddu.w.mask.nxv4i16.i8(
    <vscale x 4 x i16> %0,
    <vscale x 4 x i16> %1,
    i8 %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vwaddu.w.nxv8i16.i8(
  <vscale x 8 x i16>,
  i8,
  i64);

define <vscale x 8 x i16> @intrinsic_vwaddu.w_wx_nxv8i16_nxv8i16_i8(<vscale x 8 x i16> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv8i16_nxv8i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 8 x i16> @llvm.riscv.vwaddu.w.nxv8i16.i8(
    <vscale x 8 x i16> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 8 x i16> @llvm.riscv.vwaddu.w.mask.nxv8i16.i8(
  <vscale x 8 x i16>,
  <vscale x 8 x i16>,
  i8,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i16> @intrinsic_vwaddu.w_mask_wx_nxv8i16_nxv8i16_i8(<vscale x 8 x i16> %0, <vscale x 8 x i16> %1, i8 %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv8i16_nxv8i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 8 x i16> @llvm.riscv.vwaddu.w.mask.nxv8i16.i8(
    <vscale x 8 x i16> %0,
    <vscale x 8 x i16> %1,
    i8 %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vwaddu.w.nxv16i16.i8(
  <vscale x 16 x i16>,
  i8,
  i64);

define <vscale x 16 x i16> @intrinsic_vwaddu.w_wx_nxv16i16_nxv16i16_i8(<vscale x 16 x i16> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv16i16_nxv16i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 16 x i16> @llvm.riscv.vwaddu.w.nxv16i16.i8(
    <vscale x 16 x i16> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 16 x i16> @llvm.riscv.vwaddu.w.mask.nxv16i16.i8(
  <vscale x 16 x i16>,
  <vscale x 16 x i16>,
  i8,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i16> @intrinsic_vwaddu.w_mask_wx_nxv16i16_nxv16i16_i8(<vscale x 16 x i16> %0, <vscale x 16 x i16> %1, i8 %2, <vscale x 16 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv16i16_nxv16i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 16 x i16> @llvm.riscv.vwaddu.w.mask.nxv16i16.i8(
    <vscale x 16 x i16> %0,
    <vscale x 16 x i16> %1,
    i8 %2,
    <vscale x 16 x i1> %3,
    i64 %4)

  ret <vscale x 16 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vwaddu.w.nxv32i16.i8(
  <vscale x 32 x i16>,
  i8,
  i64);

define <vscale x 32 x i16> @intrinsic_vwaddu.w_wx_nxv32i16_nxv32i16_i8(<vscale x 32 x i16> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv32i16_nxv32i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 32 x i16> @llvm.riscv.vwaddu.w.nxv32i16.i8(
    <vscale x 32 x i16> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 32 x i16> %a
}

declare <vscale x 32 x i16> @llvm.riscv.vwaddu.w.mask.nxv32i16.i8(
  <vscale x 32 x i16>,
  <vscale x 32 x i16>,
  i8,
  <vscale x 32 x i1>,
  i64);

define <vscale x 32 x i16> @intrinsic_vwaddu.w_mask_wx_nxv32i16_nxv32i16_i8(<vscale x 32 x i16> %0, <vscale x 32 x i16> %1, i8 %2, <vscale x 32 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv32i16_nxv32i16_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 32 x i16> @llvm.riscv.vwaddu.w.mask.nxv32i16.i8(
    <vscale x 32 x i16> %0,
    <vscale x 32 x i16> %1,
    i8 %2,
    <vscale x 32 x i1> %3,
    i64 %4)

  ret <vscale x 32 x i16> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vwaddu.w.nxv1i32.i16(
  <vscale x 1 x i32>,
  i16,
  i64);

define <vscale x 1 x i32> @intrinsic_vwaddu.w_wx_nxv1i32_nxv1i32_i16(<vscale x 1 x i32> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv1i32_nxv1i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 1 x i32> @llvm.riscv.vwaddu.w.nxv1i32.i16(
    <vscale x 1 x i32> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 1 x i32> @llvm.riscv.vwaddu.w.mask.nxv1i32.i16(
  <vscale x 1 x i32>,
  <vscale x 1 x i32>,
  i16,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i32> @intrinsic_vwaddu.w_mask_wx_nxv1i32_nxv1i32_i16(<vscale x 1 x i32> %0, <vscale x 1 x i32> %1, i16 %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv1i32_nxv1i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 1 x i32> @llvm.riscv.vwaddu.w.mask.nxv1i32.i16(
    <vscale x 1 x i32> %0,
    <vscale x 1 x i32> %1,
    i16 %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vwaddu.w.nxv2i32.i16(
  <vscale x 2 x i32>,
  i16,
  i64);

define <vscale x 2 x i32> @intrinsic_vwaddu.w_wx_nxv2i32_nxv2i32_i16(<vscale x 2 x i32> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv2i32_nxv2i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 2 x i32> @llvm.riscv.vwaddu.w.nxv2i32.i16(
    <vscale x 2 x i32> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 2 x i32> @llvm.riscv.vwaddu.w.mask.nxv2i32.i16(
  <vscale x 2 x i32>,
  <vscale x 2 x i32>,
  i16,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i32> @intrinsic_vwaddu.w_mask_wx_nxv2i32_nxv2i32_i16(<vscale x 2 x i32> %0, <vscale x 2 x i32> %1, i16 %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv2i32_nxv2i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 2 x i32> @llvm.riscv.vwaddu.w.mask.nxv2i32.i16(
    <vscale x 2 x i32> %0,
    <vscale x 2 x i32> %1,
    i16 %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vwaddu.w.nxv4i32.i16(
  <vscale x 4 x i32>,
  i16,
  i64);

define <vscale x 4 x i32> @intrinsic_vwaddu.w_wx_nxv4i32_nxv4i32_i16(<vscale x 4 x i32> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv4i32_nxv4i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 4 x i32> @llvm.riscv.vwaddu.w.nxv4i32.i16(
    <vscale x 4 x i32> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 4 x i32> @llvm.riscv.vwaddu.w.mask.nxv4i32.i16(
  <vscale x 4 x i32>,
  <vscale x 4 x i32>,
  i16,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i32> @intrinsic_vwaddu.w_mask_wx_nxv4i32_nxv4i32_i16(<vscale x 4 x i32> %0, <vscale x 4 x i32> %1, i16 %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv4i32_nxv4i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 4 x i32> @llvm.riscv.vwaddu.w.mask.nxv4i32.i16(
    <vscale x 4 x i32> %0,
    <vscale x 4 x i32> %1,
    i16 %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vwaddu.w.nxv8i32.i16(
  <vscale x 8 x i32>,
  i16,
  i64);

define <vscale x 8 x i32> @intrinsic_vwaddu.w_wx_nxv8i32_nxv8i32_i16(<vscale x 8 x i32> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv8i32_nxv8i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 8 x i32> @llvm.riscv.vwaddu.w.nxv8i32.i16(
    <vscale x 8 x i32> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 8 x i32> @llvm.riscv.vwaddu.w.mask.nxv8i32.i16(
  <vscale x 8 x i32>,
  <vscale x 8 x i32>,
  i16,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i32> @intrinsic_vwaddu.w_mask_wx_nxv8i32_nxv8i32_i16(<vscale x 8 x i32> %0, <vscale x 8 x i32> %1, i16 %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv8i32_nxv8i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 8 x i32> @llvm.riscv.vwaddu.w.mask.nxv8i32.i16(
    <vscale x 8 x i32> %0,
    <vscale x 8 x i32> %1,
    i16 %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vwaddu.w.nxv16i32.i16(
  <vscale x 16 x i32>,
  i16,
  i64);

define <vscale x 16 x i32> @intrinsic_vwaddu.w_wx_nxv16i32_nxv16i32_i16(<vscale x 16 x i32> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv16i32_nxv16i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 16 x i32> @llvm.riscv.vwaddu.w.nxv16i32.i16(
    <vscale x 16 x i32> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 16 x i32> @llvm.riscv.vwaddu.w.mask.nxv16i32.i16(
  <vscale x 16 x i32>,
  <vscale x 16 x i32>,
  i16,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i32> @intrinsic_vwaddu.w_mask_wx_nxv16i32_nxv16i32_i16(<vscale x 16 x i32> %0, <vscale x 16 x i32> %1, i16 %2, <vscale x 16 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv16i32_nxv16i32_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 16 x i32> @llvm.riscv.vwaddu.w.mask.nxv16i32.i16(
    <vscale x 16 x i32> %0,
    <vscale x 16 x i32> %1,
    i16 %2,
    <vscale x 16 x i1> %3,
    i64 %4)

  ret <vscale x 16 x i32> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vwaddu.w.nxv1i64.i32(
  <vscale x 1 x i64>,
  i32,
  i64);

define <vscale x 1 x i64> @intrinsic_vwaddu.w_wx_nxv1i64_nxv1i64_i32(<vscale x 1 x i64> %0, i32 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv1i64_nxv1i64_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 1 x i64> @llvm.riscv.vwaddu.w.nxv1i64.i32(
    <vscale x 1 x i64> %0,
    i32 %1,
    i64 %2)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 1 x i64> @llvm.riscv.vwaddu.w.mask.nxv1i64.i32(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  i32,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i64> @intrinsic_vwaddu.w_mask_wx_nxv1i64_nxv1i64_i32(<vscale x 1 x i64> %0, <vscale x 1 x i64> %1, i32 %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv1i64_nxv1i64_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 1 x i64> @llvm.riscv.vwaddu.w.mask.nxv1i64.i32(
    <vscale x 1 x i64> %0,
    <vscale x 1 x i64> %1,
    i32 %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vwaddu.w.nxv2i64.i32(
  <vscale x 2 x i64>,
  i32,
  i64);

define <vscale x 2 x i64> @intrinsic_vwaddu.w_wx_nxv2i64_nxv2i64_i32(<vscale x 2 x i64> %0, i32 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv2i64_nxv2i64_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 2 x i64> @llvm.riscv.vwaddu.w.nxv2i64.i32(
    <vscale x 2 x i64> %0,
    i32 %1,
    i64 %2)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 2 x i64> @llvm.riscv.vwaddu.w.mask.nxv2i64.i32(
  <vscale x 2 x i64>,
  <vscale x 2 x i64>,
  i32,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i64> @intrinsic_vwaddu.w_mask_wx_nxv2i64_nxv2i64_i32(<vscale x 2 x i64> %0, <vscale x 2 x i64> %1, i32 %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv2i64_nxv2i64_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 2 x i64> @llvm.riscv.vwaddu.w.mask.nxv2i64.i32(
    <vscale x 2 x i64> %0,
    <vscale x 2 x i64> %1,
    i32 %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vwaddu.w.nxv4i64.i32(
  <vscale x 4 x i64>,
  i32,
  i64);

define <vscale x 4 x i64> @intrinsic_vwaddu.w_wx_nxv4i64_nxv4i64_i32(<vscale x 4 x i64> %0, i32 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv4i64_nxv4i64_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 4 x i64> @llvm.riscv.vwaddu.w.nxv4i64.i32(
    <vscale x 4 x i64> %0,
    i32 %1,
    i64 %2)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 4 x i64> @llvm.riscv.vwaddu.w.mask.nxv4i64.i32(
  <vscale x 4 x i64>,
  <vscale x 4 x i64>,
  i32,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i64> @intrinsic_vwaddu.w_mask_wx_nxv4i64_nxv4i64_i32(<vscale x 4 x i64> %0, <vscale x 4 x i64> %1, i32 %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv4i64_nxv4i64_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 4 x i64> @llvm.riscv.vwaddu.w.mask.nxv4i64.i32(
    <vscale x 4 x i64> %0,
    <vscale x 4 x i64> %1,
    i32 %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vwaddu.w.nxv8i64.i32(
  <vscale x 8 x i64>,
  i32,
  i64);

define <vscale x 8 x i64> @intrinsic_vwaddu.w_wx_nxv8i64_nxv8i64_i32(<vscale x 8 x i64> %0, i32 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_wx_nxv8i64_nxv8i64_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 8 x i64> @llvm.riscv.vwaddu.w.nxv8i64.i32(
    <vscale x 8 x i64> %0,
    i32 %1,
    i64 %2)

  ret <vscale x 8 x i64> %a
}

declare <vscale x 8 x i64> @llvm.riscv.vwaddu.w.mask.nxv8i64.i32(
  <vscale x 8 x i64>,
  <vscale x 8 x i64>,
  i32,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i64> @intrinsic_vwaddu.w_mask_wx_nxv8i64_nxv8i64_i32(<vscale x 8 x i64> %0, <vscale x 8 x i64> %1, i32 %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vwaddu.w_mask_wx_nxv8i64_nxv8i64_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,tu,mu
; CHECK:       vwaddu.wx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 8 x i64> @llvm.riscv.vwaddu.w.mask.nxv8i64.i32(
    <vscale x 8 x i64> %0,
    <vscale x 8 x i64> %1,
    i32 %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x i64> %a
}
