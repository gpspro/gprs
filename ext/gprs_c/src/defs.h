#ifndef GPRS_DEFS_H
#define GPRS_DEFS_H

#define ALERT_POSITION_REPORT           0x0
#define ALERT_PANIC_ALARM_TRIGGERED     0x1
#define ALERT_DOOR_OPENED               0x2
#define ALERT_UNIT_PARKED               0x3
#define ALERT_COMMAND_ACK               0x4
#define ALERT_UNIT_STOPPED              0x5
#define ALERT_DOOR_CLOSED               0x6
#define ALERT_POWER_DISCONNECT          0x7
#define ALERT_POWER_CONNECT             0x8
#define ALERT_CAR_BATT_DISCHARGED       0x9
#define ALERT_INT_BATT_CHARGED          0xA
#define ALERT_CAR_BATT_CHARGED          0xB
#define ALERT_INT_BATT_DISCHARGED       0xC
#define ALERT_SYSTEM_STARTED            0xD
#define ALERT_ENGINE_ON                 0xE
#define ALERT_ENGINE_OFF                0xF
#define ALERT_HOOD_TRUNK_OPEN           0x10
#define ALERT_SHOCK_WARNING             0x11
#define ALERT_SHOCK_ALARM               0x12
#define ALERT_HIGH_VOLTAGE              0x13
#define ALERT_TILT_ALERT                0x14
#define ALERT_PARK_VALET_FENCE          0x15
#define ALERT_UNAUTHORIZED_IGNITION     0x16
#define ALERT_GPS_TAMPERING             0x17
#define ALERT_GPS_INVALID_FIX           0x18
#define ALERT_VEHICLE_VESSEL_INTRUSION  0x19
#define ALERT_BILGE_PUMP_ON             0x1A
#define ALERT_BILGE_PUMP_OFF            0x1B
#define ALERT_CRASH_DETECTED            0x1C
#define ALERT_SIREN_ACTIVE              0x1D
#define ALERT_HARD_STOP_DETECTED        0x1E
#define ALERT_TEMPERATURE_HIGH          0x1F
#define ALERT_TEMPERATURE_LOW           0x20
#define ALERT_DRIVER_KEY_READ           0x21
#define ALERT_FC_TXN_COMPLETE           0x22
#define ALERT_PTO_ON                    0x23
#define ALERT_PTO_OFF                   0x24

#define GPRS_MIN_CODE                   ALERT_POSITION_REPORT
#define GPRS_MAX_CODE                   ALERT_PTO_OFF

/**
 * \name These are the common codes used for reporting, programming,
 * receiving and sending commands.
 */
//! @{
#define GPRS_SOP        0x28
#define GPRS_EOP        0x29
#define GPRS_DLE        0x10
//! @}

#define gprs_is_status(code)  (code == ALERT_UNIT_PARKED ||     \
                               code == ALERT_GPS_INVALID_FIX)

#define gprs_is_alert(code)   (code != ALERT_POSITION_REPORT && \
                               code != ALERT_COMMAND_ACK &&     \
                               code != ALERT_UNIT_PARKED &&     \
                               code != ALERT_GPS_INVALID_FIX)

#define gprs_is_red_alert(code) (code == ALERT_PANIC_ALARM_TRIGGERED ||     \
                                 code == ALERT_DOOR_OPENED ||               \
                                 code == ALERT_POWER_DISCONNECT ||          \
                                 code == ALERT_CAR_BATT_DISCHARGED ||       \
                                 code == ALERT_HOOD_TRUNK_OPEN ||           \
                                 code == ALERT_SHOCK_ALARM ||               \
                                 code == ALERT_HIGH_VOLTAGE ||              \
                                 code == ALERT_TILT_ALERT ||                \
                                 code == ALERT_PARK_VALET_FENCE ||          \
                                 code == ALERT_UNAUTHORIZED_IGNITION ||     \
                                 code == ALERT_GPS_TAMPERING ||             \
                                 code == ALERT_VEHICLE_VESSEL_INTRUSION ||  \
                                 code == ALERT_CRASH_DETECTED ||            \
                                 code == ALERT_SIREN_ACTIVE)

