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
    if code == 20
      @data = SendvalRequest.new(@_io, self, @_root)
    end
    if code == 31
      @data = ParamRequest.new(@_io, self, @_root)
    end
    if code == 80
      @data = FcPump.new(@_io)
    end
    if code == 87
      @data = AnalogExt.new(@_io, self, @_root)
    end
    if code == 88
      @data = AnalogGet.new(@_io, self, @_root)
    end
    if code == 89
      @data = InputGet.new(@_io, self, @_root)
    end
    if code == 90
      @data = OutputGet.new(@_io, self, @_root)
    end
    if code == 91
      @data = OutputSet.new(@_io, self, @_root)
    end
    if code == 130
      @data = SetUnitid.new(@_io, self, @_root)
    end
  end
  class SetUnitid < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @unit_id = @_io.read_u4le
    end
    attr_reader :unit_id
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
      @format = @_io.read_u1
      @action = @_io.read_u1
    end
    attr_reader :analog
    attr_reader :format
    attr_reader :action
  end
  class OutputGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @output = @_io.read_u1
    end
    attr_reader :output
  end
  class InputGet < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @input = @_io.read_u1
    end
    attr_reader :input
  end
  attr_reader :code
  attr_reader :data
  attr_reader :data
  attr_reader :data
  attr_reader :data
  attr_reader :data
  attr_reader :data
  attr_reader :data
  attr_reader :data
  attr_reader :data
end
