
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>

#include "gprs.h"
#include "defs.h"

// Protocol
#define GPRS_SOP            0x28
#define GPRS_EOP            0x29

// Special characters & escaping
#define GPRS_BACKSPACE      0x8
#define GPRS_CR             0xA
#define GPRS_NL             0xD
#define GPRS_DLE            0x10
#define GPRS_DLE_OFFSET     0x80

uint8_t gprs_read_byte(uint8_t * buf, int * idx)
{
  uint8_t byte = buf[*idx];
  *idx = *idx + 1;
  return byte;
}

uint32_t gprs_read_bytes(uint8_t * buf, int * idx, int size)
{
  int i;
  uint32_t val = 0;

  assert(size > 0 && size <= 4);

  for (i = 0; i < size; i++) {
    val |= buf[*idx] << (i * 8);
    *idx = *idx + 1;
  }

  return val;
}

int gprs_to_signed(uint32_t val)
{
  int newval = val;

  if (val > GPRS_8BIT_DIFF && val < GPRS_8BIT_MAX) {
    newval = GPRS_8BIT_DIFF - val;
  } else if (val > GPRS_16BIT_DIFF && val < GPRS_16BIT_MAX) {
    newval = GPRS_16BIT_DIFF - val;
  } else if (val > GPRS_24BIT_DIFF && val < GPRS_24BIT_MAX) {
    newval = GPRS_24BIT_DIFF - val;
  }

  return newval;
}

// Detect packet type based on size, type, and code
// NOTE: Packet must be preprocessed
int gprs_packet_type(uint8_t * buf, int size)
{
  int ptype = GPRS_PACKET_UNKNOWN;

  if (size == 1) {
    ptype = GPRS_PACKET_ACK;
  } else if (size > 1) {
    // Type and code are always at the same spot in a packet
    uint8_t type = buf[0] & 0xF;
    uint8_t code = buf[1];

    switch (type) {
    case CMD_TYPE_CONFIG_MSG:
      if (gprs_is_config_msg(code)) {
        ptype = GPRS_PACKET_COMMAND;
      }
      break;
    case CMD_TYPE_PROGRAM:
      if (gprs_is_program_code(code)) {
        ptype = GPRS_PACKET_PROGRAM;
      }
      break;
    case CMD_TYPE_SENDVAL_REPLY:
      if (gprs_is_sendval_reply(code)) {
        ptype = GPRS_PACKET_COMMAND;
      }
      break;
    case CMD_TYPE_PARAM_REPLY:
      if (gprs_is_param_reply(code)) {
        ptype = GPRS_PACKET_COMMAND;
      }
      break;
    }

    // Let's just check to see if it's a report
    if (size >= GPRS_REPORT_MIN_SIZE && !gprs_is_cmd_large(code)) {
      type = buf[1] & 0xF;
      if (gprs_is_report_type(type)) {
        ptype = GPRS_PACKET_REPORT;
      }
    }
  }

  return ptype;
}

// Checks packet format, unescapes data, and validates CRC
// WARNING: Will modify the packet & size parameters
int gprs_preprocess(uint8_t * packet, int * size, bool verbose)
{
  int i, idx = 0;
  uint8_t buf[*size];
  uint8_t crc, ccrc;

  if (*size < GPRS_PACKET_MIN_SIZE) {
    if (verbose) printf("Invalid Packet: Less than minimum size.\n");
    return GPRS_RC_ERROR_INVALID;
  }

  // Remove last newline if present
  if (packet[*size - 1] == GPRS_NL) {
    packet[*size - 1] = 0;
    *size = *size - 1;
  }

  // Check for SOP and EOP
  if (packet[0] != GPRS_SOP || packet[*size - 1] != GPRS_EOP) {
    if (verbose) printf("Invalid Packet: Missing SOP or EOP byte.\n");
    return GPRS_RC_ERROR_INVALID;
  }

  // Unescape (skip & remove SOP and EOP bytes)
  for (i = 1; i < *size - 1; i++) {
    if (packet[i] == GPRS_DLE) {
      buf[idx++] = packet[i + 1] - GPRS_DLE_OFFSET;
      i++;
    } else {
      buf[idx++] = packet[i];
    }
  }
  *size = idx;

  memcpy(packet, buf, *size);

  // Validate & remove CRC
  crc = packet[*size - 1];
  *size = *size - 1;
  ccrc = 0;
  for (i = 0; i < *size; i++) {
    ccrc ^= packet[i];
  }
  if (crc != ccrc) {
    if (verbose) printf("Invalid CRC: %d != %d.\n", crc, ccrc);
    return GPRS_RC_ERROR_CRC;
  }

  return GPRS_RC_SUCCESS;
}
