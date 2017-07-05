$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gprs'

require 'minitest/autorun'

require 'test_data'

def parse_report_single(log = true)
  if log
    puts ""
    puts "# Parsing 1 report packet..."
  end

  reports = Gprs.parse_report(report_single, log)

  if log
    puts reports
    puts ""
  end
end

def parse_report_multiple(log = true)
  if log
    puts ""
    puts "# Parsing #{report_multiple.length} report packets..."
  end

  report_multiple.each do |packet|
    reports = Gprs.parse_report(packet, log)
    if log
      puts reports
      puts ""
    end
  end
end

def parse_report_other(log = true)
  if log
    puts ""
    puts "# Parsing several non-additional-io packets..."
  end

  report_other.each do |packet|
    reports = Gprs.parse_report(packet)
    if log
      puts reports
      puts ""
    end
  end
end

def detect_packet_types(log = true)
  if log
    puts ""
    puts "# Detecting types of #{packet_types.count} different packets..."
  end

  packet_types.each do |packet|
    type = Gprs.parse_report(packet)

    if log
      puts "Packet: #{packet}"
      puts "Packet Type: #{type}"
    end
  end
end

def parse_command(log = true)
  if log
    puts ""
    puts "# Parsing single command packet (Kaitai Struct)..."
  end

  command = Gprs.parse_command(command_single)
  if log
    puts command
    puts ""
  end
end

def parse_commands(log = true)
  if log
    puts ""
    puts "# Parsing all command packet types (Kaitai Struct)..."
  end

  commands.each do |packet|
    puts "Packet: #{packet}"
    command = Gprs.parse_command(packet)
    if log
      puts "Hash: #{command}"
      puts ""
    end
  end
end
