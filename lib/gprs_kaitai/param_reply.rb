# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class ParamReply < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    @code = @_io.read_u1
    case code
    when 93
      @data = CdmaActivate.new(@_io, self, @_root)
    when 73
      @data = GsmIpPort.new(@_io, self, @_root)
    when 42
      @data = CellInfo.new(@_io, self, @_root)
    when 81
      @data = OutputSchGet.new(@_io, self, @_root)
    when 1
      @data = MoveFreq.new(@_io, self, @_root)
    when 101
      @data = LedStatusGet.new(@_io, self, @_root)
    when 100
      @data = SleepTimeoutGet.new(@_io, self, @_root)
    when 87
      @data = AnalogExt.new(@_io, self, @_root)
    when 91
      @data = OutputSet.new(@_io, self, @_root)
    when 89
      @data = InputGet.new(@_io, self, @_root)
    when 67
      @data = SendFreq.new(@_io, self, @_root)
    when 95
      @data = GsmNetwork.new(@_io, self, @_root)
    when 88
      @data = AnalogGet.new(@_io, self, @_root)
    when 82
      @data = OutputSchSet.new(@_io, self, @_root)
    when 84
      @data = OutputSchClear.new(@_io, self, @_root)
    when 83
      @data = OutputSchList.new(@_io, self, @_root)
    when 94
      @data = GsmMode.new(@_io, self, @_root)
    when 72
      @data = GsmApn.new(@_io, self, @_root)
    when 71
      @data = TurnAngle.new(@_io, self, @_root)
    when 70
      @data = TurnDetect.new(@_io, self, @_root)
    when 80
      @data = FcPump.new(@_io, self, @_root)
    when 68
      @data = StopFreq.new(@_io, self, @_root)
    when 92
      @data = CdmaIpPort.new(@_io, self, @_root)
    when 90
      @data = OutputGet.new(@_io, self, @_root)
    end
  end
  class GsmApn < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @apn_len = @_io.read_u1
      @apn = (@_io.read_bytes(apn_len)).force_encoding("UTF-8")
      @user_len = @_io.read_u1
      @user = (@_io.read_bytes(user_len)).force_encoding("UTF-8")
      @pass_len = @_io.read_u1
      @pass = (@_io.read_bytes(pass_len)).force_encoding("UTF-8")
    end
    attr_reader :apn_len
    attr_reader :apn
    attr_reader :user_len
    attr_reader :user
    attr_reader :pass_len
    attr_reader :pass
  end
  class OutputSchClear < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @count = @_io.read_u1
    end
    attr_reader :count
  end
  class MoveFreq < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @seconds = @_io.read_u2le
    end
    attr_reader :seconds
  end
  class OutputSchSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = @_io.read_u1
    end
    attr_reader :rc
  end
  class FcPump < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = @_io.read_u1
    end
    attr_reader :rc
  end
  class GsmNetwork < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @network = @_io.read_u1
    end
    attr_reader :network
  end
  class AnalogGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @voltage = @_io.read_u2le
    end
    attr_reader :voltage
  end
  class StopFreq < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @seconds = @_io.read_u2le
    end
    attr_reader :seconds
  end
  class TurnAngle < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @angle = @_io.read_u1
    end
    attr_reader :angle
  end
  class OutputSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = @_io.read_u1
      if rc == 5
        @error_count = @_io.read_u1
      end
      if rc == 5
        @errors = Array.new(error_count)
        (error_count).times { |i|
          @errors[i] = OutputRuleError.new(@_io, self, @_root)
        }
      end
    end
    attr_reader :rc
    attr_reader :error_count
    attr_reader :errors
  end
  class TurnDetect < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @enabled = @_io.read_u1
    end
    attr_reader :enabled
  end
  class GsmMode < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @mode = @_io.read_u1
    end
    attr_reader :mode
  end
  class SleepTimeoutGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @timeout = @_io.read_u2le
    end
    attr_reader :timeout
  end
  class AnalogExt < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = @_io.read_u1
      @analog = @_io.read_u1
      @format = @_io.read_u1
      @action = @_io.read_u1
      case format
      when 0
        @value = @_io.read_u2le
      when 1
        @value = @_io.read_u1
      when 2
        @value = @_io.read_u2le
      end
      case format
      when 0
        @min = @_io.read_u2le
      when 1
        @min = @_io.read_u1
      when 2
        @min = @_io.read_u2le
      end
      case format
      when 0
        @max = @_io.read_u2le
      when 1
        @max = @_io.read_u1
      when 2
        @max = @_io.read_u2le
      end
    end
    attr_reader :rc
    attr_reader :analog
    attr_reader :format
    attr_reader :action
    attr_reader :value
    attr_reader :min
    attr_reader :max
  end
  class CdmaActivate < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = @_io.read_u1
    end
    attr_reader :rc
  end
  class OutputGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = @_io.read_u1
    end
    attr_reader :rc
  end
  class OutputRuleError < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @error = @_io.read_u1
      @code = @_io.read_u1
      @cond = @_io.read_u1
      case code
      when 4
        @value = @_io.read_u2le
      when 6
        @value = @_io.read_u2le
      when 20
        @value = @_io.read_u2le
      when 21
        @value = @_io.read_u2le
      else
        @value = @_io.read_u1
      end
    end
    attr_reader :error
    attr_reader :code
    attr_reader :cond
    attr_reader :value
  end
  class OutputSchGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = @_io.read_u1
      @value = @_io.read_u1
    end
    attr_reader :rc
    attr_reader :value
  end
  class GsmIpPort < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @ip_address_bytes = Array.new(4)
      (4).times { |i|
        @ip_address_bytes[i] = @_io.read_u1
      }
      @remote_port = @_io.read_u2le
      @local_port = @_io.read_u2le
    end
    attr_reader :ip_address_bytes
    attr_reader :remote_port
    attr_reader :local_port
  end
  class InputGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = @_io.read_u1
    end
    attr_reader :rc
  end
  class SendFreq < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @seconds = @_io.read_u2le
    end
    attr_reader :seconds
  end
  class OutputSchList < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @has_more = @_io.read_bits_int(1) != 0
      @count = @_io.read_bits_int(7)
      @_io.align_to_byte
      @items = Array.new(count)
      (count).times { |i|
        @items[i] = OutputSchItem.new(@_io, self, @_root)
      }
    end
    attr_reader :has_more
    attr_reader :count
    attr_reader :items
  end
  class CellInfo < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @info = @_io.read_u1
    end
    attr_reader :info
  end
  class CdmaIpPort < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @ip_address_bytes = Array.new(4)
      (4).times { |i|
        @ip_address_bytes[i] = @_io.read_u1
      }
      @remote_port = @_io.read_u2le
      @local_port = @_io.read_u2le
    end
    attr_reader :ip_address_bytes
    attr_reader :remote_port
    attr_reader :local_port
  end
  class LedStatusGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @status = @_io.read_u1
    end
    attr_reader :status
  end
  class OutputSchItem < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @output = @_io.read_u1
      @day = @_io.read_u1
      @hour = @_io.read_u1
      @minute = @_io.read_u1
      @value = @_io.read_u1
    end
    attr_reader :output
    attr_reader :day
    attr_reader :hour
    attr_reader :minute
    attr_reader :value
  end
  attr_reader :code
  attr_reader :data
end