#define gprs_is_escape(byte)  (byte == GPRS_SOP ||          \
                               byte == GPRS_EOP ||          \
                               byte == GPRS_DLE ||          \
                               byte == ENTER ||             \
                               byte == LINEFEED ||          \
                               byte == BACKSPACE )

#define CMD_PROG_CODE_START             0x1
#define CMD_PROG_CODE_DATA              0x2
#define CMD_PROG_CODE_CANCEL            0x3
#define CMD_PROG_CODE_RESUME            0x4
#define CMD_PROG_CODE_END               0x5
#define CMD_PROG_CODE_REQ_FW            0x6
#define CMD_PROG_CODE_REQ_FW_INFO       0x7

#define GPRS_MSG_TYPE_POSITION          0
#define GPRS_MSG_TYPE_ALPHANUM_MSG      1
#define GPRS_MSG_TYPE_ALPHANUM_MSG_SPEC 2
#define GPRS_MSG_TYPE_CODED_NUM_MSG     3
#define GPRS_MSG_TYPE_ANSWER_TO_QUERY   4
#define GPRS_MSG_TYPE_POSITIONS_COMP    6
#define GPRS_MSG_TYPE_ACKNOWLEDGE       7
#define GPRS_MSG_TYPE_EXT_REPORT        8
#define GPRS_MSG_TYPE_CODED_POS_COMP    9

#define GPRS_REPORT_MIN_SIZE            8
#define GPRS_PACKET_MIN_SIZE            4
#define GPRS_PACKET_MAX_SIZE            10240

// Commands that exceed the report min size (above)
#define gprs_is_cmd_large(code)   (code == CMD_PARAM_TYPE_GSM_APN || \
                                   code == CMD_PARAM_TYPE_GSM_IP_PORT || \
                                   code == CMD_PARAM_TYPE_CDMA_IP_PORT || \
                                   code == CMD_PARAM_TYPE_ANALOG_EXT || \
                                   code == CMD_PARAM_TYPE_ANALOG_GET || \
                                   code == CMD_PARAM_TYPE_OUTPUT_SCH_LST || \
                                   code == CMD_VAL_REMOTE_DIAG || \
                                   code == CMD_VAL_REMOTE_DIAG2 || \
                                   code == CMD_PARAM_TYPE_FC_PUMP || \
                                   code == CMD_PROG_CODE_REQ_FW_INFO)


#define gprs_is_report_type(type) (type == GPRS_MSG_TYPE_POSITION || \
                                   type == GPRS_MSG_TYPE_CODED_NUM_MSG || \
                                   type == GPRS_MSG_TYPE_POSITIONS_COMP || \
                                   type == GPRS_MSG_TYPE_EXT_REPORT || \
                                   type == GPRS_MSG_TYPE_CODED_POS_COMP)

#define gprs_is_program_code(code)(code == CMD_PROG_CODE_START            || \
                                   code == CMD_PROG_CODE_DATA             || \
                                   code == CMD_PROG_CODE_CANCEL           || \
                                   code == CMD_PROG_CODE_RESUME           || \
                                   code == CMD_PROG_CODE_END              || \
                                   code == CMD_PROG_CODE_REQ_FW           || \
                                   code == CMD_PROG_CODE_REQ_FW_INFO)

