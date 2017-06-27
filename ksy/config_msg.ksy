meta:
  id: config_msg
  endian: le
  imports:
    - config_msg/fc_pump
seq:
  - id: code
    type: u1

  # Config Msg / Sendval Request
  - id: data
    type: sendval_request
    if: code == 20

  # Config Msg / Param Request
  - id: data
    type: param_request
    if: code == 31

  # Config Msg / FC Pump Request
  - id: data
    type: fc_pump
    if: code == 80

  # Config Msg / Analog Ext Request
  - id: data
    type: analog_ext
    if: code == 87

  # Config Msg / Analog Get Request
  - id: data
    type: analog_get
    if: code == 88

  # Config Msg / Input Get Request
  - id: data
    type: input_get
    if: code == 89

  # Config Msg / Output Get Request
  - id: data
    type: output_get
    if: code == 90

  # Config Msg / Output Set Request
  - id: data
    type: output_set
    if: code == 91

  # Config Msg / Set Unit ID Request
  - id: data
    type: set_unitid
    if: code == 130

types:
  sendval_request:
    seq:
      - id: code
        type: u1

  param_request:
    seq:
      - id: code
        type: u1

  analog_ext:
    seq:
      - id: analog
        type: u1
      - id: format
        type: u1
      - id: action
        type: u1

  analog_get:
    seq:
      - id: analog
        type: u1

  input_get:
    seq:
      - id: input
        type: u1

  output_get:
    seq:
      - id: output
        type: u1

  output_set:
    seq:
      - id: output
        type: u1
      - id: mode
        type: u1
      - id: rule_count
        type: u1
        if: mode == 2 or mode == 3
      - id: rules
        type: output_set_rule
        repeat: expr
        repeat-expr: rule_count

  output_set_rule:
    seq:
      - id: code
        type: u1
      - id: cond
        type: u1
      - id: value
        type:
          switch-on: code
          cases:
            4: u2     # Int Voltage
            6: u2     # Ext Voltage
            20: u2    # Analog 1 Voltage
            21: u2    # Analog 2 Voltage
            _: u1     # Everything else is 1 byte

  set_unitid:
    seq:
      - id: unit_id
        type: u4
