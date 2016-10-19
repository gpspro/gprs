
require "gprs/defs"
require "gprs/report"
require "gprs/version"

# C bindings
require "gprs_c"

module Gprs
  def self.parse_report(packet)
    # If it's a string with format "0xA 0xB 0xC..." convert to byte array
    if packet.is_a? String and packet.include? " 0x"
      packet = packet.split(" ").map{ |x| x.gsub("0x", "").to_i(16) }
    end

    # Preprocess GPRS packet first
    valid, packet = Gprs::Defs.preprocess(packet)

    report = nil
    if valid
      # Parse report
      report = Report.read(packet.pack("C*"))
    else
      puts "Invalid report packet!"
    end
  end
end

module GprsC
  # If it's a string with format "0xA 0xB 0xC..." convert to byte array
  def self.process_packet(packet)
    if packet.is_a? String and packet.include? " 0x"
      packet.split(" ").map{ |x| x.gsub("0x", "").to_i(16) }
    else
      packet
    end
  end

  def self.packet_type(packet, log = false)
    packet = process_packet(packet)

    GprsC.packet_type_c(packet, log)
  end

  def self.parse_report(packet, log = false)
    packet = process_packet(packet)

    GprsC.parse_report_c(packet, log)
  end
end
