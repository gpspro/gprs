
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

      // GPS Status
      diag->gps_status        = gprs_read_byte(buf, &idx);

      // Int/Ext Voltages
      diag->int_voltage       = gprs_read_bytes(buf, &idx, 2);
      diag->ext_voltage       = gprs_read_bytes(buf, &idx, 2);
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
      printf("Int Voltage: %.02fV\n",           diag->int_voltage / 100);
      printf("Ext Voltage: %.02fV\n",           diag->ext_voltage / 100);
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
