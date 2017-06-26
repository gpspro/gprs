
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#include "gprs.h"
#include "defs.h"
#include "cmd.h"

void cmd_parse(uint8_t * buf, int size, cmd_t * cmd)
{
  int idx = 0;
  uint8_t byte;

  // Type & Ref
  byte = gprs_read_byte(buf, &idx);
  cmd->headers.ref  = (byte & CMD_TYPE_REF_MASK)  >> CMD_TYPE_REF_OFFSET;
  cmd->headers.type = (byte & CMD_TYPE_TYPE_MASK) >> CMD_TYPE_TYPE_OFFSET;

  // Code
  cmd->headers.code = gprs_read_byte(buf, &idx);

  // Initialize data to 0
  memset(&cmd->data, 0, sizeof(cmd_data_t));

  switch (cmd->headers.type) {
  // Replies to CMD_PARAM_TYPE_SENDVAL
  case CMD_TYPE_SENDVAL_REPLY:
    switch (cmd->headers.code) {
    // Diag Reply
    case CMD_VAL_REMOTE_DIAG:
    {
      cmd_diag_t * diag = &cmd->data.diag;

      // Version
      diag->version_major     = gprs_read_byte(buf, &idx);
      diag->version_minor     = gprs_read_byte(buf, &idx);
      diag->version_revision  = gprs_read_byte(buf, &idx);

      // GSM Status
      diag->modem_status      = gprs_read_byte(buf, &idx);
      diag->modem_signal      = gprs_read_byte(buf, &idx);

      // Modem Status
      diag->gps_status        = gprs_read_byte(buf, &idx);

      // Int/Ext Voltages
      diag->int_voltage       = gprs_read_bytes(buf, &idx, 2);
      diag->ext_voltage       = gprs_read_bytes(buf, &idx, 2);
      break;
    }
    // Diag V2 Reply
    case CMD_VAL_REMOTE_DIAG2:
    {
      uint8_t mask;
      cmd_diag2_t * diag2 = &cmd->data.diag2;

      // Mask
      mask = gprs_read_byte(buf, &idx);

      // Version
      diag2->version_major    = gprs_read_byte(buf, &idx);
      diag2->version_minor    = gprs_read_byte(buf, &idx);
      diag2->version_revision = gprs_read_byte(buf, &idx);

      // Modem Status
      diag2->modem_status     = gprs_read_byte(buf, &idx);
      diag2->modem_signal     = gprs_read_byte(buf, &idx);

      // GPS Status
      byte                    = gprs_read_byte(buf, &idx);
      diag2->gps_fix          = (byte & GPRS_CMD_DIAG_GPS_FIX_MASK) >> GPRS_CMD_DIAG_GPS_FIX_OFFSET;
      diag2->gps_satellites   = (byte & GPRS_CMD_DIAG_GPS_SAT_MASK) >> GPRS_CMD_DIAG_GPS_SAT_OFFSET;

      // Int Voltage
      diag2->has_int_voltage  = (mask & GPRS_CMD_DIAG_INT_MASK) >> GPRS_CMD_DIAG_INT_OFFSET;
      if (diag2->has_int_voltage) {
        diag2->int_voltage    = gprs_read_bytes(buf, &idx, 2);
      }

      // Ext Voltage
      diag2->has_ext_voltage  = (mask & GPRS_CMD_DIAG_EXT_MASK) >> GPRS_CMD_DIAG_EXT_OFFSET;
      if (diag2->has_ext_voltage) {
        diag2->ext_voltage    = gprs_read_bytes(buf, &idx, 2);
      }

      diag2->has_temperature  = (mask & GPRS_CMD_DIAG_TEMP_MASK) >> GPRS_CMD_DIAG_TEMP_OFFSET;
      if (diag2->has_temperature) {
        diag2->temperature    = gprs_read_byte(buf, &idx);
      }

      // Inputs/Outputs
      bool has_inputs_outputs = (mask & GPRS_CMD_DIAG_IO_MASK) >> GPRS_CMD_DIAG_IO_OFFSET;
      if (has_inputs_outputs) {
        uint8_t inputs = gprs_read_byte(buf, &idx);
        for (int i = 0; i < GPRS_CMD_DIAG_INPUTS_MAX; i++) {
          diag2->input_present[i]   = (inputs & (0x1 << (i + 0))) != 0;
          diag2->input_values[i]    = (inputs & (0x1 << (i + GPRS_CMD_DIAG_INPUTS_MAX))) != 0;
        }

        uint8_t outputs = gprs_read_byte(buf, &idx);
        for (int i = 0; i < GPRS_CMD_DIAG_OUTPUTS_MAX; i++) {
          diag2->output_present[i]  = (outputs & (0x1 << (i + 0))) != 0;
          diag2->output_values[i]   = (outputs & (0x1 << (i + GPRS_CMD_DIAG_OUTPUTS_MAX))) != 0;
        }
      }

      bool has_analogs = (mask & GPRS_CMD_DIAG_ANALOG_MASK) >> GPRS_CMD_DIAG_ANALOG_OFFSET;
      if (has_analogs) {
        uint8_t analogs = gprs_read_byte(buf, &idx);
        for (int i = 0; i < GPRS_CMD_DIAG_OUTPUTS_MAX; i++) {
          diag2->analog_present[i]  = (analogs & (0x1 << i)) != 0;
          if (diag2->analog_present[i]) {
            diag2->analog_values[i] = gprs_read_bytes(buf, &idx, 2);
          }
        }
      }
      break;
    }
    default:
      // Unknown code
      break;
    }
    break;
  default:
    // Unknown type
    break;
  }
}

