# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class GprsCommand < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    @ref = @_io.read_bits_int(4)
    @type = @_io.read_bits_int(4)
    @_io.align_to_byte
    case type
    when 4
      @type_class = ConfigMsg.new(@_io)
    when 5
      @type_class = Program.new(@_io)
    when 6
      @type_class = SendvalReply.new(@_io)
    when 8
      @type_class = ParamReply.new(@_io)
    end
  end
  attr_reader :ref
  attr_reader :type
  attr_reader :type_class
end
