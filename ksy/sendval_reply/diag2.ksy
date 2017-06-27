meta:
  id: diag2
  endian: le
seq:
  # Mask Bits (unused bits don't have a name)
  - type: b1
  - type: b1
  - id: has_analogs
    type: b1
  - id: has_io
    type: b1
  - type: b1
  - id: has_temperature
    type: b1
  - id: has_ext_voltage
    type: b1
  - id: has_int_voltage
    type: b1
  # Version
  - id: version_major
    type: u1
  - id: version_minor
    type: u1
  - id: version_revision
    type: u1
  # Modem
  - id: modem_status
    type: u1
  - id: modem_signal
    type: u1
  # GPS
  - id: gps_fix
    type: b2
  - id: gps_satellites
    type: b6
  # Int Voltage
  - id: int_voltage
    type: u2
    if: has_int_voltage
  # Ext Voltage
  - id: ext_voltage
    type: u2
    if: has_ext_voltage
  # Temperature
  - id: temperature
    type: u1
    if: has_temperature
  - id: input_4_present
    type: b1
    if: has_io
  - id: input_3_present
    type: b1
    if: has_io
  - id: input_2_present
    type: b1
    if: has_io
  - id: input_1_present
    type: b1
    if: has_io
  - id: input_4_active
    type: b1
    if: has_io
  - id: input_3_active
    type: b1
    if: has_io
  - id: input_2_active
    type: b1
    if: has_io
  - id: input_1_active
    type: b1
    if: has_io
  - id: output_4_present
    type: b1
    if: has_io
  - id: output_3_present
    type: b1
    if: has_io
  - id: output_2_present
    type: b1
    if: has_io
  - id: output_1_present
    type: b1
    if: has_io
  - id: output_4_active
    type: b1
    if: has_io
  - id: output_3_active
    type: b1
    if: has_io
  - id: output_2_active
    type: b1
    if: has_io
  - id: output_1_active
    type: b1
    if: has_io
  - id: analog_8_present
    type: b1
    if: has_analogs
  - id: analog_7_present
    type: b1
    if: has_analogs
  - id: analog_6_present
    type: b1
    if: has_analogs
  - id: analog_5_present
    type: b1
    if: has_analogs
  - id: analog_4_present
    type: b1
    if: has_analogs
  - id: analog_3_present
    type: b1
    if: has_analogs
  - id: analog_2_present
    type: b1
    if: has_analogs
  - id: analog_1_present
    type: b1
    if: has_analogs
  - id: analog_1
    type: u2
    if: analog_1_present
  - id: analog_2
    type: u2
    if: analog_2_present
  - id: analog_3
    type: u2
    if: analog_3_present
  - id: analog_4
    type: u2
    if: analog_4_present
  - id: analog_5
    type: u2
    if: analog_5_present
  - id: analog_6
    type: u2
    if: analog_6_present
  - id: analog_7
    type: u2
    if: analog_7_present
  - id: analog_8
    type: u2
    if: analog_8_present
