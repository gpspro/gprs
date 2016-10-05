
#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "gprs.h"

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

// Checks packet format, unescapes data, and validates CRC
// WARNING: Will modify the packet & size parameters
int gprs_preprocess(uint8_t * packet, int * size)
{
  int i, idx = 0;
  uint8_t buf[*size];

  uint8_t crc, ccrc;

  // Remove last newline if present
  if (packet[*size - 1] == GPRS_NL) {
    packet[*size - 1] = 0;
    *size = *size - 1;
  }

  // Check for SOP and EOP
  if (packet[0] != GPRS_SOP || packet[*size - 1] != GPRS_EOP) {
    printf("Invalid Packet: Missing SOP or EOP byte.\n");
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
    printf("Invalid CRC: %d != %d.\n", crc, ccrc);
    return GPRS_RC_ERROR_CRC;
  }

  return GPRS_RC_SUCCESS;
}