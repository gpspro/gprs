$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gprs'

require 'minitest/autorun'

require 'test_data'

def parse_report_single(log = true)
  if log
    puts ""
    puts "# Parsing 1 report packet..."
  end

  reports = GprsC.packet_parse_c(report_single, log)

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
    reports = GprsC.packet_parse_c(packet, log)
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
    reports = Gprs.packet_parse_c(packet)
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
    type = Gprs.packet_type_c(packet)

    if log
      puts "Packet: #{packet}"
      puts "Packet Type: #{type}"
    end
  end
end

def parse_commands(log = true)
  if log
    puts ""
    puts "# Parsing all command packets (C Extension)..."
  end

  commands.each do |packet|
    command = Gprs.packet_parse_c(packet)
    if log
      puts command
      puts ""
    end
  end
end

def parse_command_c(log = true)
  if log
    puts ""
    puts "# Parsing single command packet (C Extension)..."
  end

  command = Gprs.packet_parse_c(commands[0])
  if log
    puts command
    puts ""
  end
end

def parse_command_kaitai(log = true)
  if log
    puts ""
    puts "# Parsing single command packet (Kaitai Struct)..."
  end

  command = Gprs.packet_parse_kaitai(commands[0])
  if log
    puts command
    puts ""
  end
end

def parse_commands_kaitai(log = true)
  if log
    puts ""
    puts "# Parsing all command packet types (Kaitai Struct)..."
  end

  commands.each do |packet|
    puts "Packet: #{packet}"
    command = Gprs.packet_parse_kaitai(packet)
    if log
      puts "Hash: #{command}"
      puts ""
    end
  end
end
