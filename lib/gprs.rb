
require "gprs/version.rb"

require "gprs_c"

# Kaitai files
require "require_all"
require_all "lib/kaitai"

module Gprs
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

    type = GprsC.packet_type_c(packet, log)

    cmd_hash = {}

    if type == 2
      # Process with GPRS c extension
      processed = GprsC.packet_process_c(packet, log).pack("c*")

      # Parse with Kaitai Struct
      cmd = GprsCommand.new(Kaitai::Struct::Stream.new(processed))

      # Generate hash from cmd
      cmd_hash[:ref] = cmd.ref
      cmd_hash[:type] = cmd.type
      if cmd.respond_to? :type_class
        type_class = cmd.type_class

        cmd_hash[:code] = type_class.code

        if (type_class.respond_to? :data) and not type_class.data.nil?
          data = type_class.data

          data_hash = {}
          data.instance_variables.each do |field|
            key = field.to_s.gsub('@', '')
            val = data.instance_variable_get field

            # Recognize _presence_bits and build key + value
            if key.include? "_presence_bits"
              type_name = key.gsub("_presence_bits", "")
              value_name = type_name + "_value_bits"

              # Kaitai reads bits backwards so we reverse arrays
              presence_bits = val.reverse
              value_bits = data.instance_variable_get("@#{value_name}").reverse

              # Add new keys + values if present
              idx = 0
              presence_bits.each do |present|
                if present
                  # Build key name from type and index
                  key_name = "#{type_name}_#{(idx + 1).to_s}"

                  # Add to data hash
                  data_hash[key_name.to_sym] = value_bits[idx]
                end
                idx += 1
              end
            end

            # Skip the following:
            # - Keys starting with "_"
            # - Keys starting with "has_"
            # - Keys ending in "_count" or "_size"
            if key.index("_") == 0 or key.index("has_") == 0 or key.include? "_bits"
              next
            end

            # Convert ip_address_bytes to IP address string
            if key.include? "ip_address_bytes"
              key = "ip_address"
              val = val.join(".")
            end

            data_hash[key.to_sym] = val

          end

          cmd_hash[:data] = data_hash
        end
      end
    end

    cmd_hash
  end

end
