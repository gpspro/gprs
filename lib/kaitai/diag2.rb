# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class Diag2 < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    @_unnamed0 = @_io.read_bits_int(1) != 0
    @_unnamed1 = @_io.read_bits_int(1) != 0
    @has_analogs = @_io.read_bits_int(1) != 0
    @has_io = @_io.read_bits_int(1) != 0
    @_unnamed4 = @_io.read_bits_int(1) != 0
    @has_temperature = @_io.read_bits_int(1) != 0
    @has_ext_voltage = @_io.read_bits_int(1) != 0
    @has_int_voltage = @_io.read_bits_int(1) != 0
    @_io.align_to_byte
    @version_major = @_io.read_u1
    @version_minor = @_io.read_u1
    @version_revision = @_io.read_u1
    @modem_status = @_io.read_u1
    @modem_signal = @_io.read_u1
    @gps_fix = @_io.read_bits_int(2)
    @gps_satellites = @_io.read_bits_int(6)
    @_io.align_to_byte
    if has_int_voltage
      @int_voltage = @_io.read_u2le
    end
    if has_ext_voltage
      @ext_voltage = @_io.read_u2le
    end
    if has_temperature
      @temperature = @_io.read_u1
    end
    if has_io
      @input_4_present = @_io.read_bits_int(1) != 0
    end
    if has_io
      @input_3_present = @_io.read_bits_int(1) != 0
    end
    if has_io
      @input_2_present = @_io.read_bits_int(1) != 0
    end
    if has_io
      @input_1_present = @_io.read_bits_int(1) != 0
    end
    if has_io
      @input_4_active = @_io.read_bits_int(1) != 0
    end
    if has_io
      @input_3_active = @_io.read_bits_int(1) != 0
    end
    if has_io
      @input_2_active = @_io.read_bits_int(1) != 0
    end
    if has_io
      @input_1_active = @_io.read_bits_int(1) != 0
    end
    if has_io
      @output_4_present = @_io.read_bits_int(1) != 0
    end
    if has_io
      @output_3_present = @_io.read_bits_int(1) != 0
    end
    if has_io
      @output_2_present = @_io.read_bits_int(1) != 0
    end
    if has_io
      @output_1_present = @_io.read_bits_int(1) != 0
    end
    if has_io
      @output_4_active = @_io.read_bits_int(1) != 0
    end
    if has_io
      @output_3_active = @_io.read_bits_int(1) != 0
    end
    if has_io
      @output_2_active = @_io.read_bits_int(1) != 0
    end
    if has_io
      @output_1_active = @_io.read_bits_int(1) != 0
    end
    if has_analogs
      @analog_8_present = @_io.read_bits_int(1) != 0
    end
    if has_analogs
      @analog_7_present = @_io.read_bits_int(1) != 0
    end
    if has_analogs
      @analog_6_present = @_io.read_bits_int(1) != 0
    end
    if has_analogs
      @analog_5_present = @_io.read_bits_int(1) != 0
    end
    if has_analogs
      @analog_4_present = @_io.read_bits_int(1) != 0
    end
    if has_analogs
      @analog_3_present = @_io.read_bits_int(1) != 0
    end
    if has_analogs
      @analog_2_present = @_io.read_bits_int(1) != 0
    end
    if has_analogs
      @analog_1_present = @_io.read_bits_int(1) != 0
    end
    @_io.align_to_byte
    if analog_1_present
      @analog_1 = @_io.read_u2le
    end
    if analog_2_present
      @analog_2 = @_io.read_u2le
    end
    if analog_3_present
      @analog_3 = @_io.read_u2le
    end
    if analog_4_present
      @analog_4 = @_io.read_u2le
    end
    if analog_5_present
      @analog_5 = @_io.read_u2le
    end
    if analog_6_present
      @analog_6 = @_io.read_u2le
    end
    if analog_7_present
      @analog_7 = @_io.read_u2le
    end
    if analog_8_present
      @analog_8 = @_io.read_u2le
    end
  end
  attr_reader :_unnamed0
  attr_reader :_unnamed1
  attr_reader :has_analogs
  attr_reader :has_io
  attr_reader :_unnamed4
  attr_reader :has_temperature
  attr_reader :has_ext_voltage
  attr_reader :has_int_voltage
  attr_reader :version_major
  attr_reader :version_minor
  attr_reader :version_revision
  attr_reader :modem_status
  attr_reader :modem_signal
  attr_reader :gps_fix
  attr_reader :gps_satellites
  attr_reader :int_voltage
  attr_reader :ext_voltage
  attr_reader :temperature
  attr_reader :input_4_present
  attr_reader :input_3_present
  attr_reader :input_2_present
  attr_reader :input_1_present
  attr_reader :input_4_active
  attr_reader :input_3_active
  attr_reader :input_2_active
  attr_reader :input_1_active
  attr_reader :output_4_present
  attr_reader :output_3_present
  attr_reader :output_2_present
  attr_reader :output_1_present
  attr_reader :output_4_active
  attr_reader :output_3_active
  attr_reader :output_2_active
  attr_reader :output_1_active
  attr_reader :analog_8_present
  attr_reader :analog_7_present
  attr_reader :analog_6_present
  attr_reader :analog_5_present
  attr_reader :analog_4_present
  attr_reader :analog_3_present
  attr_reader :analog_2_present
  attr_reader :analog_1_present
  attr_reader :analog_1
  attr_reader :analog_2
  attr_reader :analog_3
  attr_reader :analog_4
  attr_reader :analog_5
  attr_reader :analog_6
  attr_reader :analog_7
  attr_reader :analog_8
end