#define gprs_is_config_msg(code)  (code == CMD_PARAM_TYPE_POSITION        || \
                                   code == CMD_PARAM_TYPE_MOVE_FREQ       || \
                                   code == CMD_PARAM_TYPE_SENDVAL         || \
                                   code == CMD_PARAM_TYPE_REQUEST_PARAM   || \
                                   code == CMD_PARAM_TYPE_CELL_INFO       || \
                                   code == CMD_PARAM_TYPE_SEND_FREQ       || \
                                   code == CMD_PARAM_TYPE_STOP_FREQ       || \
                                   code == CMD_PARAM_TYPE_TURN_DETECT     || \
                                   code == CMD_PARAM_TYPE_TURN_ANGLE      || \
                                   code == CMD_PARAM_TYPE_GSM_APN         || \
                                   code == CMD_PARAM_TYPE_GSM_IP_PORT     || \
                                   code == CMD_PARAM_TYPE_FC_PUMP         || \
                                   code == CMD_PARAM_TYPE_OUTPUT_SCH_GET  || \
                                   code == CMD_PARAM_TYPE_OUTPUT_SCH_SET  || \
                                   code == CMD_PARAM_TYPE_OUTPUT_SCH_LST  || \
                                   code == CMD_PARAM_TYPE_OUTPUT_SCH_CLR  || \
                                   code == CMD_PARAM_TYPE_ANALOG_EXT      || \
                                   code == CMD_PARAM_TYPE_ANALOG_GET      || \
                                   code == CMD_PARAM_TYPE_INPUT_GET       || \
                                   code == CMD_PARAM_TYPE_OUTPUT_GET      || \
                                   code == CMD_PARAM_TYPE_OUTPUT_SET      || \
                                   code == CMD_PARAM_TYPE_CDMA_IP_PORT    || \
                                   code == CMD_PARAM_TYPE_GSM_MODE        || \
                                   code == CMD_PARAM_TYPE_SLEEP_TIME      || \
                                   code == CMD_PARAM_TYPE_LEDS_STATUS     || \
                                   code == CMD_PARAM_TYPE_SET_UNITID)

#define gprs_is_param_reply(code)  (code == CMD_PARAM_TYPE_MOVE_FREQ      || \
                                    code == CMD_PARAM_TYPE_SEND_FREQ      || \
                                    code == CMD_PARAM_TYPE_STOP_FREQ      || \
                                    code == CMD_PARAM_TYPE_CELL_INFO      || \
                                    code == CMD_PARAM_TYPE_TURN_DETECT    || \
                                    code == CMD_PARAM_TYPE_TURN_ANGLE     || \
                                    code == CMD_PARAM_TYPE_GSM_APN        || \
                                    code == CMD_PARAM_TYPE_GSM_IP_PORT    || \
                                    code == CMD_PARAM_TYPE_FC_PUMP        || \
                                    code == CMD_PARAM_TYPE_OUTPUT_SCH_GET || \
                                    code == CMD_PARAM_TYPE_OUTPUT_SCH_SET || \
                                    code == CMD_PARAM_TYPE_OUTPUT_SCH_LST || \
                                    code == CMD_PARAM_TYPE_OUTPUT_SCH_CLR || \
                                    code == CMD_PARAM_TYPE_ANALOG_EXT     || \
                                    code == CMD_PARAM_TYPE_ANALOG_GET     || \
                                    code == CMD_PARAM_TYPE_INPUT_GET      || \
                                    code == CMD_PARAM_TYPE_OUTPUT_GET     || \
                                    code == CMD_PARAM_TYPE_OUTPUT_SET     || \
                                    code == CMD_PARAM_TYPE_CDMA_IP_PORT   || \
                                    code == CMD_PARAM_TYPE_CDMA_ACTIVATE  || \
                                    code == CMD_PARAM_TYPE_GSM_MODE       || \
                                    code == CMD_PARAM_TYPE_GSM_NETWORK    || \
                                    code == CMD_PARAM_TYPE_SLEEP_TIME     || \
                                    code == CMD_PARAM_TYPE_LEDS_STATUS)

#define gprs_is_sendval_reply(code)  (code == CMD_VAL_REMOTE_DIAG         || \
                                      code == CMD_VAL_REMOTE_DIAG2)

#define GPRS_MSG_TYPE_POSITION          0
#define GPRS_MSG_TYPE_ALPHANUM_MSG      1
#define GPRS_MSG_TYPE_ALPHANUM_MSG_SPEC 2
#define GPRS_MSG_TYPE_CODED_NUM_MSG     3
#define GPRS_MSG_TYPE_ANSWER_TO_QUERY   4
#define GPRS_MSG_TYPE_POSITIONS_COMP    6
#define GPRS_MSG_TYPE_ACKNOWLEDGE       7
#define GPRS_MSG_TYPE_EXT_REPORT        8
#define GPRS_MSG_TYPE_CODED_POS_COMP    9

#define MSG_REF_REF_MASK              0x3F

