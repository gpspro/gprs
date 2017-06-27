#ifndef GPRS_CMD_H
#define GPRS_CMD_H

// Output Set / Return Codes
#define CMD_OUTPUT_SET_SUCCESS            0
#define CMD_OUTPUT_SET_INVALID_OUTPUT     1
#define CMD_OUTPUT_SET_INVALID_MODE       2
#define CMD_OUTPUT_SET_UNCHANGED          3

// Output Set / Rule Return Codes
#define CMD_OUTPUT_SET_RULE_SUCCESS       4
#define CMD_OUTPUT_SET_RULE_ERROR         5
#define CMD_OUTPUT_SET_RULE_UNCHANGED     6

// Output Set / Modes
#define CMD_OUTPUT_MODE_OFF               0
#define CMD_OUTPUT_MODE_ON                1
#define CMD_OUTPUT_MODE_OFF_RULE_AND      2
#define CMD_OUTPUT_MODE_ON_RULE_AND       3

// Output Set / Max Rules
#define CMD_OUTPUT_RULES_MAX              10

// Output Set / Rule Codes
#define CMD_OUTPUT_RULE_NONE              0
#define CMD_OUTPUT_RULE_GPS_SPEED         1
#define CMD_OUTPUT_RULE_ACC_MOVEMENT      2
#define CMD_OUTPUT_RULE_ACC_ORIENT        3
#define CMD_OUTPUT_RULE_INT_VOLTAGE       4
#define CMD_OUTPUT_RULE_EXT_VOLTAGE       6
#define CMD_OUTPUT_RULE_INPUT_1           10
#define CMD_OUTPUT_RULE_INPUT_2           11
#define CMD_OUTPUT_RULE_INPUT_3           12
#define CMD_OUTPUT_RULE_OUTPUT_1          14
#define CMD_OUTPUT_RULE_OUTPUT_2          15
#define CMD_OUTPUT_RULE_OUTPUT_3          16
#define CMD_OUTPUT_RULE_ANALOG_1_LEVEL    18
#define CMD_OUTPUT_RULE_ANALOG_2_LEVEL    19
#define CMD_OUTPUT_RULE_ANALOG_1_VOLTAGE  20
#define CMD_OUTPUT_RULE_ANALOG_2_VOLTAGE  21
#define CMD_OUTPUT_RULE_TEMPERATURE       22

// Output Set / Rule Condition Codes
#define CMD_OUTPUT_RULE_COND_EQ           0
#define CMD_OUTPUT_RULE_COND_NOTEQ        1
#define CMD_OUTPUT_RULE_COND_LT           2
#define CMD_OUTPUT_RULE_COND_GT           3
#define CMD_OUTPUT_RULE_COND_LTEQ         4
#define CMD_OUTPUT_RULE_COND_GTEQ         5
#define CMD_OUTPUT_RULE_COND_MIN          6
#define CMD_OUTPUT_RULE_COND_MAX          7

// Output Set / Rule Return Codes
#define CMD_OUTPUT_RULE_SUCCESS           0
#define CMD_OUTPUT_RULE_COND_NOT_MET      1
#define CMD_OUTPUT_RULE_INVALID_CODE      2
#define CMD_OUTPUT_RULE_INVALID_COND      3
#define CMD_OUTPUT_RULE_INVALID_VALUE     4
#define CMD_OUTPUT_RULE_COND_NO_SUPPORT   5

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
#define GPRS_CMD_DIAG_GPS_FIX_MASK    0x03  << GPRS_CMD_DIAG_GPS_FIX_OFFSET
#define GPRS_CMD_DIAG_GPS_SAT_OFFSET	0x02
#define GPRS_CMD_DIAG_GPS_SAT_MASK	  0x3F << GPRS_CMD_DIAG_GPS_SAT_OFFSET

// Diagnostic V2 / Inputs, Outputs, Analogs
#define GPRS_CMD_DIAG_INPUTS_MAX      4
#define GPRS_CMD_DIAG_OUTPUTS_MAX     4
#define GPRS_CMD_DIAG_ANALOGS_MAX     8

typedef struct {
  uint32_t  txn_id;
  uint32_t  timeout;
  uint32_t  reset;
  uint32_t  max;
  uint8_t   function;
} cmd_req_fc_pump_t;

typedef struct {
  uint8_t   analog;
  uint8_t   format;
  uint8_t   action;
} cmd_req_analog_ext_t;

typedef struct {
  uint8_t   code;
  uint8_t   cond;
  uint32_t  value;
} output_set_rule_t;

typedef struct {
  uint8_t   output;
  uint8_t   mode;
  uint8_t   rule_count;
  output_set_rule_t rules[CMD_OUTPUT_RULES_MAX];
} cmd_req_output_set_t;

typedef struct {
  uint8_t   version_major;
  uint8_t   version_minor;
  uint8_t   version_revision;

  uint8_t   modem_status;
  uint8_t   modem_signal;

  uint8_t   gps_status;

  uint16_t  int_voltage;
  uint16_t  ext_voltage;
} cmd_resp_diag_t;

typedef struct {
  uint8_t   version_major;
  uint8_t   version_minor;
  uint8_t   version_revision;

  uint8_t   modem_status;
  uint8_t   modem_signal;

  uint8_t   gps_fix;
  uint8_t   gps_satellites;

  bool      has_int_voltage;
  uint16_t  int_voltage;

  bool      has_ext_voltage;
  uint16_t  ext_voltage;

  bool      has_temperature;
  uint8_t   temperature;

  bool      input_present[GPRS_CMD_DIAG_INPUTS_MAX];
  uint8_t   input_values[GPRS_CMD_DIAG_INPUTS_MAX];

  bool      output_present[GPRS_CMD_DIAG_OUTPUTS_MAX];
  uint8_t   output_values[GPRS_CMD_DIAG_OUTPUTS_MAX];

  bool      analog_present[GPRS_CMD_DIAG_ANALOGS_MAX];
  uint16_t  analog_values[GPRS_CMD_DIAG_ANALOGS_MAX];
} cmd_resp_diag2_t;

typedef union {
  uint8_t               sendval_request;
  uint8_t               param_request;
  cmd_req_fc_pump_t     req_fc_pump;
  cmd_req_analog_ext_t  req_analog_ext;
  uint8_t               req_analog_get;
  uint8_t               req_input_get;
  uint8_t               req_output_get;
  cmd_req_output_set_t  req_output_set;

  cmd_resp_diag_t       diag;
  cmd_resp_diag2_t      diag2;
} cmd_data_t;

typedef struct {
  uint8_t   type;
  uint8_t   ref;
  uint8_t   code;
} cmd_headers_t;

typedef struct {
  cmd_headers_t headers;
  cmd_data_t    data;
} cmd_t;

extern void cmd_parse(uint8_t * buf, int size, cmd_t * cmd);
extern void cmd_print(cmd_t * cmd);

#endif
