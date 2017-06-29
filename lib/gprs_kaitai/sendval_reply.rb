# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class SendvalReply < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    @code = @_io.read_u1
    case code
    when 73
      @data = Diag.new(@_io, self, @_root)
    when 74
      @data = Diag2.new(@_io, self, @_root)
    end
  end
  class Diag < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @version_major = @_io.read_u1
      @version_minor = @_io.read_u1
      @version_revision = @_io.read_u1
      @modem_status = @_io.read_u1
      @modem_signal = @_io.read_u1
      @gps_status = @_io.read_u1
      @int_voltage = @_io.read_u2le
      @ext_voltage = @_io.read_u2le
    end
    attr_reader :version_major
    attr_reader :version_minor
    attr_reader :version_revision
    attr_reader :modem_status
    attr_reader :modem_signal
    attr_reader :gps_status
    attr_reader :int_voltage
    attr_reader :ext_voltage
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
      @gps_satellites = @_io.read_bits_int(6)
      @gps_fix = @_io.read_bits_int(2)
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
        @input_value = Array.new(4)
        (4).times { |i|
          @input_value[i] = @_io.read_bits_int(1) != 0
        }
      end
      if has_io
        @input_present = Array.new(4)
        (4).times { |i|
          @input_present[i] = @_io.read_bits_int(1) != 0
        }
      end
      if has_io
        @output_value = Array.new(4)
        (4).times { |i|
          @output_value[i] = @_io.read_bits_int(1) != 0
        }
      end
      if has_io
        @output_present = Array.new(4)
        (4).times { |i|
          @output_present[i] = @_io.read_bits_int(1) != 0
        }
      end
      if has_analogs
        @analog_present = Array.new(8)
        (8).times { |i|
          @analog_present[i] = @_io.read_bits_int(1) != 0
        }
      end
      @_io.align_to_byte
      @analog_value = []
      while not @_io.eof?
        @analog_value << @_io.read_u2le
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
    attr_reader :gps_satellites
    attr_reader :gps_fix
    attr_reader :int_voltage
    attr_reader :ext_voltage
    attr_reader :temperature
    attr_reader :input_value
    attr_reader :input_present
    attr_reader :output_value
    attr_reader :output_present
    attr_reader :analog_present
    attr_reader :analog_value
  end
  attr_reader :code
  attr_reader :data
end
