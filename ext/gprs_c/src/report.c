
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>

#include "gprs.h"
#include "report.h"


void report_print(report_t report)
{
  printf("Ref: %d, Has Cell: %d, Has GPS: %d\n",                      report.ref,
                                                                      report.has_cell,
                                                                      report.has_gps);
  printf("Type: %d, Has Modsts: %d, Has Temp: %d, ID Len: %d\n",      report.type,
                                                                      report.has_modsts,
                                                                      report.has_temp,
                                                                      report.id_len);
  printf("Input 1: %d, Input 2: %d, Output 1: %d, Output 2: %d\n",    report.input_1,
                                                                      report.input_2,
                                                                      report.output_1,
                                                                      report.output_2);
  printf("Lat South: %d, Lon West: %d, Has COG: %d, Has Lac: %d\n",   report.lat_south,
                                                                      report.lon_west,
                                                                      report.has_cog,
                                                                      report.has_lac);
  printf("Time: %d\n",                                                report.time);
  printf("Device ID: %d\n",                                           report.device_id);

  if (report.has_gps) {
    printf("Lat: %d\n",                                               report.lat);
    printf("GPS Invalid: %d\n",                                       report.gps_invalid);
    printf("Lon: %d\n",                                               report.lon);
    printf("Speed: %d\n",                                             report.speed);
  }
  if (report.has_cog) {
    printf("COG: %d\n",                                               report.cog);
  }
  if (report_has_code(report.type)) {
    printf("Code: %d\n",                                              report.code);
  }
  if (report.has_modsts) {
    printf("Modsts: %d\n",                                            report.modsts);
  }
  if (report.has_temp) {
    printf("Temp: %d\n",                                              report.temp);
  }
  if (report.has_cell) {
    printf("Cell ID: %d\n",                                           report.cell_id);
    printf("Signal: %d\n",                                            report.signal);
  }
  if (report.has_lac) {
    printf("Lac: %d\n",                                               report.lac);
  }
  switch (report.type) {
  case REPORT_TYPE_EXTENDED_DATA:
    printf("Data Type: %d", report.data_type);

    switch (report.data_type) {
    case REPORT_DATA_TYPE_ADDITIONAL_IO:
    {
      additional_io_t * addio = &report.data.additional_io;

      printf(" (Additional IO)\n");
      if (addio->has_int_voltage) {
        printf("Internal Voltage: %d\n",  addio->int_voltage);
      }
      if (addio->has_ext_voltage) {
        printf("External Voltage: %d\n",  addio->ext_voltage);
      }
      if (addio->has_adc_input_1) {
        printf("ADC Input 1: %d\n",       addio->adc_input_1);
      }
      if (addio->has_adc_input_2) {
        printf("ADC Input 2: %d\n",       addio->adc_input_2);
      }
      if (addio->has_input_3) {
        printf("Input 3: %d\n",           addio->input_3);
      }
      if (addio->has_output_3) {
        printf("Output 3: %d\n",          addio->output_3);
      }
      if (addio->has_orientation) {
        printf("Orientation: %d\n",       addio->orientation);
      }
      break;
    }
    default:
      printf(" (Unknown)\n");
      break;
    }
    break;
  }
}

