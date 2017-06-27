# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
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
