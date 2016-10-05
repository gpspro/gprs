#ifndef GPRS_H
#define GPRS_H

#include <stdint.h>

#define GPRS_RC_SUCCESS        0
#define GPRS_RC_ERROR_CRC      1
#define GPRS_RC_ERROR_INVALID  2

extern uint8_t  gprs_read_byte(uint8_t * buf, int * idx);
extern uint32_t gprs_read_bytes(uint8_t * buf, int * idx, int size);

extern int      gprs_preprocess(uint8_t * packet, int * size);

#endif