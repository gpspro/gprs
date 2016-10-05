
require "bindata"

require "gprs/defs"
require "gprs/report_data"

module Gprs
  REPORT_TYPE_POSITION            = 0     # Position
  REPORT_TYPE_ALPHANUM_MSG        = 1     # No idea what this is for
  REPORT_TYPE_ALPHANUM_MSG_SPEC   = 2     # No idea what this is for
  REPORT_TYPE_CODED_POS           = 3     # Position with alert
  REPORT_TYPE_QUERY_ANS           = 4     # Answer to query
  REPORT_TYPE_COMP_POS            = 6     # Compressed positions
  REPORT_TYPE_ACKNOWLEDGE         = 7     # ACK to messsage from Gateway
  REPORT_TYPE_EXTENDED_DATA       = 8     # Extended report data with code
  REPORT_TYPE_CODED_COMP_POS      = 9     # Compressed positions with alert

  # Returns a "raw" parse of a report with no conversions performed
  class Report < BinData::Record
    endian :little

    # Ref
    bit_le  :ref,         :nbits => 6
    bit_le  :has_cell,    :nbits => 1
    bit_le  :has_gps,     :nbits => 1

    # Type
    bit_le  :report_type, :nbits => 4
    bit_le  :has_modsts,  :nbits => 1
    bit_le  :has_temp,    :nbits => 1
    bit_le  :id_len,      :nbits => 2

    # IO
    bit_le  :input_1,     :nbits => 1
    bit_le  :input_2,     :nbits => 1
    bit_le  :output_1,    :nbits => 1
    bit_le  :output_2,    :nbits => 1
    bit_le  :lat_south,   :nbits => 1
    bit_le  :lon_west,    :nbits => 1
    bit_le  :has_cog,     :nbits => 1
    bit_le  :has_lac,     :nbits => 1

    # Time
    uint32  :time_secs

    # Device ID (1 - 4 bytes)
    choice  :device_id, :selection => :id_len do
      uint8   0
      uint16  1
      uint24  2
      uint32  3
    end

    # If has_gps

    # Latitude
    choice :lat, :selection => :has_gps do
      skip_null 0
      bit       1, :nbits => 23
    end

    # GPS Valid
    choice :gps_invalid, :selection => :has_gps do
      skip_null 0
      bit       1, :nbits => 1
    end

    # Longitude
    choice :lon, :selection => :has_gps do
      skip_null 0
      uint24    1
    end

    # Speed
    u_int8_if :speed, :selection => :has_gps
    # End if has_gps

    # COG (If has_cog is set)
    u_int8_if :cog, :selection => :has_cog

    # Code (For certain types)
    choice :code, :selection => :report_type do
      uint8     REPORT_TYPE_CODED_POS
      uint8     REPORT_TYPE_EXTENDED_DATA
      uint8     REPORT_TYPE_CODED_COMP_POS
      skip_null :default
    end

    # Modsts
    u_int8_if :modsts, :selection => :has_modsts

    # Temp
    u_int8_if :temp, :selection => :has_temp

    # Cell ID
    choice :cell_id, :selection => :has_cell do
      skip_null 0
      uint16    1
    end

    # Signal
    choice :signal, :selection => :has_cell do
      skip_null 0
      uint8     1
    end

    choice :lac, :selection => :has_lac do
      skip_null 0
      uint16    1
    end

    # Extended Report Data
    choice :ext_data, :selection => :report_type do
      skip_null   :default
      report_data REPORT_TYPE_EXTENDED_DATA
    end
  end
end