void cmd_print(cmd_t * cmd)
{
  printf("Type: %d, Ref: %d, Code: %d\n", cmd->headers.type,
                                          cmd->headers.ref,
                                          cmd->headers.code);

  switch (cmd->headers.type) {
  // Replies to CMD_PARAM_TYPE_SENDVAL
  case CMD_TYPE_SENDVAL_REPLY:
    switch (cmd->headers.code) {
    case CMD_VAL_REMOTE_DIAG:
    {
      cmd_diag_t * diag = &cmd->data.diag;
      printf("Device Diag Response\n");
      printf("Firmware Version: v%d.%d.%d",     diag->version_major,
                                                diag->version_minor,
                                                diag->version_revision);
      printf("Modem Status: %d, Signal: %d\n",  diag->modem_status,
                                                diag->modem_signal);
      printf("GPS Status: %d\n",                diag->gps_status);
      printf("Int Voltage: %.02fV\n",           diag->int_voltage / 100.0);
      printf("Ext Voltage: %.02fV\n",           diag->ext_voltage / 100.0);
      break;
    }
    case CMD_VAL_REMOTE_DIAG2:
    {
      cmd_diag2_t * diag2 = &cmd->data.diag2;
      printf("Device Diag V2 Response\n");
      printf("Firmware Version: v%d.%d.%d",     diag2->version_major,
                                                diag2->version_minor,
                                                diag2->version_revision);
      printf("Modem Status: %d, Signal: %d\n",  diag2->modem_status,
                                                diag2->modem_signal);
      printf("GPS Fix: %d\n",                   diag2->gps_fix);
      printf("GPS Satellites: %d\n",            diag2->gps_satellites);
      if (diag2->has_int_voltage) {
        printf("Int Voltage: %.02fV\n",         diag2->int_voltage / 100.0);
      }
      if (diag2->has_ext_voltage) {
        printf("Ext Voltage: %.02fV\n",         diag2->ext_voltage / 100.0);
      }
      if (diag2->has_temperature) {
        printf("Temperature: %dF\n",            diag2->temperature);
      }
      for (int i = 0; i < GPRS_CMD_DIAG_INPUTS_MAX; i++) {
        if (diag2->input_present[i]) {
          printf("Input %d: %d\n", i + 1,       diag2->input_values[i]);
        }
      }
      for (int i = 0; i < GPRS_CMD_DIAG_OUTPUTS_MAX; i++) {
        if (diag2->output_present[i]) {
          printf("Output %d: %d\n", i + 1,       diag2->output_values[i]);
        }
      }
      for (int i = 0; i < GPRS_CMD_DIAG_ANALOGS_MAX; i++) {
        if (diag2->analog_present[i]) {
          printf("Analog %d: %.02fV\n", i + 1,  (diag2->analog_values[i] / 1000.0));
        }
      }

      break;
    }
    default:
      // Unknown code
      break;
    }
  default:
    // Unknown type
    break;
  }
}
