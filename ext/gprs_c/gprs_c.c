
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <time.h>

#include <ruby.h>

#include "defs.h"
#include "cmd.h"
#include "gprs.h"
#include "report.h"

VALUE gprs = Qnil;

VALUE packet_type(VALUE self, VALUE data, VALUE print);
VALUE packet_parse(VALUE self, VALUE data, VALUE print);

void Init_gprs_c()
{
  gprs = rb_define_module("GprsC");
  rb_define_singleton_method(gprs, "packet_type_c", packet_type, 2);
  rb_define_singleton_method(gprs, "packet_parse_c", packet_parse, 2);
}

VALUE make_symbol(const char * name)
{
  return ID2SYM(rb_intern(name));
}

VALUE hash_from_command(cmd_t * cmd)
{
  char key_buf[50];
  char val_buf[100];

  VALUE hash = rb_hash_new();
  rb_hash_aset(hash, make_symbol("type"), INT2NUM(cmd->headers.type));
  rb_hash_aset(hash, make_symbol("ref"),  INT2NUM(cmd->headers.ref));
  rb_hash_aset(hash, make_symbol("code"), INT2NUM(cmd->headers.code));

  VALUE fields = rb_hash_new();
  switch (cmd->headers.type) {
  // Replies to CMD_PARAM_TYPE_SENDVAL
  case CMD_TYPE_SENDVAL_REPLY:
    switch (cmd->headers.code) {
    case CMD_VAL_REMOTE_DIAG:
    {
      cmd_diag_t * diag = &cmd->data.diag;

      sprintf(val_buf, "v%d.%d.%d", diag->version_major,
                                diag->version_minor,
                                diag->version_revision);

      rb_hash_aset(fields, make_symbol("firmware_version"), rb_str_new2(val_buf));
      rb_hash_aset(fields, make_symbol("modem_status"),     INT2NUM(diag->modem_status));
      rb_hash_aset(fields, make_symbol("modem_signal"),     INT2NUM(diag->modem_signal));
      rb_hash_aset(fields, make_symbol("gps_status"),       INT2NUM(diag->gps_status));

      sprintf(val_buf, "%.02fV", (diag->int_voltage / 100.0));
      rb_hash_aset(fields, make_symbol("int_voltage"),      rb_str_new2(val_buf));

      sprintf(val_buf, "%.02fV", (diag->ext_voltage / 100.0));
      rb_hash_aset(fields, make_symbol("ext_voltage"),      rb_str_new2(val_buf));
      break;
    }
    case CMD_VAL_REMOTE_DIAG2:
    {
      cmd_diag2_t * diag2 = &cmd->data.diag2;

      sprintf(val_buf, "v%d.%d.%d", diag2->version_major,
                                    diag2->version_minor,
                                    diag2->version_revision);

      rb_hash_aset(fields, make_symbol("firmware_version"), rb_str_new2(val_buf));
      rb_hash_aset(fields, make_symbol("modem_status"),     INT2NUM(diag2->modem_status));
      rb_hash_aset(fields, make_symbol("modem_signal"),     INT2NUM(diag2->modem_signal));
      rb_hash_aset(fields, make_symbol("gps_fix"),          INT2NUM(diag2->gps_fix));
      rb_hash_aset(fields, make_symbol("gps_satellites"),   INT2NUM(diag2->gps_satellites));

      if (diag2->has_int_voltage) {
        sprintf(val_buf, "%.02fV", (diag2->int_voltage / 100.0));
        rb_hash_aset(fields, make_symbol("int_voltage"),    rb_str_new2(val_buf));
      }

      if (diag2->has_ext_voltage) {
        sprintf(val_buf, "%.02fV", (diag2->ext_voltage / 100.0));
        rb_hash_aset(fields, make_symbol("ext_voltage"),    rb_str_new2(val_buf));
      }

      if (diag2->has_temperature) {
        sprintf(val_buf, "%dF", diag2->temperature);
        rb_hash_aset(fields, make_symbol("temperature"),    rb_str_new2(val_buf));
      }

      for (int i = 0; i < GPRS_CMD_DIAG_INPUTS_MAX; i++) {
        if (diag2->input_present[i]) {
          sprintf(key_buf, "input_%d", i + 1);
          rb_hash_aset(fields, make_symbol(key_buf),        INT2NUM(diag2->input_values[i]));
        }
      }

      for (int i = 0; i < GPRS_CMD_DIAG_OUTPUTS_MAX; i++) {
        if (diag2->output_present[i]) {
          sprintf(key_buf, "output_%d", i + 1);
          rb_hash_aset(fields, make_symbol(key_buf),        INT2NUM(diag2->output_values[i]));
        }
      }

      for (int i = 0; i < GPRS_CMD_DIAG_ANALOGS_MAX; i++) {
        if (diag2->analog_present[i]) {
          sprintf(key_buf, "analog_%d", i + 1);
          sprintf(val_buf, "%.02fV", (diag2->analog_values[i] / 1000.0));
          rb_hash_aset(fields, make_symbol(key_buf),        rb_str_new2(val_buf));
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

  // Only add fields if we read them from the command
  if (NUM2INT(rb_hash_size(fields)) > 0) {
    rb_hash_aset(hash, make_symbol("fields"), fields);
  }

  return hash;
}

VALUE hash_from_report(report_t report)
{
  VALUE hash = rb_hash_new();
  struct tm time = report_stotm(report.time);
  char time_str[80];
  double latitude = report_stolat(report.lat, report.lat_south);
  double longitude = report_stolon(report.lon, report.lon_west);

  strftime(time_str, sizeof(time_str), "%Y-%m-%dT%H:%M:%S+00:00", &time);

  rb_hash_aset(hash, make_symbol("device_id"),    INT2NUM(report.device_id));
  rb_hash_aset(hash, make_symbol("time_secs"),    INT2NUM(report.time));
  rb_hash_aset(hash, make_symbol("time"),         rb_str_new2(time_str));
  if (report.has_gps) {
    rb_hash_aset(hash, make_symbol("gps_valid"),  INT2NUM(!report.gps_invalid));
    rb_hash_aset(hash, make_symbol("latitude"),   DBL2NUM(latitude));
    rb_hash_aset(hash, make_symbol("longitude"),  DBL2NUM(longitude));
    rb_hash_aset(hash, make_symbol("speed"),      INT2NUM(report.speed));
  }
  if (report.has_cog) {
    rb_hash_aset(hash, make_symbol("cog"),        INT2NUM(report.cog));
  }
  rb_hash_aset(hash, make_symbol("report_type"),  INT2NUM(report.type));
  if (report_has_code(report.type)) {
    rb_hash_aset(hash, make_symbol("code"),       INT2NUM(report.code));
  }
  if (report.has_modsts) {
    rb_hash_aset(hash, make_symbol("modsts"),     INT2NUM(report.modsts));
  }
  if (report.has_temp) {
    rb_hash_aset(hash, make_symbol("temperature"),INT2NUM(report.temp));
  }
  if (report.has_cell) {
    rb_hash_aset(hash, make_symbol("cell_id"),    INT2NUM(report.cell_id));
    rb_hash_aset(hash, make_symbol("signal_csq"), INT2NUM(report.signal));
  }
  if (report.has_lac) {
    rb_hash_aset(hash, make_symbol("lac"),        INT2NUM(report.lac));
  }
  rb_hash_aset(hash, make_symbol("input_1"),      INT2NUM(report.input_1));
  rb_hash_aset(hash, make_symbol("input_2"),      INT2NUM(report.input_2));
  rb_hash_aset(hash, make_symbol("output_1"),     INT2NUM(report.output_1));
  rb_hash_aset(hash, make_symbol("output_2"),     INT2NUM(report.output_2));

  switch (report.type) {
  case REPORT_TYPE_EXTENDED_DATA:
  {
    VALUE ext    = rb_hash_new();

    switch (report.ext_type) {
    case REPORT_DATA_TYPE_ADDITIONAL_IO:
    {
      additional_io_t * addio = &report.ext.additional_io;
      if (addio->has_int_voltage) {
        double int_voltage = report_cvtov(addio->int_voltage);
        rb_hash_aset(ext, make_symbol("int_voltage"),     DBL2NUM(int_voltage));
      }
      if (addio->has_ext_voltage) {
        double ext_voltage = report_cvtov(addio->ext_voltage);
        rb_hash_aset(ext, make_symbol("ext_voltage"),     DBL2NUM(ext_voltage));
      }
      if (addio->has_adc_input_1) {
        rb_hash_aset(ext, make_symbol("analog_input_1"),  INT2NUM(addio->adc_input_1));
      }
      if (addio->has_adc_input_2) {
        rb_hash_aset(ext, make_symbol("analog_input_2"),  INT2NUM(addio->adc_input_2));
      }
      if (addio->has_input_3) {
        rb_hash_aset(ext, make_symbol("input_3"),         INT2NUM(addio->input_3));
      }
      if (addio->has_output_3) {
        rb_hash_aset(ext, make_symbol("output_3"),        INT2NUM(addio->output_3));
      }
      if (addio->has_orientation) {
        rb_hash_aset(ext, make_symbol("orientation"),     INT2NUM(addio->orientation));
      }
      break;
    }
    case REPORT_DATA_TYPE_FC_TXN_COMPLETE:
    {
      fc_txn_t * txn = &report.ext.fc_txn;
      rb_hash_aset(ext, make_symbol("fc_txn_id"),         INT2NUM(txn->txn_id));
      rb_hash_aset(ext, make_symbol("fc_ticks"),          INT2NUM(txn->ticks));
      break;
    }
    default:
      // Do nothing
      break;
    }

    rb_hash_aset(hash, make_symbol("ext_type"),           INT2NUM(report.ext_type));
    rb_hash_aset(hash, make_symbol("ext"),                ext);

    break;
  }
  default:
    // Do nothing;
    break;
  }

  return hash;
}

VALUE hash_from_report_raw(report_t report)
{
  VALUE hash = rb_hash_new();

  rb_hash_aset(hash, make_symbol("ref"),          INT2NUM(report.ref));
  rb_hash_aset(hash, make_symbol("has_cell"),     INT2NUM(report.has_cell));
  rb_hash_aset(hash, make_symbol("has_gps"),      INT2NUM(report.has_gps));
  rb_hash_aset(hash, make_symbol("report_type"),  INT2NUM(report.type));
  rb_hash_aset(hash, make_symbol("has_modsts"),   INT2NUM(report.has_modsts));
  rb_hash_aset(hash, make_symbol("has_temp"),     INT2NUM(report.has_temp));
  rb_hash_aset(hash, make_symbol("id_len"),       INT2NUM(report.id_len));
  rb_hash_aset(hash, make_symbol("lat_south"),    INT2NUM(report.lat_south));
  rb_hash_aset(hash, make_symbol("lon_west"),     INT2NUM(report.lon_west));
  rb_hash_aset(hash, make_symbol("has_cog"),      INT2NUM(report.has_cog));
  rb_hash_aset(hash, make_symbol("has_lac"),      INT2NUM(report.has_lac));
  rb_hash_aset(hash, make_symbol("time_secs"),    INT2NUM(report.time));
  rb_hash_aset(hash, make_symbol("device_id"),    INT2NUM(report.device_id));
  rb_hash_aset(hash, make_symbol("lat"),          INT2NUM(report.lat));
  rb_hash_aset(hash, make_symbol("gps_invalid"),  INT2NUM(report.gps_invalid));
  rb_hash_aset(hash, make_symbol("lon"),          INT2NUM(report.lon));
  rb_hash_aset(hash, make_symbol("speed"),        INT2NUM(report.speed));
  rb_hash_aset(hash, make_symbol("cog"),          INT2NUM(report.cog));
  rb_hash_aset(hash, make_symbol("code"),         INT2NUM(report.code));
  rb_hash_aset(hash, make_symbol("modsts"),       INT2NUM(report.modsts));
  rb_hash_aset(hash, make_symbol("temp"),         INT2NUM(report.temp));
  rb_hash_aset(hash, make_symbol("cell_id"),      INT2NUM(report.cell_id));
  rb_hash_aset(hash, make_symbol("signal_csq"),   INT2NUM(report.signal));
  rb_hash_aset(hash, make_symbol("lac"),          INT2NUM(report.lac));
  rb_hash_aset(hash, make_symbol("input_1"),      INT2NUM(report.input_1));
  rb_hash_aset(hash, make_symbol("input_2"),      INT2NUM(report.input_2));
  rb_hash_aset(hash, make_symbol("output_1"),     INT2NUM(report.output_1));
  rb_hash_aset(hash, make_symbol("output_2"),     INT2NUM(report.output_2));

  switch (report.type) {
  case REPORT_TYPE_EXTENDED_DATA:
  {
    VALUE ext = rb_hash_new();

    switch (report.ext_type) {
    case REPORT_DATA_TYPE_ADDITIONAL_IO:
    {
      additional_io_t * addio = &report.ext.additional_io;
      rb_hash_aset(ext, make_symbol("has_int_voltage"), INT2NUM(addio->has_int_voltage));
      rb_hash_aset(ext, make_symbol("has_ext_voltage"), INT2NUM(addio->has_ext_voltage));
      rb_hash_aset(ext, make_symbol("has_adc_input_1"), INT2NUM(addio->has_adc_input_1));
      rb_hash_aset(ext, make_symbol("has_adc_input_2"), INT2NUM(addio->has_adc_input_2));
      rb_hash_aset(ext, make_symbol("has_input_3"),     INT2NUM(addio->has_input_3));
      rb_hash_aset(ext, make_symbol("has_output_3"),    INT2NUM(addio->has_output_3));
      rb_hash_aset(ext, make_symbol("has_orientation"), INT2NUM(addio->has_orientation));
      rb_hash_aset(ext, make_symbol("int_voltage"),     INT2NUM(addio->int_voltage));
      rb_hash_aset(ext, make_symbol("ext_voltage"),     INT2NUM(addio->ext_voltage));
      rb_hash_aset(ext, make_symbol("adc_input_1"),     INT2NUM(addio->adc_input_1));
      rb_hash_aset(ext, make_symbol("adc_input_2"),     INT2NUM(addio->adc_input_2));
      rb_hash_aset(ext, make_symbol("input_3"),         INT2NUM(addio->input_3));
      rb_hash_aset(ext, make_symbol("output_3"),        INT2NUM(addio->output_3));
      rb_hash_aset(ext, make_symbol("orientation"),     INT2NUM(addio->orientation));
      break;
    }
    case REPORT_DATA_TYPE_FC_TXN_COMPLETE:
    {
      fc_txn_t * txn = &report.ext.fc_txn;
      rb_hash_aset(ext, make_symbol("fc_txn_id"),       INT2NUM(txn->txn_id));
      rb_hash_aset(ext, make_symbol("fc_ticks"),        INT2NUM(txn->ticks));
      break;
    }
    default:
      break;
    }

    rb_hash_aset(hash, make_symbol("ext_type"),         INT2NUM(report.ext_type));
    rb_hash_aset(hash, make_symbol("ext"),              ext);

    break;
  }
  default:
    // Do nothing
    break;
  }


  return hash;
}

int data_to_packet(VALUE data, uint8_t * packet)
{
  int i;
  int size = (int)RARRAY_LEN(data);

  // Convert Ruby array to uint8_t
  for (i = 0; i < size; i++) {
    packet[i] = NUM2UINT(rb_ary_entry(data, i));
  }

  return size;
}

VALUE packet_type(VALUE self, VALUE data, VALUE print)
{
  uint8_t packet[GPRS_PACKET_MAX_SIZE];
  int size = data_to_packet(data, packet);
  bool verbose = (print == Qtrue);
  int rc, type = GPRS_PACKET_UNKNOWN;

  // Size limit
  if (size > GPRS_PACKET_MAX_SIZE) size = GPRS_PACKET_MAX_SIZE;

  rc = gprs_preprocess(packet, &size, verbose);
  if (rc == GPRS_RC_SUCCESS) {
    type = gprs_packet_type(packet, size);
  } else {
    if (verbose) printf("Invalid GPRS packet! Error: %d\n", rc);
  }

  return INT2NUM(type);
}

VALUE packet_parse(VALUE self, VALUE data, VALUE print)
{
  uint8_t packet[GPRS_PACKET_MAX_SIZE];
  int size = data_to_packet(data, packet);
  bool verbose = (print == Qtrue);
  int i, rc, count;
  VALUE results = rb_ary_new();

  // Size limit
  if (size > GPRS_PACKET_MAX_SIZE) size = GPRS_PACKET_MAX_SIZE;

  // Preprocess
  rc = gprs_preprocess(packet, &size, verbose);
  if (rc == GPRS_RC_SUCCESS) {
    int type = gprs_packet_type(packet, size);

    if (type == GPRS_PACKET_COMMAND) {
      cmd_t cmd;

      // Parse command
      cmd_parse(packet, size, &cmd);

      // Create hash for report
      VALUE result = hash_from_command(&cmd);

      // Add to array
      rb_ary_push(results, result);
    } else if (type == GPRS_PACKET_REPORT) {
      report_t reports[10];

      // Parse report
      count = report_parse(packet, size, reports);

      for (i = 0; i < count; i++) {
        // Create hash for report
        VALUE result = hash_from_report(reports[i]);

        // Add to array
        rb_ary_push(results, result);
      }
    } else {
      if (verbose) printf("Don't know how to parse packet of type %d\n", type);
    }
  } else {
    if (verbose) printf("Invalid GPRS packet! Error: %d\n", rc);
  }

  return results;
}
