# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class ConfigMsg < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    @code = @_io.read_u1
    case code
    when 73
      @data = GsmIpPortSet.new(@_io, self, @_root)
    when 42
      @data = CellInfoSet.new(@_io, self, @_root)
    when 81
      @data = OutputSchGet.new(@_io, self, @_root)
    when 20
      @data = SendvalRequest.new(@_io, self, @_root)
    when 1
      @data = MoveFreqSet.new(@_io, self, @_root)
    when 101
      @data = LedStatusSet.new(@_io, self, @_root)
    when 100
      @data = SleepTimeoutSet.new(@_io, self, @_root)
    when 87
      @data = AnalogExt.new(@_io, self, @_root)
    when 91
      @data = OutputSet.new(@_io, self, @_root)
    when 89
      @data = InputGet.new(@_io, self, @_root)
    when 67
      @data = SendFreqSet.new(@_io, self, @_root)
    when 88
      @data = AnalogGet.new(@_io, self, @_root)
    when 82
      @data = OutputSchSet.new(@_io, self, @_root)
    when 83
      @data = OutputSchList.new(@_io, self, @_root)
    when 94
      @data = GsmModeSet.new(@_io, self, @_root)
    when 130
      @data = UnitIdSet.new(@_io, self, @_root)
    when 72
      @data = GsmApnSet.new(@_io, self, @_root)
    when 71
      @data = TurnAngleSet.new(@_io, self, @_root)
    when 70
      @data = TurnDetectSet.new(@_io, self, @_root)
    when 80
      @data = FcPump.new(@_io, self, @_root)
    when 68
      @data = StopFreqSet.new(@_io, self, @_root)
    when 31
      @data = ParamRequest.new(@_io, self, @_root)
    when 92
      @data = CdmaIpPortSet.new(@_io, self, @_root)
    when 90
      @data = OutputGet.new(@_io, self, @_root)
    end
  end
  class UnitIdSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @unit_id = @_io.read_u4le
    end
    attr_reader :unit_id
  end
  class CellInfoSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @enabled = @_io.read_u1
    end
    attr_reader :enabled
  end
  class SendFreqSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @seconds = @_io.read_u2le
    end
    attr_reader :seconds
  end
  class OutputSchSet < Kaitai::Struct::Struct
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
  class GsmIpPortSet < Kaitai::Struct::Struct
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
  class GsmApnSet < Kaitai::Struct::Struct
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
  class FcPump < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @txn_id = @_io.read_u4le
      @timeout = @_io.read_u4le
      @reset = @_io.read_u4le
      @max = @_io.read_u4le
      @function = @_io.read_u1
    end
    attr_reader :txn_id
    attr_reader :timeout
    attr_reader :reset
    attr_reader :max
    attr_reader :function
  end
  class MoveFreqSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @seconds = @_io.read_u2le
    end
    attr_reader :seconds
  end
  class AnalogGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @analog = @_io.read_u1
    end
    attr_reader :analog
  end
  class GsmModeSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @mode = @_io.read_u1
    end
    attr_reader :mode
  end
  class OutputSetRule < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
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
    attr_reader :code
    attr_reader :cond
    attr_reader :value
  end
  class OutputSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @output = @_io.read_u1
      @mode = @_io.read_u1
      if  ((mode == 2) || (mode == 3)) 
        @rule_count = @_io.read_u1
      end
      if  ((mode == 2) || (mode == 3)) 
        @rules = Array.new(rule_count)
        (rule_count).times { |i|
          @rules[i] = OutputSetRule.new(@_io, self, @_root)
        }
      end
    end
    attr_reader :output
    attr_reader :mode
    attr_reader :rule_count
    attr_reader :rules
  end
  class TurnAngleSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @angle = @_io.read_u1
    end
    attr_reader :angle
  end
  class SendvalRequest < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @code = @_io.read_u1
    end
    attr_reader :code
  end
  class ParamRequest < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @code = @_io.read_u1
    end
    attr_reader :code
  end
  class AnalogExt < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @analog = @_io.read_u1
      @format = @_io.read_u1
      @action = @_io.read_u1
    end
    attr_reader :analog
    attr_reader :format
    attr_reader :action
  end
  class LedStatusSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @status = @_io.read_u1
    end
    attr_reader :status
  end
  class OutputGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @output = @_io.read_u1
    end
    attr_reader :output
  end
  class SleepTimeoutSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @timeout = @_io.read_u2le
    end
    attr_reader :timeout
  end
  class TurnDetectSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @enabled = @_io.read_u1
    end
    attr_reader :enabled
  end
  class OutputSchGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @output = @_io.read_u1
      @day = @_io.read_u1
      @hour = @_io.read_u1
      @minute = @_io.read_u1
    end
    attr_reader :output
    attr_reader :day
    attr_reader :hour
    attr_reader :minute
  end
  class InputGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @input = @_io.read_u1
    end
    attr_reader :input
  end
  class OutputSchList < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @list_mode = @_io.read_u1
    end
    attr_reader :list_mode
  end
  class StopFreqSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @seconds = @_io.read_u2le
    end
    attr_reader :seconds
  end
  class CdmaIpPortSet < Kaitai::Struct::Struct
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
  attr_reader :code
  attr_reader :data
end
