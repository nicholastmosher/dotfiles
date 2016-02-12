/**
 * The following code was written by Zed A. Shaw and can be found at
 * http://c.learncodethehardway.org/book/ex20.html.
 */
#ifndef __dbg_h__
#define __dbg_h__

#include <stdio.h>
#include <errno.h>
#include <string.h>

#define clean_errno() (errno == 0 ? "None" : strerror(errno))

//If DOLOG is defined, print log and debug messages.
#ifdef DOLOG
#define log_err(M, ...) fprintf(stderr, "[ERROR] (%s:%d: errno %s) " M "\n", __FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)
#define log_warn(M, ...) fprintf(stderr, "[WARN] (%s:%d: errno %s) " M "\n", __FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)
#define log_info(M, ...) fprintf(stderr, "[INFO] (%s:%d) " M "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#define log_info_or_printf(M, ...) log_info(M, ##__VA_ARGS__)
#else
#define log_err(M, ...)
#define log_warn(M, ...)
#define log_info(M, ...)
#define log_info_or_printf(M, ...) printf(M, ##__VA_ARGS__)
#endif

//If DEBUG is defined, print debug messages.
#ifdef DEBUG
#define debug(M, ...) fprintf(stderr, "DEBUG %s:%d: " M "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#else
#define debug(M, ...)
#endif

#define check(A, M, ...) if(!(A)) { log_err(M, ##__VA_ARGS__); errno=0; goto error; }
#define sentinel(M, ...) { log_err(M, ##__VA_ARGS__); errno=0; goto error; }
#define check_mem(A) check((A), "Out of memory.")
#define check_debug(A, M, ...) if(!(A)) { debug(M, ##__VA_ARGS__); errno=0; goto error; }

#endif
