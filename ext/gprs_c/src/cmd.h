#ifndef GPRS_CMD_H
#define GPRS_CMD_H


typedef struct {
  uint8_t   version_major;
  uint8_t   version_minor;
  uint8_t   version_revision;

  uint8_t   modem_status;
  uint8_t   modem_signal;

  uint8_t   gps_status;

  uint16_t  int_voltage;
  uint16_t  ext_voltage;
} cmd_diag_t;

typedef struct {
  uint8_t   type;
  uint8_t   ref;
  uint8_t   code;
} cmd_headers_t;

typedef union {
  cmd_diag_t    diag;
} cmd_data_t;

typedef struct {
  cmd_headers_t headers;
  cmd_data_t    data;
} cmd_t;

// Diagnostic V2 / Mask Byte
#define GPRS_CMD_DIAG_INT_OFFSET			0x00
#define GPRS_CMD_DIAG_INT_MASK				0x01 	<< GPRS_CMD_DIAG_INT_OFFSET
#define GPRS_CMD_DIAG_EXT_OFFSET			0x01
#define GPRS_CMD_DIAG_EXT_MASK				0x01 	<< GPRS_CMD_DIAG_EXT_OFFSET
#define GPRS_CMD_DIAG_TEMP_OFFSET			0x02
#define GPRS_CMD_DIAG_TEMP_MASK				0x01 	<< GPRS_CMD_DIAG_TEMP_OFFSET
#define GPRS_CMD_DIAG_CURR_OFFSET			0x03
#define GPRS_CMD_DIAG_CURR_MASK				0x01 	<< GPRS_CMD_DIAG_CURR_OFFSET
#define GPRS_CMD_DIAG_IO_OFFSET       0x04
#define GPRS_CMD_DIAG_IO_MASK         0x01  << GPRS_CMD_DIAG_IO_OFFSET
#define GPRS_CMD_DIAG_ANALOG_OFFSET   0x05
#define GPRS_CMD_DIAG_ANALOG_MASK     0x01  << GPRS_CMD_DIAG_ANALOG_OFFSET

// Diagnostic V2 / GPS Status Byte
#define GPRS_CMD_DIAG_GPS_FIX_OFFSET	0x00
#define GPRS_CMD_DIAG_GPS_SAT_OFFSET	0x02

extern void cmd_parse(uint8_t * buf, int size, cmd_t * cmd);
extern void cmd_print(cmd_t * cmd);

#endif