#define MSG_REF_REF_NUM_OFFSET        0x0
#define MSG_REF_REF_NUM_MASK          MSG_REF_REF_MASK << MSG_REF_REF_NUM_OFFSET
#define MSG_REF_CELL_INFO_OFFSET      0x6
#define MSG_REF_CELL_INFO_MASK        1 << MSG_REF_CELL_INFO_OFFSET
#define MSG_REF_GPS_DATA_OFFSET       0x7
#define MSG_REF_GPS_DATA_MASK         1 << MSG_REF_GPS_DATA_OFFSET

#define MSG_TYPE_MODSTS_OFFSET        0x4
#define MSG_TYPE_MODSTS_MASK          1 << MSG_TYPE_MODSTS_OFFSET
#define MSG_TYPE_TEMP_OFFSET          0x5
#define MSG_TYPE_TEMP_MASK            1 << MSG_TYPE_TEMP_OFFSET
#define MSG_TYPE_IDLEN_OFFSET         0x6
#define MSG_TYPE_IDLEN_MASK           0x3 << MSG_TYPE_IDLEN_OFFSET

#define MSG_IO_IO_OFFSET              0x0
#define MSG_IO_IO_MASK                0xF << MSG_IO_OFFSET
#define MSG_IO_LAT_SOUTH_OFFSET       0x4
#define MSG_IO_LAT_SOUTH_MASK         1 << MSG_IO_LAT_SOUTH_OFFSET
#define MSG_IO_LON_WEST_OFFSET        0x5
#define MSG_IO_LON_WEST_MASK          1 << MSG_IO_LON_WEST_OFFSET
#define MSG_IO_COG_OFFSET             0x6
#define MSG_IO_COG_MASK               1 << MSG_IO_COG_OFFSET
#define MSG_IO_LAC_INFO_OFFSET        0x7
#define MSG_IO_LAC_INFO_MASK          1 << MSG_IO_LAC_INFO_OFFSET

#define MSG_LAT_GPS_ERROR_OFFSET      0x17
#define MSG_LAT_GPS_ERROR_MASK        1 << MSG_LAT_GPS_ERROR_OFFSET

#define MSG_CONTROL_TIME_OFFSET       0x0
#define MSG_CONTROL_TIME_MASK         0x3 << MSG_CONTROL_TIME_OFFSET
#define MSG_CONTROL_LAT_OFFSET        0x2
#define MSG_CONTROL_LAT_MASK          0x3 << MSG_CONTROL_LAT_OFFSET
#define MSG_CONTROL_LON_OFFSET        0x4
#define MSG_CONTROL_LON_MASK          0x3 << MSG_CONTROL_LON_OFFSET
#define MSG_CONTROL_SPEED_OFFSET      0x6
#define MSG_CONTROL_SPEED_MASK        1 << MSG_CONTROL_SPEED_OFFSET
#define MSG_CONTROL_IO_OFFSET         0x7
#define MSG_CONTROL_IO_MASK           1 << MSG_CONTROL_IO_OFFSET

#define MSG_ADDIO_INT_VOLTAGE_OFFSET  0x0
#define MSG_ADDIO_INT_VOLTAGE_MASK    0x1 << MSG_ADDIO_INT_VOLTAGE_OFFSET
#define MSG_ADDIO_EXT_VOLTAGE_OFFSET  0x1
#define MSG_ADDIO_EXT_VOLTAGE_MASK    0x1 << MSG_ADDIO_EXT_VOLTAGE_OFFSET
#define MSG_ADDIO_ADC_INPUT_1_OFFSET  0x2
#define MSG_ADDIO_ADC_INPUT_1_MASK    0x1 << MSG_ADDIO_ADC_INPUT_1_OFFSET
#define MSG_ADDIO_ADC_INPUT_2_OFFSET  0x3
#define MSG_ADDIO_ADC_INPUT_2_MASK    0x1 << MSG_ADDIO_ADC_INPUT_2_OFFSET
#define MSG_ADDIO_INPUT_3_OFFSET      0x4
#define MSG_ADDIO_INPUT_3_MASK        0x1 << MSG_ADDIO_INPUT_3_OFFSET
#define MSG_ADDIO_OUTPUT_3_OFFSET     0x5
#define MSG_ADDIO_OUTPUT_3_MASK       0x1 << MSG_ADDIO_OUTPUT_3_OFFSET
#define MSG_ADDIO_ORIENTATION_OFFSET  0x6
#define MSG_ADDIO_ORIENTATION_MASK    0x1 << MSG_ADDIO_ORIENTATION_OFFSET

