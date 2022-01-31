/*
 * Copyright (c) Yann Collet, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under both the BSD-style license (found in the
 * LICENSE file in the root directory of this source tree) and the GPLv2 (found
 * in the COPYING file in the root directory of this source tree).
 * You may select, at your option, one of the above-listed licenses.
 */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "zstd.h"

int main(int argc, char* argv[]) {
  ZSTD_CCtx* cctx = ZSTD_createCCtx();
  char *src = malloc(1024);
  char *dst = malloc(1024);
  size_t ret;
  ZSTD_inBuffer ibuf = { .src = src, .pos = 0, .size = 1024 };
  ZSTD_outBuffer obuf = { .dst = dst, .pos = 0, .size = 1024 };

  (void)argc;
  (void)argv;

  assert(cctx != NULL);
  assert(src != NULL);
  assert(dst != NULL);

  fprintf(stderr, "ZSTD_compressStream2() #1\n");

  ret = ZSTD_compressStream2(cctx, &obuf, &ibuf, ZSTD_e_continue);

  assert(!ZSTD_isError(ret));

  fprintf(stderr, "ZSTD_compressStream2() #2\n");

  ret = ZSTD_compressStream2(cctx, &obuf, &ibuf, ZSTD_e_end);

  assert(!ZSTD_isError(ret));

  fprintf(stderr, "ZSTD_freeCCtx() #1\n");

  ZSTD_freeCCtx(cctx);

  return 0;
}
