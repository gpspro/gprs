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
      - id: gps_satellites
        type: b6
      - id: gps_fix
        type: b2
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
      - id: input_value
        type: b1
        repeat: expr
        repeat-expr: 4
        if: has_io
      # Inputs Present
      - id: input_present
        type: b1
        repeat: expr
        repeat-expr: 4
        if: has_io
      # Outputs Active
      - id: output_value
        type: b1
        repeat: expr
        repeat-expr: 4
        if: has_io
      # Outputs Present
      - id: output_present
        type: b1
        repeat: expr
        repeat-expr: 4
        if: has_io
      - id: analog_present
        type: b1
        repeat: expr
        repeat-expr: 8
        if: has_analogs
      - id: analog_value
        type: u2
        repeat: eos
