meta:
  id: sendval_reply
  endian: le
seq:
  - id: code
    type: u1

  - id: data
    type:
      switch-on: code
      cases:
        73: diag                # Sendval Reply / Diag
        74: diag2               # Sendval Reply / Diag V2

types:
  diag:
    seq:
      - id: version_major
        type: u1
      - id: version_minor
        type: u1
      - id: version_revision
        type: u1
      - id: modem_status
        type: u1
      - id: modem_signal
        type: u1
      - id: gps_status
        type: u1
      - id: int_voltage
        type: u2
      - id: ext_voltage
        type: u2

  diag2:
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
      # Inputs Active
      - id: input_value_bits
        type: b1
        repeat: expr
        repeat-expr: 4
        if: has_io
      # Inputs Present
      - id: input_presence_bits
        type: b1
        repeat: expr
        repeat-expr: 4
        if: has_io
      # Outputs Active
      - id: output_value_bits
        type: b1
        repeat: expr
        repeat-expr: 4
        if: has_io
      # Outputs Present
      - id: output_presence_bits
        type: b1
        repeat: expr
        repeat-expr: 4
        if: has_io
      - id: analogs_present_bits
        type: b1
        repeat: expr
        repeat-expr: 8
        if: has_analogs
      - id: analog_1
        type: u2
        if: analogs_present_bits[7]
      - id: analog_2
        type: u2
        if: analogs_present_bits[6]
      - id: analog_3
        type: u2
        if: analogs_present_bits[5]
      - id: analog_4
        type: u2
        if: analogs_present_bits[4]
      - id: analog_5
        type: u2
        if: analogs_present_bits[3]
      - id: analog_6
        type: u2
        if: analogs_present_bits[2]
      - id: analog_7
        type: u2
        if: analogs_present_bits[1]
      - id: analog_8
        type: u2
        if: analogs_present_bits[0]