#define MSG_ADDIO_ORIENT_TOP_UP       0x1
#define MSG_ADDIO_ORIENT_BOTTOM_UP    0x2
#define MSG_ADDIO_ORIENT_FRONT_UP     0x3
#define MSG_ADDIO_ORIENT_REAR_UP      0x4
#define MSG_ADDIO_ORIENT_RIGHT_UP     0x5
#define MSG_ADDIO_ORIENT_LEFT_UP      0x6

#define MSG_PGT_INFO_VOLTAGE_OFFSET   0x0
#define MSG_PGT_INFO_VOLTAGE_MASK     0x1 << MSG_PGT_INFO_VOLTAGE_OFFSET
#define MSG_PGT_INFO_HEIGHT_OFFSET    0x1
#define MSG_PGT_INFO_HEIGHT_MASK      0x1 << MSG_PGT_INFO_HEIGHT_OFFSET
#define MSG_PGT_INFO_OVERLOAD_OFFSET  0x2
#define MSG_PGT_INFO_OVERLOAD_MASK    0x1 << MSG_PGT_INFO_OVERLOAD_OFFSET
#define MSG_PGT_INFO_TILT_OFFSET      0x3
#define MSG_PGT_INFO_TILT_MASK        0x1 << MSG_PGT_INFO_TILT_OFFSET
#define MSG_PGT_INFO_HOURS_OFFSET     0x4
#define MSG_PGT_INFO_HOURS_MASK       0x1 << MSG_PGT_INFO_HOURS_OFFSET

#define MSG_RPE_INFO_BATTERY_OFFSET   0x0
#define MSG_RPE_INFO_BATTERY_MASK     0x1 << MSG_RPE_INFO_BATTERY_OFFSET
#define MSG_RPE_INFO_GENERATOR_OFFSET 0x1
#define MSG_RPE_INFO_GENERATOR_MASK   0x1 << MSG_RPE_INFO_GENERATOR_OFFSET
#define MSG_RPE_INFO_INVERTER_OFFSET  0x2
#define MSG_RPE_INFO_INVERTER_MASK    0x1 << MSG_RPE_INFO_INVERTER_OFFSET
#define MSG_RPE_INFO_TRAILER_OFFSET   0x3
#define MSG_RPE_INFO_TRAILER_MASK     0x1 << MSG_RPE_INFO_TRAILER_OFFSET

#define CMD_RELAY_ID_LENGTH_OFFSET    0x0
#define CMD_RELAY_ID_LENGTH_MASK      0xF << CMD_RELAY_ID_LENGTH_OFFSET
#define CMD_RELAY_ID_SOCKET_OFFSET    0x3
#define CMD_RELAY_ID_SOCKET_MASK      0x1 << CMD_RELAY_ID_SOCKET_OFFSET

#define CMD_TYPE_FREE_MSG             1
#define CMD_TYPE_FORMAT_MSG           2
#define CMD_TYPE_CODED_MSG            3
#define CMD_TYPE_CONFIG_MSG           4
#define CMD_TYPE_PROGRAM              5
#define CMD_TYPE_SENDVAL_REPLY        6
#define CMD_TYPE_PARAM_REPLY          8
#define CMD_TYPE_PACKET_RELAY         9

#define CMD_TYPE_TYPE_MASK            0xF
#define CMD_TYPE_TYPE_OFFSET          0x0
#define CMD_TYPE_REF_MASK             0xF0
#define CMD_TYPE_REF_OFFSET           0x4

