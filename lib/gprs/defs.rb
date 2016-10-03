
require "bindata"

# Common GPRS fields
GPRS_SOP        = 0x28
GPRS_EOP        = 0x29
GPRS_NEWLINE    = 0x0D
GPRS_DLE        = 0x10
GPRS_DLE_OFFSET = 128

class ZeroSkip < BinData::Primitive
  skip :length => 0

  def get; 0; end
  def set(v); ; end
end

class UInt8If < BinData::Choice
  zero_skip   0
  uint8       1
end