
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>

#include <ruby.h>

#include "gprs.h"
#include "report.h"

VALUE gprs = Qnil;

VALUE parse_report(VALUE self, VALUE data, VALUE print);

void Init_gprs_c()
{
  gprs = rb_define_module("GprsC");
  rb_define_singleton_method(gprs, "parse_report", parse_report, 2);
}

VALUE parse_report(VALUE self, VALUE data, VALUE print)
{
  int size = RARRAY_LEN(data);
  uint8_t packet[size];
  report_t reports[10];
  int i, rc;

  // Convert Ruby array to uint8_t
  for (i = 0; i < size; i++) {
    packet[i] = NUM2UINT(rb_ary_entry(data, i));
  }

  // Preprocess
  rc = gprs_preprocess(packet, &size);
  if (rc != GPRS_RC_SUCCESS) {
    printf("Invalid report packet!\n");
    return Qfalse;
  }

  // Parse report
  report_parse(packet, size, reports);
  if (print) {
    report_print(reports[0]);
  }

  return Qtrue;
}
