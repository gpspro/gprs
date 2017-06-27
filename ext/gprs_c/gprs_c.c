
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
VALUE packet_process(VALUE self, VALUE data, VALUE print);


void Init_gprs_c()
{
  gprs = rb_define_module("GprsC");
  rb_define_singleton_method(gprs, "packet_type_c", packet_type, 2);
  rb_define_singleton_method(gprs, "packet_parse_c", packet_parse, 2);
  rb_define_singleton_method(gprs, "packet_parse_c", packet_parse, 2);
  rb_define_singleton_method(gprs, "packet_process_c", packet_process, 2);
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
  VALUE subfields = rb_hash_new();
  switch (cmd->headers.type) {
  // CMD_TYPE_CONFIG_MSG requests
  case CMD_TYPE_CONFIG_MSG:
    switch (cmd->headers.code) {
    case CMD_PARAM_TYPE_POSITION:
      // No fields
      break;
    case CMD_PARAM_TYPE_SENDVAL:
      rb_hash_aset(fields, make_symbol("sendval_request"),  INT2NUM(cmd->data.sendval_request));
      break;;
    case CMD_PARAM_TYPE_REQUEST_PARAM:
      rb_hash_aset(fields, make_symbol("param_request"),    INT2NUM(cmd->data.param_request));
      break;
    case CMD_PARAM_TYPE_FC_PUMP:
    {
      cmd_req_fc_pump_t * fc_pump = &cmd->data.req_fc_pump;

      rb_hash_aset(subfields, make_symbol("txn_id"),        INT2NUM(fc_pump->txn_id));
      rb_hash_aset(subfields, make_symbol("timeout"),       INT2NUM(fc_pump->timeout));
      rb_hash_aset(subfields, make_symbol("reset"),         INT2NUM(fc_pump->reset));
      rb_hash_aset(subfields, make_symbol("max"),           INT2NUM(fc_pump->max));
      rb_hash_aset(subfields, make_symbol("function"),      INT2NUM(fc_pump->function));
      rb_hash_aset(fields,    make_symbol("fc_pump"),       subfields);

      break;
    }
    case CMD_PARAM_TYPE_ANALOG_EXT:
    {
      cmd_req_analog_ext_t * analog_ext = &cmd->data.req_analog_ext;

      rb_hash_aset(subfields, make_symbol("analog"),        INT2NUM(analog_ext->analog));
      rb_hash_aset(subfields, make_symbol("format"),        INT2NUM(analog_ext->format));
      rb_hash_aset(subfields, make_symbol("action"),        INT2NUM(analog_ext->action));
      rb_hash_aset(fields,    make_symbol("analog_ext"),    subfields);

      break;
    }
    case CMD_PARAM_TYPE_ANALOG_GET:
      rb_hash_aset(subfields, make_symbol("analog"),        INT2NUM(cmd->data.req_analog_get));
      rb_hash_aset(fields,    make_symbol("analog_get"),    subfields);
      break;
    case CMD_PARAM_TYPE_INPUT_GET:
      rb_hash_aset(subfields, make_symbol("input"),         INT2NUM(cmd->data.req_input_get));
      rb_hash_aset(fields,    make_symbol("input_get"),     subfields);
      break;
    case CMD_PARAM_TYPE_OUTPUT_GET:
      rb_hash_aset(subfields, make_symbol("output"),        INT2NUM(cmd->data.req_output_get));
      rb_hash_aset(fields,    make_symbol("output_get"),    subfields);
      break;

    case CMD_PARAM_TYPE_OUTPUT_SET:
    {
      cmd_req_output_set_t * oset = &cmd->data.req_output_set;

      rb_hash_aset(subfields, make_symbol("output"),        INT2NUM(oset->output));
      switch (oset->mode) {
      case CMD_OUTPUT_MODE_OFF:           sprintf(val_buf, "off");      break;
      case CMD_OUTPUT_MODE_ON:            sprintf(val_buf, "on");       break;
      case CMD_OUTPUT_MODE_OFF_RULE_AND:  sprintf(val_buf, "off_and");  break;
      case CMD_OUTPUT_MODE_ON_RULE_AND:   sprintf(val_buf, "on_and");   break;
      default:                            sprintf(val_buf, "unknown");  break;
      }
      rb_hash_aset(subfields, make_symbol("mode"),          rb_str_new2(val_buf));

      if (oset->rule_count > 0) {
        VALUE rules = rb_ary_new();
        for (int i = 0; i < oset->rule_count; i++) {
          output_set_rule_t * rule = &oset->rules[i];
          VALUE rule_hash = rb_hash_new();

          switch (rule->code) {
          case CMD_OUTPUT_RULE_GPS_SPEED:         sprintf(val_buf, "gps_speed"); break;
          case CMD_OUTPUT_RULE_ACC_MOVEMENT:      sprintf(val_buf, "acc_movement"); break;
          case CMD_OUTPUT_RULE_ACC_ORIENT:        sprintf(val_buf, "acc_orient"); break;
          case CMD_OUTPUT_RULE_INT_VOLTAGE:       sprintf(val_buf, "int_voltage"); break;
          case CMD_OUTPUT_RULE_EXT_VOLTAGE:       sprintf(val_buf, "ext_voltage"); break;
          case CMD_OUTPUT_RULE_INPUT_1:           sprintf(val_buf, "input_1"); break;
          case CMD_OUTPUT_RULE_INPUT_2:           sprintf(val_buf, "input_2"); break;
          case CMD_OUTPUT_RULE_INPUT_3:           sprintf(val_buf, "input_3"); break;
          case CMD_OUTPUT_RULE_OUTPUT_1:          sprintf(val_buf, "output_1"); break;
          case CMD_OUTPUT_RULE_OUTPUT_2:          sprintf(val_buf, "output_2"); break;
          case CMD_OUTPUT_RULE_OUTPUT_3:          sprintf(val_buf, "output_3"); break;
          case CMD_OUTPUT_RULE_ANALOG_1_LEVEL:    sprintf(val_buf, "analog_1_level"); break;
          case CMD_OUTPUT_RULE_ANALOG_2_LEVEL:    sprintf(val_buf, "analog_2_level"); break;
          case CMD_OUTPUT_RULE_ANALOG_1_VOLTAGE:  sprintf(val_buf, "analog_1_voltage"); break;
          case CMD_OUTPUT_RULE_ANALOG_2_VOLTAGE:  sprintf(val_buf, "analog_2_voltage"); break;
          case CMD_OUTPUT_RULE_TEMPERATURE:       sprintf(val_buf, "temperature"); break;
          default:                                sprintf(val_buf, "unknown");  break;
          }
          rb_hash_aset(rule_hash, make_symbol("code"),      rb_str_new2(val_buf));

          switch (rule->cond) {
          case CMD_OUTPUT_RULE_COND_EQ:           sprintf(val_buf, "eq"); break;
          case CMD_OUTPUT_RULE_COND_NOTEQ:        sprintf(val_buf, "noteq"); break;
          case CMD_OUTPUT_RULE_COND_LT:           sprintf(val_buf, "lt"); break;
          case CMD_OUTPUT_RULE_COND_GT:           sprintf(val_buf, "gt"); break;
          case CMD_OUTPUT_RULE_COND_LTEQ:         sprintf(val_buf, "lteq"); break;
          case CMD_OUTPUT_RULE_COND_GTEQ:         sprintf(val_buf, "gteq"); break;
          case CMD_OUTPUT_RULE_COND_MIN:          sprintf(val_buf, "min"); break;
          case CMD_OUTPUT_RULE_COND_MAX:          sprintf(val_buf, "max"); break;
          }
          rb_hash_aset(rule_hash, make_symbol("condition"),       rb_str_new2(val_buf));
          rb_hash_aset(rule_hash, make_symbol("condition_value"), INT2NUM(rule->value));

          rb_ary_push(rules, rule_hash);
        }
        rb_hash_aset(subfields, make_symbol("rules"), rules);
      }

      rb_hash_aset(fields,    make_symbol("output_set"),    subfields);

      break;
    }
    default:
      break;
    }
    break;

  // Replies to CMD_PARAM_TYPE_SENDVAL
  case CMD_TYPE_SENDVAL_REPLY:
    switch (cmd->headers.code) {
    case CMD_VAL_REMOTE_DIAG:
    {
      cmd_resp_diag_t * diag = &cmd->data.diag;

      sprintf(val_buf, "v%d.%d.%d", diag->version_major,
                                diag->version_minor,
                                diag->version_revision);

      rb_hash_aset(subfields, make_symbol("firmware_version"),  rb_str_new2(val_buf));
      rb_hash_aset(subfields, make_symbol("modem_status"),      INT2NUM(diag->modem_status));
      rb_hash_aset(subfields, make_symbol("modem_signal"),      INT2NUM(diag->modem_signal));
      rb_hash_aset(subfields, make_symbol("gps_status"),        INT2NUM(diag->gps_status));

      sprintf(val_buf, "%.02fV", (diag->int_voltage / 100.0));
      rb_hash_aset(subfields, make_symbol("int_voltage"),       rb_str_new2(val_buf));

      sprintf(val_buf, "%.02fV", (diag->ext_voltage / 100.0));
      rb_hash_aset(subfields, make_symbol("ext_voltage"),       rb_str_new2(val_buf));
      rb_hash_aset(fields,    make_symbol("diag"),              subfields);
      break;
    }
    case CMD_VAL_REMOTE_DIAG2:
    {
      cmd_resp_diag2_t * diag2 = &cmd->data.diag2;

      sprintf(val_buf, "v%d.%d.%d", diag2->version_major,
                                    diag2->version_minor,
                                    diag2->version_revision);

      rb_hash_aset(subfields, make_symbol("firmware_version"), rb_str_new2(val_buf));
      rb_hash_aset(subfields, make_symbol("modem_status"),     INT2NUM(diag2->modem_status));
      rb_hash_aset(subfields, make_symbol("modem_signal"),     INT2NUM(diag2->modem_signal));
      rb_hash_aset(subfields, make_symbol("gps_fix"),          INT2NUM(diag2->gps_fix));
      rb_hash_aset(subfields, make_symbol("gps_satellites"),   INT2NUM(diag2->gps_satellites));

      if (diag2->has_int_voltage) {
        sprintf(val_buf, "%.02fV", (diag2->int_voltage / 100.0));
        rb_hash_aset(subfields, make_symbol("int_voltage"),    rb_str_new2(val_buf));
      }

      if (diag2->has_ext_voltage) {
        sprintf(val_buf, "%.02fV", (diag2->ext_voltage / 100.0));
        rb_hash_aset(subfields, make_symbol("ext_voltage"),    rb_str_new2(val_buf));
      }

      if (diag2->has_temperature) {
        sprintf(val_buf, "%dF", diag2->temperature);
        rb_hash_aset(subfields, make_symbol("temperature"),    rb_str_new2(val_buf));
      }

      for (int i = 0; i < GPRS_CMD_DIAG_INPUTS_MAX; i++) {
        if (diag2->input_present[i]) {
          sprintf(key_buf, "input_%d", i + 1);
          rb_hash_aset(subfields, make_symbol(key_buf),        INT2NUM(diag2->input_values[i]));
        }
      }

      for (int i = 0; i < GPRS_CMD_DIAG_OUTPUTS_MAX; i++) {
        if (diag2->output_present[i]) {
          sprintf(key_buf, "output_%d", i + 1);
          rb_hash_aset(subfields, make_symbol(key_buf),        INT2NUM(diag2->output_values[i]));
        }
      }

      for (int i = 0; i < GPRS_CMD_DIAG_ANALOGS_MAX; i++) {
        if (diag2->analog_present[i]) {
          sprintf(key_buf, "analog_%d", i + 1);
          sprintf(val_buf, "%.02fV", (diag2->analog_values[i] / 1000.0));
          rb_hash_aset(subfields, make_symbol(key_buf),        rb_str_new2(val_buf));
        }
      }

      rb_hash_aset(fields,    make_symbol("diag2"),    subfields);

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

VALUE packet_to_data(uint8_t * packet, int size)
{
  VALUE data = rb_ary_new();

  // Convert uint8_t array to Ruby array
  for (int i = 0; i < size; i++) {
    rb_ary_push(data, UINT2NUM(packet[i]));
  }

  return data;
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

      if (verbose) {
        cmd_print(&cmd);
      }

      // Create hash for report
      VALUE result = hash_from_command(&cmd);

      // Add to array
      rb_ary_push(results, result);
    } else if (type == GPRS_PACKET_REPORT) {
      report_t reports[10];

      // Parse report
      count = report_parse(packet, size, reports);

      for (i = 0; i < count; i++) {
        if (verbose) {
          report_print(reports[i]);
        }

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

VALUE packet_process(VALUE self, VALUE data, VALUE print)
{
  uint8_t packet[GPRS_PACKET_MAX_SIZE];
  int size = data_to_packet(data, packet);
  bool verbose = (print == Qtrue);
  int rc;

  VALUE processedData;

  // Size limit
  if (size > GPRS_PACKET_MAX_SIZE) size = GPRS_PACKET_MAX_SIZE;

  rc = gprs_preprocess(packet, &size, verbose);
  if (rc == GPRS_RC_SUCCESS) {
    processedData = packet_to_data(packet, size);
  } else {
    if (verbose) printf("Invalid GPRS packet! Error: %d\n", rc);
  }

  return processedData;
}
