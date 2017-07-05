
# Kaitai files
require "gprs_kaitai/config_msg.rb"
require "gprs_kaitai/gprs_command.rb"
require "gprs_kaitai/param_reply.rb"
require "gprs_kaitai/sendval_reply.rb"

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

module GprsKaitai

  def self.object_hashify_name(object)
    object.class.name.split("::").last.underscore.to_sym
  end

  def self.object_to_hash(object)
    hash = {}

    if not object.nil?
      object.instance_variables.each do |field|
        key   = field.to_s.gsub("@", "")
        value = object.instance_variable_get field

        if key.index("_") == 0
          next
        end

        hash[key.to_sym] = value
      end
    end

    hash
  end

  # NOTE: In this method you will see lots of arrays being reversed.
  #       This is because Kaitai reads bits from MSB to LSB. However,
  #       I wrote the protocol to order things from LSB to MSB, so I
  #       have to reverse all bits every time.
  def self.command_to_hash(cmd)
    hash = { :ref => cmd.ref, :type => cmd.type, :code => cmd.type_class.code }
    data_hash = {}

    data  = cmd.type_class.data

    data_class_name = object_hashify_name(data)

    # Fields that we want to manually turn into hashes
    case data
    when ConfigMsg::OutputSet
      data_hash = {
        :output     => data.output,
        :mode       => data.mode
      }

      if data.rule_count > 0
        data_hash[:rule_count] = data.rule_count
        data_hash[:rules] = []
        data.rules.each do |rule|
          data_hash[:rules] << {
            :code   => rule.code,
            :cond   => rule.cond,
            :value  => rule.value
          }
        end
      end
    when ParamReply::GsmIpPort
      data_hash = {
        :ip_address   => data.ip_address_bytes.join("."),
        :remote_port  => data.remote_port,
        :local_port   => data.local_port
      }
    when ParamReply::OutputSchList
      data_hash = {
        :has_more     => data.has_more,
        :count        => data.count
      }
      if data.count > 0
        data_hash[:items] = []
        data.items.each do |item|
          data_hash[:items] << {
            :output => item.output,
            :day    => item.day,
            :minute => item.minute,
            :value  => item.value
          }
        end
      end
    when ParamReply::AnalogExt
      data_hash = {
        :rc       => data.rc,
        :analog   => data.analog,
        :format   => data.format,
        :action   => data.action,
        :value    => data.value,
        :min      => data.min,
        :max      => data.max
      }

      if data.format == :analog_ext_format_voltage
        data_hash[:value] = '%.02fV' % data.value
        data_hash[:min]   = '%.02fV' % data.min
        data_hash[:max]   = '%.02fV' % data.max
      end
    when ParamReply::OutputSet
      data_hash = {
        :rc     => data.rc
      }

      if not data.error_count.nil?
        data_hash[:error_count] = data.error_count
        data_hash[:errors] = []
        data.errors.each do |error|
          data_hash[:errors] << {
            :error => error.error,
            :code  => error.code,
            :cond  => error.cond,
            :value => error.value
          }
        end
      end
    when ParamReply::CdmaIpPort
      data_hash = {
        :ip_address   => data.ip_address_bytes.join("."),
        :remote_port  => data.remote_port,
        :local_port   => data.local_port
      }
    when SendvalReply::Diag
      diag = data
      data_hash = {
        :firmware_version => "v#{diag.version_major}.#{diag.version_minor}.#{diag.version_revision}",
        :modem_status     => diag.modem_status,
        :modem_signal     => diag.modem_signal,
        :gps_status       => diag.gps_status,
        :int_voltage      => '%.2fV' % (diag.int_voltage / 100.0),
        :ext_voltage      => '%.2fV' % (diag.ext_voltage / 100.0)
      }

    when SendvalReply::Diag2
      diag2 = data

      data_hash = {
        :firmware_version => "v#{diag2.version_major}.#{diag2.version_minor}.#{diag2.version_revision}",
        :modem_status     => diag2.modem_status,
        :modem_signal     => diag2.modem_signal,
        :gps_fix          => diag2.gps_fix,
        :gps_satellites   => diag2.gps_satellites,
      }

      if diag2.has_int_voltage
        data_hash[:int_voltage] = '%.2fV' % (diag2.int_voltage / 100.0)
      end
      if diag2.has_ext_voltage
        data_hash[:ext_voltage] = '%.2fV' % (diag2.ext_voltage / 100.0)
      end
      if diag2.has_temperature
        data_hash[:temperature] = '%dF' % diag2.temperature
      end
      if diag2.has_io
        # Get input states
        idx = 0
        input_present = diag2.input_present.reverse
        input_value   = diag2.input_value.reverse
        input_present.each do |present|
          if present
            data_hash["input_#{idx + 1}".to_sym] = input_value[idx] ? 1 : 0
          end
          idx += 1
        end

        # Get output states
        idx = 0
        output_present = diag2.output_present.reverse
        output_value   = diag2.output_value.reverse
        output_present.each do |present|
          if present
            data_hash["output_#{idx + 1}".to_sym] = output_value[idx] ? 1 : 0
          end
          idx += 1
        end
      end

      if diag2.has_analogs
        # Get analog states
        idx = 0
        analog_present = diag2.analog_present.reverse
        analog_value   = diag2.analog_value
        analog_present.each do |present|
          if present
            data_hash["analog_#{idx + 1}".to_sym] = '%.2fV' % (analog_value[idx] / 100.0)
          end
          idx += 1
        end
      end
    # We want to auto generate everything else
    else
      data_hash = object_to_hash(data)
    end

    if data_hash.size > 0
      hash[:data] = {
        data_class_name => data_hash
      }
    end
    hash
  end

  def self.packet_parse(packet, log = false)

    # Process with GPRS c extension
    processed = GprsC.packet_process_c(packet, log).pack("c*")

    # Parse with Kaitai Struct
    cmd = GprsCommand.new(Kaitai::Struct::Stream.new(processed))
    command_to_hash(cmd)
  end
end
