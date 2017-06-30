# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class ConfigMsg < Kaitai::Struct::Struct

  OUTPUT_RULE_CODE = {
    0 => :output_rule_code_none,
    1 => :output_rule_code_gps_speed,
    2 => :output_rule_code_acc_movement,
    3 => :output_rule_code_acc_orient,
    4 => :output_rule_code_int_voltage,
    6 => :output_rule_code_ext_voltage,
    10 => :output_rule_code_input_1,
    11 => :output_rule_code_input_2,
    12 => :output_rule_code_input_3,
    13 => :output_rule_code_input_4,
    14 => :output_rule_code_output_1,
    15 => :output_rule_code_output_2,
    16 => :output_rule_code_output_3,
    17 => :output_rule_code_output_4,
    18 => :output_rule_code_analog_1_level,
    19 => :output_rule_code_analog_2_level,
    20 => :output_rule_code_analog_1_voltage,
    21 => :output_rule_code_analog_2_voltage,
  }
  I__OUTPUT_RULE_CODE = OUTPUT_RULE_CODE.invert

  OUTPUT_SET_MODE = {
    0 => :output_set_mode_turn_off,
    1 => :output_set_mode_turn_on,
    2 => :output_set_mode_turn_off_and,
    3 => :output_set_mode_turn_on_and,
  }
  I__OUTPUT_SET_MODE = OUTPUT_SET_MODE.invert

  OUTPUT_LIST_MODE = {
    0 => :output_list_mode_first,
    1 => :output_list_mode_next,
  }
  I__OUTPUT_LIST_MODE = OUTPUT_LIST_MODE.invert

  OUTPUT_RULE_COND = {
    0 => :output_rule_cond_eq,
    1 => :output_rule_cond_noteq,
    2 => :output_rule_cond_lt,
    3 => :output_rule_cond_gt,
    4 => :output_rule_cond_lteq,
    5 => :output_rule_cond_gteq,
    6 => :output_rule_cond_min,
    7 => :output_rule_cond_max,
  }
  I__OUTPUT_RULE_COND = OUTPUT_RULE_COND.invert

  ANALOG_EXT_FORMAT = {
    0 => :analog_ext_format_io,
    1 => :analog_ext_format_level,
    2 => :analog_ext_format_voltage,
  }
  I__ANALOG_EXT_FORMAT = ANALOG_EXT_FORMAT.invert

  ANALOG_EXT_ACTION = {
    0 => :analog_ext_action_get,
    1 => :analog_ext_action_clear,
  }
  I__ANALOG_EXT_ACTION = ANALOG_EXT_ACTION.invert
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    @code = @_io.read_u1
    case code
    when 81
      @data = OutputSchGet.new(@_io, self, @_root)
    when 20
      @data = SendvalRequest.new(@_io, self, @_root)
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
    when 88
      @data = AnalogGet.new(@_io, self, @_root)
    when 82
      @data = OutputSchSet.new(@_io, self, @_root)
    when 83
      @data = OutputSchList.new(@_io, self, @_root)
    when 130
      @data = UnitIdSet.new(@_io, self, @_root)
    when 80
      @data = FcPump.new(@_io, self, @_root)
    when 31
      @data = ParamRequest.new(@_io, self, @_root)
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
  class AnalogGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @analog = @_io.read_u1
    end
    attr_reader :analog
  end
  class OutputSetRule < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @code = Kaitai::Struct::Stream::resolve_enum(OUTPUT_RULE_CODE, @_io.read_u1)
      @cond = Kaitai::Struct::Stream::resolve_enum(OUTPUT_RULE_COND, @_io.read_u1)
      case code
      when :output_rule_code_analog_1_voltage
        @value = @_io.read_u2le
      when :output_rule_code_int_voltage
        @value = @_io.read_u2le
      when :output_rule_code_analog_2_voltage
        @value = @_io.read_u2le
      when :output_rule_code_ext_voltage
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
      @mode = Kaitai::Struct::Stream::resolve_enum(OUTPUT_SET_MODE, @_io.read_u1)
      if  ((mode == :output_set_mode_turn_off_and) || (mode == :output_set_mode_turn_on_and)) 
        @rule_count = @_io.read_u1
      end
      @rules = Array.new(rule_count)
      (rule_count).times { |i|
        @rules[i] = OutputSetRule.new(@_io, self, @_root)
      }
    end
    attr_reader :output
    attr_reader :mode
    attr_reader :rule_count
    attr_reader :rules
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
      @format = Kaitai::Struct::Stream::resolve_enum(ANALOG_EXT_FORMAT, @_io.read_u1)
      @action = Kaitai::Struct::Stream::resolve_enum(ANALOG_EXT_ACTION, @_io.read_u1)
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
      @list_mode = Kaitai::Struct::Stream::resolve_enum(OUTPUT_LIST_MODE, @_io.read_u1)
    end
    attr_reader :list_mode
  end
  attr_reader :code
  attr_reader :data
end
