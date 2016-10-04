
require "bindata"

module Gprs
  # Common GPRS fields
  GPRS_SOP        = 0x28
  GPRS_EOP        = 0x29

  GPRS_BACKSPACE  = 0x8
  GPRS_CR         = 0xA
  GPRS_NL         = 0xD

  GPRS_DLE        = 0x10
  GPRS_DLE_OFFSET = 128

  # Default definition for skipping a not-present value (read length of 0)
  class SkipNull < BinData::Primitive
    skip :length => 0

    def get; 0; end
    def set(v); ; end
  end

  class UInt8If < BinData::Choice
    skip_null   0
    uint8       1
  end

  class Defs
    # Returns true if the byte needs to be escaped
    def self.needs_escape?(byte)
      [ GPRS_SOP, GPRS_EOP, GPRS_DLE, GPRS_BACKSPACE, GPRS_CR, GPRS_NL, GPRS_DLE ].contains(byte)
    end

    # Unescapes all escaped bytes in the packet
    def self.unescape(packet)
      escape_next = false
      packet.map! { |byte|
        if byte == GPRS_DLE
          # -1 to mark byte for removal
          escape_next = true; byte = -1
        elsif escape_next
          # Escape this byte
          escape_next = false; byte = byte - 128
        end

        byte
      }.delete(-1); packet
    end

    # Calculates CRC from all bytes
    def self.crc8(bytes)
      crc = 0; bytes.each { |byte| crc ^= byte }; crc
    end

    # Takes a raw packet and performs the following:
    #  - Validate packet format
    #  - Unescape special bytes
    #  - Validate CRC
    #  - Remove protocol bytes (SOP, EOP, CRC, etc)
    def self.preprocess(packet)
      # Start by unpacking (if needed)
      if packet.is_a? String
        packet = packet.bytes
      end

      # Strip out last newline (if present)
      packet.delete(GPRS_NL)

      # Strip out SOP and EOP, return error if invalid
      if packet.delete(GPRS_SOP).nil? or packet.delete(GPRS_EOP).nil?
        puts "Invalid Packet: Missing SOP or EOP byte."
        return false, packet
      end

      # Strip out escapes
      packet = unescape(packet)

      # Strip out & validate CRC
      crc = packet.delete_at(packet.length - 1)
      ccrc = crc8(packet)
      if crc != ccrc
        puts "Invalid CRC: #{crc.to_s} != #{ccrc.to_s}."
        return false, packet
      end

      # This method always returns an array of bytes
      return true, packet
    end
  end
end