# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'
require 'zlib'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.7')
  raise "Incompatible Kaitai Struct Ruby API: 0.7 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class Program < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    @code = @_io.read_u1
    @data = []
    while not @_io.eof?
      case code
      when 2
        @data << ProgramData.new(@_io, self, @_root)
      when 6
        @data << FirmwareVersion.new(@_io, self, @_root)
      when 7
        @data << FirmwareInfo.new(@_io, self, @_root)
      end
    end
  end
  class ProgramData < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @length = @_io.read_u2le
    end
    attr_reader :length
  end
  class FirmwareVersion < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @version_major = @_io.read_u1
      @version_minor = @_io.read_u1
      @version_revision = @_io.read_u1
    end
    attr_reader :version_major
    attr_reader :version_minor
    attr_reader :version_revision
  end
  class FirmwareInfo < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      @device_id = @_io.read_u4le
      @firmware_id = @_io.read_u1
      @version_major = @_io.read_u1
      @version_minor = @_io.read_u1
      @version_revision = @_io.read_u1
      @reset_cause = @_io.read_u1
    end
    attr_reader :device_id
    attr_reader :firmware_id
    attr_reader :version_major
    attr_reader :version_minor
    attr_reader :version_revision
    attr_reader :reset_cause
  end
  attr_reader :code
  attr_reader :data
end
