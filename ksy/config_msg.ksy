meta:
  id: config_msg
  endian: le
  encoding: UTF-8
seq:
  - id: code
    type: u1

  - id: data
    type:
      switch-on: code
      cases:
        1:  move_freq_set       # Move Frequency Set Request
        20: sendval_request     # Sendval Request
        31: param_request       # Param Request
        42: cell_info_set       # Cell Info Set Request
        67: send_freq_set       # Send Frequency Set Request
        68: stop_freq_set       # Stop Frequency Set Request
        70: turn_detect_set     # Turn Detect Set Request
        71: turn_angle_set      # Turn Angle Set Request
        72: gsm_apn_set         # GSM APN Set Request
        73: gsm_ip_port_set     # GSM IP/Port Set Request
        80: fc_pump             # FC Pump Request
        81: output_sch_get      # Output Schedule Get Request
        82: output_sch_set      # Output Schedule Set Request
        83: output_sch_list     # Output Schedule List Request
        87: analog_ext          # Analog Ext Request
        88: analog_get          # Analog Get Request
        89: input_get           # Input Get Request
        90: output_get          # Output Get Request
        91: output_set          # Output Set Request
        92: cdma_ip_port_set    # CDMA IP/Port Set Request
        94: gsm_mode_set        # GSM Mode Set Request
        100: sleep_timeout_set  # Sleep Timeout Set Request
        101: led_status_set     # LED Status Set Request
        130: unit_id_set        # Unit ID Set Request

types:
  move_freq_set:
    seq:
      - id: seconds
        type: u2

  sendval_request:
    seq:
      - id: code
        type: u1

  param_request:
    seq:
      - id: code
        type: u1

  cell_info_set:
    seq:
      - id: enabled
        type: u1

  send_freq_set:
    seq:
      - id: seconds
        type: u2

  stop_freq_set:
    seq:
      - id: seconds
        type: u2

  turn_detect_set:
    seq:
      - id: enabled
        type: u1

  turn_angle_set:
    seq:
      - id: angle
        type: u1

  gsm_apn_set:
    seq:
      - id: apn_len
        type: u1
      - id: apn
        type: str
        size: apn_len
      - id: user_len
        type: u1
      - id: user
        type: str
        size: user_len
      - id: pass_len
        type: u1
      - id: pass
        type: str
        size: pass_len

  gsm_ip_port_set:
    seq:
      - id: ip_address_bytes
        type: u1
        repeat: expr
        repeat-expr: 4
      - id: remote_port
        type: u2
      - id: local_port
        type: u2

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
        if: mode == 2 or mode == 3
      - id: rules
        type: output_set_rule
        repeat: expr
        repeat-expr: rule_count
        if: mode == 2 or mode == 3

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

  cdma_ip_port_set:
    seq:
      - id: ip_address_bytes
        type: u1
        repeat: expr
        repeat-expr: 4
      - id: remote_port
        type: u2
      - id: local_port
        type: u2

  gsm_mode_set:
    seq:
      - id: mode
        type: u1

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
