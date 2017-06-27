meta:
  id: sendval_reply
  endian: le
  imports:
    - sendval_reply/diag
    - sendval_reply/diag2
seq:
  - id: code
    type: u1

  # Sendval Reply / Diag
  - id: data
    type: diag
    if: code == 73

  # Sendval Reply / Diag V2
  - id: data
    type: diag2
    if: code == 74
