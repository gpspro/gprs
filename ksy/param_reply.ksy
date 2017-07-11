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
        72: gsm_apn             # GSM APN Reply
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

  gsm_apn:
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

  output_sch_get:
    seq:
      - id: rc
        type: u1
      - id: value
        type: u1

  output_sch_set:
    seq:
      - id: rc
        type: u1

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
      - id: analog
        type: u1
      - id: format
        type: u1
      - id: action
        type: u1
      - id: value
        type:
          switch-on: format
          cases:
            0:  u2
            1:  u1
            2:  u2
      - id: min
        type:
          switch-on: format
          cases:
            0:  u2
            1:  u1
            2:  u2
      - id: max
        type:
          switch-on: format
          cases:
            0:  u2
            1:  u1
            2:  u2

  analog_get:
    seq:
      - id: voltage
        type: u2

  input_get:
    seq:
      - id: rc
        type: u1

  output_get:
    seq:
      - id: rc
        type: u1

  output_set:
    seq:
      - id: rc
        type: u1
      - id: error_count
        type: u1
        if: rc == 5
      - id: errors
        type: output_rule_error
        repeat: expr
        repeat-expr: error_count
        if: rc == 5

  output_rule_error:
    seq:
      - id: error
        type: u1
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

  gsm_mode:
    seq:
      - id: mode
        type: u1

  gsm_network:
    seq:
      - id: network
        type: u1

  sleep_timeout_get:
    seq:
      - id: timeout
        type: u2

  led_status_get:
    seq:
      - id: status
        type: u1
