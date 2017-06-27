# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class FcPump < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    @txn_id = @_io.read_u4le
    @timeout = @_io.read_u4le
    @reset = @_io.read_u4le
    @max = @_io.read_u4le
  end
  attr_reader :txn_id
  attr_reader :timeout
  attr_reader :reset
  attr_reader :max
end
