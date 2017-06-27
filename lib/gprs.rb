
require "gprs/version.rb"

require "gprs_c"

# Kaitai files
require "require_all"
require_all "lib/kaitai"

module GprsC
  # If it's a string with format "0xA 0xB 0xC..." convert to byte array
  def self.process_packet(packet)
    if packet.is_a? String and packet.include? "0x"
      packet.split(" ").map{ |x| x.gsub("0x", "").to_i(16) }
    else
      packet
    end
  end

  def self.packet_type(packet, log = false)
    packet = process_packet(packet)

    GprsC.packet_type_c(packet, log)
  end

  def self.packet_parse(packet, log = false)
    packet = process_packet(packet)

    GprsC.packet_parse_c(packet, log)
  end

  def self.packet_parse_kaitai(packet, log = false)
    # Convert to readable format
    packet = process_packet(packet)

    # Process with GPRS c extension
    processed = GprsC.packet_process_c(packet, log).pack("c*")

    # Parse with Kaitai Struct
    GprsCommand.new(Kaitai::Struct::Stream.new(processed))
  end

end
