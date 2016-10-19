
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>
#include <time.h>

#include "gprs.h"
#include "report.h"

#define REPORT_LAT_SECS_MULT    115200.0
#define REPORT_LON_SECS_MULT    90000.0

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
    printf("Data Type: %d", report.ext_type);

    switch (report.ext_type) {
    case REPORT_DATA_TYPE_ADDITIONAL_IO:
    {
      additional_io_t * addio = &report.ext.additional_io;

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

void report_lattos(double lat, uint32_t * secs, bool * south)
{
  if (lat < 0.0) {
    lat = -lat;
    *south = true;
  } else {
    *south = false;
  }

  *secs = lat * REPORT_LAT_SECS_MULT;
}

void report_lontos(double lon, uint32_t * secs, bool * west)
{
  if (lon < 0.0) {
    lon = -lon;
    *west = true;
  } else {
    *west = false;
  }

  *secs = lon * REPORT_LON_SECS_MULT;
}

double report_stolat(uint32_t secs, bool south)
{
  double lat = (double)(secs / REPORT_LAT_SECS_MULT);
  if (south) lat = -lat;
  return lat;
}

double report_stolon(uint32_t secs, bool west)
{
  double lon = (double)(secs / REPORT_LON_SECS_MULT);
  if (west) lon = -lon;
  return lon;
}

double report_cvtov(uint16_t cV)
{
  return (double)cV / 100.0;
}

// 01/01/2000 00:00:00
struct tm time_diff = {
  .tm_sec = 0,
  .tm_min = 0,
  .tm_hour = 0,
  .tm_mday = 1,
  .tm_mon = 0,
  .tm_year = 100
};

struct tm report_stotm(uint32_t secs)
{
  struct tm report_tm, current_tm;
  time_t ts, current;

  // Detect DST
  current = time(NULL);
  current_tm = *localtime(&current);
  time_diff.tm_isdst = current_tm.tm_isdst;

  // Convert diff to time_t and add secs
  ts = mktime(&time_diff) + secs;

  // Convert to tm struct
  report_tm = *localtime(&ts);

  return report_tm;
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

    // this will detect an extended report before the code field was added
    if (report->code > 0x24 && report->type == REPORT_TYPE_EXTENDED_DATA) {
      report->code = 0;
      idx--;
    }
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

  count++;

  switch (report->type) {
  case REPORT_TYPE_COMP_POS:
  case REPORT_TYPE_CODED_COMP_POS:
  {
    while (idx < size && count < REPORT_MAX_COMPRESSED_REPORTS) {
      // Compressed fields
      // NOTE: Time/Lat/Lon diff values may be positive or negative
      uint8_t control, time_size, lat_size, lon_size, has_speed, has_io;
      int time_diff, lat_diff, lon_diff;
      uint8_t speed;
      //uint8_t io;

      report_t * report_next = &reports[count];

      memset(report_next, 0, sizeof(report_t));

      // Copy basic fields from previous report
      report_next->device_id  = report->device_id;
      report_next->type       = report->type;
      report_next->has_gps    = true;
      report_next->lat_south  = report->lat_south;
      report_next->lon_west   = report->lon_west;

      // Start reading
      control = gprs_read_byte(buf, &idx);

      // Read bitfields of control byte
      time_size = (control & 0x03) >> 0;
      lat_size  = (control & 0x0C) >> 2;
      lon_size  = (control & 0x30) >> 4;
      has_speed = (control & 0x40) >> 6;
      has_io    = (control & 0x80) >> 7;

      // Time Diff
      if (time_size > 0) {
        time_diff = gprs_read_bytes(buf, &idx, time_size);
        time_diff = gprs_to_signed(time_diff);
        report_next->time = report->time + time_diff;
      } else {
        report_next->time = report->time;
      }

      // Lat Diff
      if (lat_size > 0) {
        lat_diff = gprs_read_bytes(buf, &idx, lat_size);
        lat_diff = gprs_to_signed(lat_diff);
        report_next->lat = report->lat + lat_diff;
      } else {
        report_next->lat = report->lat;
      }

      // Lon Diff
      if (lon_size > 0) {
        lon_diff = gprs_read_bytes(buf, &idx, lon_size);
        lon_diff = gprs_to_signed(lon_diff);
        report_next->lon = report->lon + lon_diff;
      } else {
        report_next->lon = report->lon;
      }

      // Speed
      if (has_speed) {
        speed = gprs_read_byte(buf, &idx);
        report_next->speed = speed;
      } else {
        report_next->speed = report->speed;
      }

      // IO
      if (has_io) {
        // NOTE: This is not supported by the device/protocol yet, but is reserved
        // for the future. Also, there may be more bytes after this IO byte depending
        // on flags that are set.
        //io = gprs_read_byte(buf, &idx);
      }

      // Move to next item
      report = report_next;
      count++;
    }

    // For compressed reports, code of the original report applies to the
    // LAST report in the packet.
    report->code = reports[0].code;
    reports[0].code = 0;

    break;
  }
  case REPORT_TYPE_EXTENDED_DATA:
  {
    report->ext_type = gprs_read_byte(buf, &idx);

    switch (report->ext_type) {
    case REPORT_DATA_TYPE_ADDITIONAL_IO:
    {
      additional_io_t * addio = &report->ext.additional_io;

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
    case REPORT_DATA_TYPE_FC_TXN_COMPLETE:
    {
      fc_txn_t * txn = &report->ext.fc_txn;

      txn->txn_id = gprs_read_bytes(buf, &idx, 4);
      txn->ticks = gprs_read_bytes(buf, &idx, 4);

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

  return count;
}