#define CMD_PARAM_TYPE_POSITION       0
#define CMD_PARAM_TYPE_MOVE_FREQ      1
#define CMD_PARAM_TYPE_SENDVAL        20
#define CMD_PARAM_TYPE_REQUEST_PARAM  31
#define CMD_PARAM_TYPE_PARAMS         36
#define CMD_PARAM_TYPE_CELL_INFO      42
#define CMD_PARAM_TYPE_SEND_FREQ      67
#define CMD_PARAM_TYPE_STOP_FREQ      68
#define CMD_PARAM_TYPE_TURN_DETECT    70
#define CMD_PARAM_TYPE_TURN_ANGLE     71
#define CMD_PARAM_TYPE_GSM_APN        72
#define CMD_PARAM_TYPE_GSM_IP_PORT    73
#define CMD_PARAM_TYPE_FC_PUMP        80
#define CMD_PARAM_TYPE_OUTPUT_SCH_GET 81
#define CMD_PARAM_TYPE_OUTPUT_SCH_SET 82
#define CMD_PARAM_TYPE_OUTPUT_SCH_LST 83
#define CMD_PARAM_TYPE_OUTPUT_SCH_CLR 84
#define CMD_PARAM_TYPE_ANALOG_EXT     87
#define CMD_PARAM_TYPE_ANALOG_GET     88
#define CMD_PARAM_TYPE_INPUT_GET      89
#define CMD_PARAM_TYPE_OUTPUT_GET     90
#define CMD_PARAM_TYPE_OUTPUT_SET     91
#define CMD_PARAM_TYPE_CDMA_IP_PORT   92
#define CMD_PARAM_TYPE_CDMA_ACTIVATE  93
#define CMD_PARAM_TYPE_GSM_MODE       94
#define CMD_PARAM_TYPE_GSM_NETWORK    95
#define CMD_PARAM_TYPE_SLEEP_TIME     100
#define CMD_PARAM_TYPE_LEDS_STATUS    101
#define CMD_PARAM_TYPE_SET_UNITID     130
#define CMD_PARAM_TYPE_CONFIG         150

/* Config Vals */
#define CMD_CONFIG_TYPE_SHOW          0
#define CMD_CONFIG_TYPE_RESET         1
#define CMD_CONFIG_TYPE_VALID         2
#define CMD_CONFIG_TYPE_GET           3
#define CMD_CONFIG_TYPE_SET           4

/* Send Vals (for param type 20) */
#define CMD_VAL_GSM_ON                1
#define CMD_VAL_GSM_OFF               2
#define CMD_VAL_CDMA_ACTIVATE         3
#define CMD_VAL_GPS_ON                46
#define CMD_VAL_GPS_OFF               47
#define CMD_VAL_RESET                 16

#define CMD_VAL_ALARM_PANIC           31

#define CMD_VAL_RC_PROG               53
#define CMD_VAL_LOCK_DOORS            56
#define CMD_VAL_UNLOCK_DOORS          57

#define CMD_VAL_DEBOUNCE_SHORT        65
#define CMD_VAL_DEBOUNCE_LONG         66

#define CMD_VAL_ALARM_TRIGGER_NO_MSG  69
#define CMD_VAL_ALARM_ARM             70
#define CMD_VAL_ENGINE_OFF            71
#define CMD_VAL_ENGINE_ON             72
#define CMD_VAL_REMOTE_DIAG           73
#define CMD_VAL_REMOTE_DIAG2          74

// WARNING: Only for DC Solar demo. We will use a completely different code for the
// final RPE BMU stuff
#define CMD_VAL_DCSOLAR_DEMO          75

#define CMD_VAL_VALET_MODE            76

#define CMD_VAL_VALET_FENCE_ON        95
#define CMD_VAL_VALET_FENCE_OFF       96

#define CMD_VAL_ALARM_UNARM           97

#define CMD_VAL_ACCESORY_TRIGGER      98
#define CMD_VAL_ACCESORY_ON           99
#define CMD_VAL_ACCESORY_OFF          100

/* Param Values (for param type 36) */
#define CMD_PARAM_SIREN_OFF           2
#define CMD_PARAM_SIREN_ON            130

#define CMD_PROG_CODE_START           0x1
#define CMD_PROG_CODE_DATA            0x2
#define CMD_PROG_CODE_CANCEL          0x3
#define CMD_PROG_CODE_RESUME          0x4
#define CMD_PROG_CODE_END             0x5
#define CMD_PROG_CODE_REQ_FW          0x6
#define CMD_PROG_CODE_REQ_FW_INFO     0x7

#ifdef THERMOKING
  #define GPRS_RID_TK_TEMPS           0xC1
  #define GPRS_RID_TK_STATUS          0xC2
  #define GPRS_RID_TK_TIMES           0xC3
  #define GPRS_RID_TK_ALARMS          0xC5
#endif

#endif
