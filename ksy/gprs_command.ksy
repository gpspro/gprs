meta:
  id: gprs_command
  endian: le
  imports:
    - config_msg
    - sendval_reply
seq:
  # Basic command params
  - id: ref
    type: b4
  - id: type
    type: b4

  # Config Msg
  - id: type_class
    type: config_msg
    if: type == 4

  # Sendval Reply
  - id: type_class
    type: sendval_reply
    if: type == 6
