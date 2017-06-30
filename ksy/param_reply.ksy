meta:
  id: param_reply
  endian: le
  encoding: UTF-8
seq:
  - id: code
    type: u1

  - id: data
    type:
      switch-on: code
      cases:
        1:  move_freq           # Move Frequency Reply
        42: cell_info           # Cell Info Reply
        67: send_freq           # Send Frequency Reply
        68: stop_freq           # Stop Frequency Reply
        70: turn_detect         # Turn Detection Enabled Reply
        71: turn_angle          # Turn Angle Reply
        72: modem_apn           # Modem APN Reply
        73: gsm_ip_port         # GSM IP/Port Reply
        80: fc_pump             # FC Pump Reply
        81: output_sch_get      # Output Schedule Get Reply
        82: output_sch_set      # Output Schedule Set Reply
        83: output_sch_list     # Output Schedule List Reply
        84: output_sch_clear    # Output Schedule Clear Reply
        87: analog_ext          # Analog Ext Reply
        88: analog_get          # Analog Get Reply
        89: input_get           # Input Get Reply
        90: output_get          # Output Get Reply
        91: output_set          # Output Set Reply
        92: cdma_ip_port        # CDMA IP/Port Reply
        93: cdma_activate       # CDMA Activate Reply
        94: gsm_mode            # GSM Mode Reply
        95: gsm_network         # GSM Network Reply
        100: sleep_timeout_get  # Sleep Timeout Get Reply
        101: led_status_get     # LED Status Get Reply
enums:
  fc_pump_rc:
    0: success
    1: access_error
    2: duplicate_txn
    3: not_authorized
    4: interface_busy
    5: not_available

  output_sch_rc:
    0: success
    1: not_found
    2: schedule_full
    3: invalid_output
    4: invalid_day
    5: invalid_time
    6: invalid_value

  analog_ext_rc:
    0: success
    1: invalid_analog
    2: invalid_format
    3: invalid_action

  analog_ext_format:
    0: io
    1: level
    2: voltage

  analog_ext_action:
    0: get
    1: clear

  input_get_rc:
    0: disabled
    1: enabled
    255: invalid_input

  output_get_rc:
    0: disabled
    1: enabled
    255: invalid_output

  output_set_rc:
    0: success
    1: invalid_output
    2: invalid_mode
    3: unchanged
    4: rule_success
    5: rule_error
    6: rule_unchanged


  output_rule_error:
    0: success
    1: cond_not_met
    2: invalid_code
    3: invalid_cond
    4: invalid_value
    5: cond_no_support

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

  cdma_activation_rc:
    0: failed
    1: success

  gsm_mode:
    0: multimode
    1: gsm_umts
    2: cdma2000

  gsm_network:
    0: unknown
    1: att
    2: verizon

  led_status:
    0: hidden
    1: visible

types:
  move_freq:
    seq:
      - id: seconds
        type: u2

  cell_info:
    seq:
      - id: info
        type: u1

  send_freq:
    seq:
      - id: seconds
        type: u2

  stop_freq:
    seq:
      - id: seconds
        type: u2

  turn_detect:
    seq:
      - id: enabled
        type: u1

  turn_angle:
    seq:
      - id: angle
        type: u1

  modem_apn:
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

  gsm_ip_port:
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
      - id: rc
        type: u1
        enum: fc_pump_rc

  output_sch_get:
    seq:
      - id: rc
        type: u1
        enum: output_sch_rc
      - id: value
        type: u1

  output_sch_set:
    seq:
      - id: rc
        type: u1
        enum: output_sch_rc

  output_sch_list:
    seq:
      - id: has_more
        type: b1
      - id: count
        type: b7
      - id: items
        type: output_sch_item
        repeat: expr
        repeat-expr: count

  output_sch_item:
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

  output_sch_clear:
    seq:
      - id: count
        type: u1

  analog_ext:
    seq:
      - id: rc
        type: u1
        enum: analog_ext_rc
      - id: analog
        type: u1
      - id: format
        type: u1
        enum: analog_ext_format
      - id: action
        type: u1
        enum: analog_ext_action
      - id: value
        type:
          switch-on: format
          cases:
            analog_ext_format::io:      u2
            analog_ext_format::level:   u1
            analog_ext_format::voltage: u2
      - id: min
        type:
          switch-on: format
          cases:
            analog_ext_format::io:      u2
            analog_ext_format::level:   u1
            analog_ext_format::voltage: u2
      - id: max
        type:
          switch-on: format
          cases:
            analog_ext_format::io:      u2
            analog_ext_format::level:   u1
            analog_ext_format::voltage: u2

  analog_get:
    seq:
      - id: voltage
        type: u2

  input_get:
    seq:
      - id: rc
        type: u1
        enum: input_get_rc

  output_get:
    seq:
      - id: rc
        type: u1
        enum: output_get_rc

  output_set:
    seq:
      - id: rc
        type: u1
        enum: output_set_rc
      - id: error_count
        type: u1
        if: rc == output_set_rc::rule_error
      - id: errors
        type: output_rule_error
        repeat: expr
        repeat-expr: error_count
        if: rc == output_set_rc::rule_error

  output_rule_error:
    seq:
      - id: error
        type: u1
        enum: output_rule_error
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
            output_rule_code::int_voltage:      u2
            output_rule_code::ext_voltage:      u2
            output_rule_code::analog_1_voltage: u2
            output_rule_code::analog_2_voltage: u2
            # Everything else is 1 byte
            _:                                  u1

  cdma_ip_port:
    seq:
      - id: ip_address_bytes
        type: u1
        repeat: expr
        repeat-expr: 4
      - id: remote_port
        type: u2
      - id: local_port
        type: u2

  cdma_activate:
    seq:
      - id: rc
        type: u1
        enum: cdma_activation_rc

  gsm_mode:
    seq:
      - id: mode
        type: u1
        enum: gsm_mode

  gsm_network:
    seq:
      - id: network
        type: u1
        enum: gsm_network

  sleep_timeout_get:
    seq:
      - id: timeout
        type: u2

  led_status_get:
    seq:
      - id: status
        type: u1
        enum: led_status
