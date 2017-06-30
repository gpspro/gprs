# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class ParamReply < Kaitai::Struct::Struct

  OUTPUT_SET_RC = {
    0 => :output_set_rc_success,
    1 => :output_set_rc_error,
    2 => :output_set_rc_unchanged,
  }
  I__OUTPUT_SET_RC = OUTPUT_SET_RC.invert

  INPUT_GET_RC = {
    0 => :input_get_rc_false,
    1 => :input_get_rc_true,
    255 => :input_get_rc_invalid_input,
  }
  I__INPUT_GET_RC = INPUT_GET_RC.invert

  FC_PUMP_RC = {
    0 => :fc_pump_rc_success,
    1 => :fc_pump_rc_access_error,
    2 => :fc_pump_rc_duplicate_txn,
    3 => :fc_pump_rc_not_authorized,
    4 => :fc_pump_rc_interface_busy,
    5 => :fc_pump_rc_not_available,
  }
  I__FC_PUMP_RC = FC_PUMP_RC.invert

  GSM_NETWORK = {
    0 => :gsm_network_unknown,
    1 => :gsm_network_att,
    2 => :gsm_network_verizon,
  }
  I__GSM_NETWORK = GSM_NETWORK.invert

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

  LED_STATUS = {
    0 => :led_status_hidden,
    1 => :led_status_visible,
  }
  I__LED_STATUS = LED_STATUS.invert

  OUTPUT_GET_RC = {
    0 => :output_get_rc_false,
    1 => :output_get_rc_true,
    255 => :output_get_rc_invalid_output,
  }
  I__OUTPUT_GET_RC = OUTPUT_GET_RC.invert

  OUTPUT_SCH_RC = {
    0 => :output_sch_rc_success,
    1 => :output_sch_rc_not_found,
    2 => :output_sch_rc_schedule_full,
    3 => :output_sch_rc_invalid_output,
    4 => :output_sch_rc_invalid_day,
    5 => :output_sch_rc_invalid_time,
    6 => :output_sch_rc_invalid_value,
  }
  I__OUTPUT_SCH_RC = OUTPUT_SCH_RC.invert

  CDMA_ACTIVATION_RC = {
    0 => :cdma_activation_rc_failed,
    1 => :cdma_activation_rc_success,
  }
  I__CDMA_ACTIVATION_RC = CDMA_ACTIVATION_RC.invert

  ANALOG_EXT_RC = {
    0 => :analog_ext_rc_success,
    1 => :analog_ext_rc_invalid_analog,
    2 => :analog_ext_rc_invalid_format,
    3 => :analog_ext_rc_invalid_action,
  }
  I__ANALOG_EXT_RC = ANALOG_EXT_RC.invert

  GSM_MODE = {
    0 => :gsm_mode_multimode,
    1 => :gsm_mode_gsm_umts,
    2 => :gsm_mode_cdma2000,
  }
  I__GSM_MODE = GSM_MODE.invert

  OUTPUT_RULE_ERROR = {
    0 => :output_rule_error_success,
    1 => :output_rule_error_cond_not_met,
    2 => :output_rule_error_invalid_code,
    3 => :output_rule_error_invalid_cond,
    4 => :output_rule_error_invalid_value,
    5 => :output_rule_error_cond_no_support,
  }
  I__OUTPUT_RULE_ERROR = OUTPUT_RULE_ERROR.invert

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
      @data = OutputSchGet.new(@_io, self, @_root)
    when 84
      @data = OutputSchClear.new(@_io, self, @_root)
    when 83
      @data = OutputSchList.new(@_io, self, @_root)
    when 94
      @data = GsmMode.new(@_io, self, @_root)
    when 72
      @data = ModemApn.new(@_io, self, @_root)
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
      @rc = Kaitai::Struct::Stream::resolve_enum(OUTPUT_SCH_RC, @_io.read_u1)
    end
    attr_reader :rc
  end
  class FcPump < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = Kaitai::Struct::Stream::resolve_enum(FC_PUMP_RC, @_io.read_u1)
    end
    attr_reader :rc
  end
  class GsmNetwork < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @network = Kaitai::Struct::Stream::resolve_enum(GSM_NETWORK, @_io.read_u1)
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
  class ModemApn < Kaitai::Struct::Struct
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
  class OutputSet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @return_code = Kaitai::Struct::Stream::resolve_enum(OUTPUT_SET_RC, @_io.read_u1)
      @error_count = @_io.read_u1
      @errors = Array.new(error_count)
      (error_count).times { |i|
        @errors[i] = OutputRuleError.new(@_io, self, @_root)
      }
    end
    attr_reader :return_code
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
      @mode = Kaitai::Struct::Stream::resolve_enum(GSM_MODE, @_io.read_u1)
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
      @rc = Kaitai::Struct::Stream::resolve_enum(ANALOG_EXT_RC, @_io.read_u1)
      @analog = @_io.read_u1
      @format = Kaitai::Struct::Stream::resolve_enum(ANALOG_EXT_FORMAT, @_io.read_u1)
      @action = Kaitai::Struct::Stream::resolve_enum(ANALOG_EXT_ACTION, @_io.read_u1)
    end
    attr_reader :rc
    attr_reader :analog
    attr_reader :format
    attr_reader :action
  end
  class CdmaActivate < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @return_code = Kaitai::Struct::Stream::resolve_enum(CDMA_ACTIVATION_RC, @_io.read_u1)
    end
    attr_reader :return_code
  end
  class OutputGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = Kaitai::Struct::Stream::resolve_enum(OUTPUT_GET_RC, @_io.read_u1)
    end
    attr_reader :rc
  end
  class OutputRuleError < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @error = Kaitai::Struct::Stream::resolve_enum(OUTPUT_RULE_ERROR, @_io.read_u1)
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
    attr_reader :error
    attr_reader :code
    attr_reader :cond
    attr_reader :value
  end
  class OutputSchGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @rc = Kaitai::Struct::Stream::resolve_enum(OUTPUT_SCH_RC, @_io.read_u1)
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
      @rc = Kaitai::Struct::Stream::resolve_enum(INPUT_GET_RC, @_io.read_u1)
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
      @status = Kaitai::Struct::Stream::resolve_enum(LED_STATUS, @_io.read_u1)
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
