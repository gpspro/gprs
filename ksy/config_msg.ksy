meta:
  id: config_msg
  endian: le
seq:
  - id: code
    type: u1

  - id: data
    type:
      switch-on: code
      cases:
        20: sendval_request     # Sendval Request
        31: param_request       # Param Request
        80: fc_pump             # FC Pump Request
        81: output_sch_get      # Output Schedule Get Request
        82: output_sch_set      # Output Schedule Set Request
        83: output_sch_list     # Output Schedule List Request
        87: analog_ext          # Analog Ext Request
        88: analog_get          # Analog Get Request
        89: input_get           # Input Get Request
        90: output_get          # Output Get Request
        91: output_set          # Output Set Request
        100: sleep_timeout_set  # Sleep Timeout Set Request
        101: led_status_set     # LED Status Set Request
        130: unit_id_set        # Unit ID Set Request

enums:
  output_list_mode:
    0: first
    1: next

  analog_ext_format:
    0: io
    1: level
    2: voltage

  analog_ext_action:
    0: get
    1: clear

  output_set_mode:
    0: turn_off
    1: turn_on
    2: turn_off_and
    3: turn_on_and

  output_rule_code:
    0: none
    1: gps_speed
    2: acc_movement
    3: acc_orient
    4: int_voltage
    6: ext_voltage
    10: input_1
    11: input_2
    12: input_3
    13: input_4
    14: output_1
    15: output_2
    16: output_3
    17: output_4
    18: analog_1_level
    19: analog_2_level
    20: analog_1_voltage
    21: analog_2_voltage

  output_rule_cond:
    0: eq
    1: noteq
    2: lt
    3: gt
    4: lteq
    5: gteq
    6: min
    7: max

types:
  sendval_request:
    seq:
      - id: code
        type: u1

  param_request:
    seq:
      - id: code
        type: u1

  fc_pump:
    seq:
      - id: txn_id
        type: u4
      - id: timeout
        type: u4
      - id: reset
        type: u4
      - id: max
        type: u4
      - id: function
        type: u1

  output_sch_get:
    seq:
      - id: output
        type: u1
      - id: day
        type: u1
      - id: hour
        type: u1
      - id: minute
        type: u1

  output_sch_set:
    seq:
      - id: output
        type: u1
      - id: day
        type: u1
      - id: hour
        type: u1
      - id: minute
        type: u1
      - id: value
        type: u1

  output_sch_list:
    seq:
      - id: list_mode
        type: u1
        enum: output_list_mode

  analog_ext:
    seq:
      - id: analog
        type: u1
      - id: format
        type: u1
        enum: analog_ext_format
      - id: action
        type: u1
        enum: analog_ext_action

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
        enum: output_set_mode
      - id: rule_count
        type: u1
        if: mode == output_set_mode::turn_off_and or mode == output_set_mode::turn_on_and
      - id: rules
        type: output_set_rule
        repeat: expr
        repeat-expr: rule_count

  output_set_rule:
    seq:
      - id: code
        type: u1
        enum: output_rule_code
      - id: cond
        type: u1
        enum: output_rule_cond
      - id: value
        type:
          switch-on: code
          cases:
            # Some codes need 2 byte values
            output_rule_code::int_voltage:       u2
            output_rule_code::ext_voltage:       u2
            output_rule_code::analog_1_voltage:  u2
            output_rule_code::analog_2_voltage:  u2
            # Everything else is 1 byte
            _:                            u1

  sleep_timeout_set:
    seq:
      - id: timeout
        type: u2

  led_status_set:
    seq:
      - id: status
        type: u1

  unit_id_set:
    seq:
      - id: unit_id
        type: u4
