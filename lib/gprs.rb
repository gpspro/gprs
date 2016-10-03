
require "gprs/defs"
require "gprs/report"
require "gprs/version"

module Gprs
  def self.unescape(packet)
    escape_next = false
    packet.map! { |byte|
      # -1 means remove this byte later
      if byte == GPRS_DLE
        escape_next = true
        byte = -1
      # Escape this byte
      elsif escape_next
        escape_next = false
        byte = byte - 128
      end
        
      byte
    }.delete(-1)

    packet
  end

  def self.crc8(data)
    crc = 0

    data.each do |byte|
      crc ^= byte
    end

    crc
  end

  def self.gprs_process(packet)
    # Start by unpacking (if needed)
    if packet.is_a? String
      packet = packet.bytes
    end

    # Strip out last newline (if present)
    packet.delete(GPRS_NEWLINE)

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

  def self.gprs_pack(packet)
    packet.pack("C*")
  end

  def self.parse_report(packet)

    valid, packet = gprs_process(packet)

    raw = nil
    if valid
      # Parse raw report fields
      #BinData::trace_reading do
      #  raw = Report.read(gprs_pack(packet))
      #end
      raw = Report.read(gprs_pack(packet))
    else
      puts "Invalid report packet!"
    end
  end
end
