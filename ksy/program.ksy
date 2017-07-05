meta:
  id: program
  endian: le
seq:
  - id: code
    type: u1

  - id: data
    type:
      switch-on: code
      cases:
        2: program_data     # Program Data Packet
        6: firmware_version # Firmware Version Request / Response
        7: firmware_info    # Firmware Info Request / Response
    repeat: eos

types:
  program_data:
    seq:
      - id: length
        type: u2
  firmware_version:
    seq:
      - id: version_major
        type: u1
      - id: version_minor
        type: u1
      - id: version_revision
        type: u1

  firmware_info:
    seq:
      - id: device_id
        type: u4
      - id: firmware_id
        type: u1
      - id: version_major
        type: u1
      - id: version_minor
        type: u1
      - id: version_revision
        type: u1
      - id: reset_cause
        type: u1
