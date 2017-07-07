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
        if: mode == 3 or mode == 4
      - id: rules
        type: output_set_rule
        repeat: expr
        repeat-expr: rule_count
        if: mode == 3 or mode == 4

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
            # Some codes need 2 byte values
            4:  u2    # Int Voltage
            6:  u2    # Ext Voltage
            20: u2    # Analog 1 Voltage
            21: u2    # Analog 2 Voltage
            # Everything else is 1 byte
            _: u1

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