// Parse report from a buffer (requires that SOP, EOP, and CRC be removed)
int report_parse(uint8_t * buf, int size, report_t * reports)
{
  int count = 0;
  report_t * report = &reports[0];

  int idx = 0;
  uint8_t byte;

  memset(report, 0, sizeof(report_t));

  // Ref
  byte = gprs_read_byte(buf, &idx);
  report->ref       = (byte & 0x3F) >> 0;
  report->has_cell = (byte & 0x40) >> 6;
  report->has_gps  = (byte & 0x80) >> 7;

  // Type
  byte = gprs_read_byte(buf, &idx);
  report->type        = (byte & 0x0F) >> 0;
  report->has_modsts  = (byte & 0x10) >> 4;
  report->has_temp    = (byte & 0x20) >> 5;
  report->id_len      = (byte & 0xC0) >> 6;

  // IO
  byte = gprs_read_byte(buf, &idx);
  report->input_1     = (byte & 0x01) >> 0;
  report->input_2     = (byte & 0x02) >> 1;
  report->output_1    = (byte & 0x04) >> 2;
  report->output_2    = (byte & 0x08) >> 3;
  report->lat_south   = (byte & 0x10) >> 4;
  report->lon_west    = (byte & 0x20) >> 5;
  report->has_cog     = (byte & 0x40) >> 6;
  report->has_lac     = (byte & 0x80) >> 7;

  // Time
  report->time = gprs_read_bytes(buf, &idx, 4);

  // Device ID
  report->device_id = gprs_read_bytes(buf, &idx, report->id_len + 1);

  if (report->has_gps) {
    // Latitude & Longitude
    report->lat         = gprs_read_bytes(buf, &idx, 3);
    report->lon         = gprs_read_bytes(buf, &idx, 3);

    // Read GPS valid bit and clear from latitude field (important!!!!)
    report->gps_invalid = (report->lat & 0x800000) >> 23;
    report->lat         = (report->lat & 0x7FFFFF) >> 0;

    // Speed
    report->speed       = gprs_read_byte(buf, &idx);
  }

  // COG
  if (report->has_cog) {
    report->cog = gprs_read_byte(buf, &idx);
  }

  // Code
  if (report_has_code(report->type)) {
    report->code = gprs_read_byte(buf, &idx);
  }

  // Modsts
  if (report->has_modsts) {
    report->modsts = gprs_read_byte(buf, &idx);
  }

  // Temp
  if (report->has_temp) {
    report->temp = gprs_read_byte(buf, &idx);
  }

  // Cell Info
  if (report->has_cell) {
    report->cell_id = gprs_read_bytes(buf, &idx, 2);
    report->signal = gprs_read_byte(buf, &idx);
  }

  // Lac
  if (report->has_lac) {
    report->lac = gprs_read_bytes(buf, &idx, 2);
  }

  switch (report->type) {
  case REPORT_TYPE_EXTENDED_DATA:
  {
    report->data_type = gprs_read_byte(buf, &idx);

    switch (report->data_type) {
    case REPORT_DATA_TYPE_ADDITIONAL_IO:
    {
      additional_io_t * addio = &report->data.additional_io;

      // Mask
      byte = gprs_read_byte(buf, &idx);
      addio->has_int_voltage = (byte & 0x01) >> 0;
      addio->has_ext_voltage = (byte & 0x02) >> 1;
      addio->has_adc_input_1 = (byte & 0x04) >> 2;
      addio->has_adc_input_2 = (byte & 0x08) >> 3;
      addio->has_input_3     = (byte & 0x10) >> 4;
      addio->has_output_3    = (byte & 0x20) >> 5;
      addio->has_orientation = (byte & 0x40) >> 6;

      // Internal Voltage
      if (addio->has_int_voltage) {
        addio->int_voltage = gprs_read_bytes(buf, &idx, 2);
      }

      // External Voltage
      if (addio->has_ext_voltage) {
        addio->ext_voltage = gprs_read_bytes(buf, &idx, 2);
      }

      // ADC Input 1
      if (addio->has_adc_input_1) {
        addio->adc_input_1 = gprs_read_byte(buf, &idx);
      }

      // ADC Input 2
      if (addio->has_adc_input_2) {
        addio->adc_input_2 = gprs_read_byte(buf, &idx);
      }

      // Input 3
      if (addio->has_input_3) {
        addio->input_3 = gprs_read_byte(buf, &idx);
      }

      // Output 3
      if (addio->has_output_3) {
        addio->output_3 = gprs_read_byte(buf, &idx);
      }

      // Orientation
      if (addio->has_orientation) {
        addio->orientation = gprs_read_byte(buf, &idx);
      }
      break;
    }
    default:
      // Unknown data type
      break;
    }

    break;
  }
  default:
    // Ignore
    break;
  }

  count++;

  return count;
}