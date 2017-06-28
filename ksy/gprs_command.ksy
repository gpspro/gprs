meta:
  id: gprs_command
  endian: le
  imports:
    - config_msg
    - sendval_reply
    - param_reply
seq:
  # Basic command params
  - id: ref
    type: b4
  - id: type
    type: b4

  - id: type_class
    type:
      switch-on: type
      cases:
        4: config_msg       # Config Msg
        6: sendval_reply    # Sendval Reply
        8: param_reply      # Param Reply
