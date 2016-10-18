#ifndef GPRS_REPORT_H
#define GPRS_REPORT_H

#include <stdint.h>

#define REPORT_TYPE_POSITION              0     // Position
#define REPORT_TYPE_ALPHANUM_MSG          1     // No idea what this is for
#define REPORT_TYPE_ALPHANUM_MSG_SPEC     2     // No idea what this is for
#define REPORT_TYPE_CODED_POS             3     // Position with alert
#define REPORT_TYPE_QUERY_ANS             4     // Answer to query
#define REPORT_TYPE_COMP_POS              6     // Compressed positions
#define REPORT_TYPE_ACKNOWLEDGE           7     // ACK to messsage from Gateway
#define REPORT_TYPE_EXTENDED_DATA         8     // Extended report data with code
#define REPORT_TYPE_CODED_COMP_POS        9     // Compressed positions with alert

#define REPORT_DATA_TYPE_DRIVER_KEY       0x01
#define REPORT_DATA_TYPE_ADDITIONAL_IO    0x02
#define REPORT_DATA_TYPE_PGT_INFO         0x03
#define REPORT_DATA_TYPE_RPE_BMU_INFO     0x04
#define REPORT_DATA_TYPE_TK_TEMPS         0xC1
#define REPORT_DATA_TYPE_TK_TIMES         0xC3
#define REPORT_DATA_TYPE_TK_ALARMS        0xC5
#define REPORT_DATA_TYPE_CARR_TEMPS       0xC0
#define REPORT_DATA_TYPE_CARR_TIMES       0xC2
#define REPORT_DATA_TYPE_CARR_ALARMS      0xC4
#define REPORT_DATA_TYPE_CARR_PRETRIP     0xC6
#define REPORT_DATA_TYPE_HART_VALUES      0xA0
#define REPORT_DATA_TYPE_FC_TXN_COMPLETE  0xF0

#define report_has_code(type)           (type == REPORT_TYPE_CODED_POS) || \
                                        (type == REPORT_TYPE_EXTENDED_DATA) || \
                                        (type == REPORT_TYPE_CODED_COMP_POS)

typedef struct  {
  bool      has_int_voltage;
  bool      has_ext_voltage;
  bool      has_adc_input_1;
  bool      has_adc_input_2;
  bool      has_input_3;
  bool      has_output_3;
  bool      has_orientation;

  uint16_t  int_voltage;
  uint16_t  ext_voltage;
  uint8_t   adc_input_1;
  uint8_t   adc_input_2;
  uint8_t   input_3;
  uint8_t   output_3;
  uint8_t   orientation;
} additional_io_t;

typedef struct {
  uint32_t  txn_id;
  uint32_t  ticks;
} fc_txn_t;

typedef union {
  additional_io_t additional_io;
  fc_txn_t        fc_txn;
} ext_t;

// Basic report structure (grouped by byte fields)
typedef struct {
  // Ref
  uint8_t   ref;
  uint8_t   has_cell;
  uint8_t   has_gps;

  // Type
  uint8_t   type;
  uint8_t   has_modsts;
  uint8_t   has_temp;
  uint8_t   id_len;

  // IO
  uint8_t   input_1;
  uint8_t   input_2;
  uint8_t   output_1;
  uint8_t   output_2;
  bool      lat_south;
  bool      lon_west;
  uint8_t   has_cog;
  uint8_t   has_lac;

  // Time
  uint32_t  time;

  // Device ID
  uint32_t  device_id;

  // Latitude
  uint32_t  lat;
  uint8_t   gps_invalid;

  // Longitude
  uint32_t  lon;

  // Speed
  uint8_t   speed;

  // COG
  uint8_t   cog;

  // Code
  uint8_t   code;

  // Modsts
  uint8_t   modsts;

  // Temp
  uint8_t   temp;

  // Cell Info
  uint16_t  cell_id;
  uint8_t   signal;

  // Lac
  uint16_t  lac;

  // Report Extended Data
  uint8_t   ext_type;
  ext_t     ext;
} report_t;

// Conversion functions
extern void   report_lattos(double lat, uint32_t * secs, bool * south);
extern void   report_lontos(double lon, uint32_t * secs, bool * west);
extern double report_stolat(uint32_t secs, bool south);
extern double report_stolon(uint32_t secs, bool west);
extern struct tm report_stotm(uint32_t secs);
extern double report_cvtov(uint16_t cV);

extern void report_print(report_t report);
extern int  report_parse(uint8_t * buf, int size, report_t * reports);

#endif
