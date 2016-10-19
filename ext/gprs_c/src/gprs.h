#ifndef GPRS_H
#define GPRS_H

#include <stdint.h>

#define GPRS_8BIT_DIFF              0x80
#define GPRS_8BIT_MAX               0xFF
#define GPRS_16BIT_DIFF             0x8000
#define GPRS_16BIT_MAX              0xFFFF
#define GPRS_24BIT_DIFF             0x800000
#define GPRS_24BIT_MAX              0xFFFFFF

#define GPRS_RC_SUCCESS             0
#define GPRS_RC_ERROR_CRC           1
#define GPRS_RC_ERROR_INVALID       2

#define GPRS_PACKET_UNKNOWN         0
#define GPRS_PACKET_REPORT          1
#define GPRS_PACKET_COMMAND         2
#define GPRS_PACKET_ACK             3
#define GPRS_PACKET_PROGRAM         4

extern uint8_t  gprs_read_byte(uint8_t * buf, int * idx);
extern uint32_t gprs_read_bytes(uint8_t * buf, int * idx, int size);
extern int gprs_to_signed(uint32_t uval);

extern int      gprs_packet_type(uint8_t * buf, int size);
extern int      gprs_preprocess(uint8_t * packet, int * size, bool verbose);

#endif
