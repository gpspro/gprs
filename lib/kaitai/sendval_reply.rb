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
        @inputs_present = Array.new(4)
        (4).times { |i|
          @inputs_present[i] = @_io.read_bits_int(1) != 0
        }
      end
      if has_io
        @inputs_active = Array.new(4)
        (4).times { |i|
          @inputs_active[i] = @_io.read_bits_int(1) != 0
        }
      end
      if has_io
        @outputs_present = Array.new(4)
        (4).times { |i|
          @outputs_present[i] = @_io.read_bits_int(1) != 0
        }
      end
      if has_io
        @outputs_active = Array.new(4)
        (4).times { |i|
          @outputs_active[i] = @_io.read_bits_int(1) != 0
        }
      end
      if has_analogs
        @analogs_present = Array.new(8)
        (8).times { |i|
          @analogs_present[i] = @_io.read_bits_int(1) != 0
        }
      end
      @_io.align_to_byte
      if analogs_present[7]
        @analog_1 = @_io.read_u2le
      end
      if analogs_present[6]
        @analog_2 = @_io.read_u2le
      end
      if analogs_present[5]
        @analog_3 = @_io.read_u2le
      end
      if analogs_present[4]
        @analog_4 = @_io.read_u2le
      end
      if analogs_present[3]
        @analog_5 = @_io.read_u2le
      end
      if analogs_present[2]
        @analog_6 = @_io.read_u2le
      end
      if analogs_present[1]
        @analog_7 = @_io.read_u2le
      end
      if analogs_present[0]
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
    attr_reader :inputs_present
    attr_reader :inputs_active
    attr_reader :outputs_present
    attr_reader :outputs_active
    attr_reader :analogs_present
    attr_reader :analog_1
    attr_reader :analog_2
    attr_reader :analog_3
    attr_reader :analog_4
    attr_reader :analog_5
    attr_reader :analog_6
    attr_reader :analog_7
    attr_reader :analog_8
  end
  attr_reader :code
  attr_reader :data
end
