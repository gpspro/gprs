
require "bindata"

require "gprs/defs"

module Gprs
  REPORT_DATA_ID_DRIVER_KEY     = 1     # Driver Key (64-bit ID)
  REPORT_DATA_ID_ADDITIONAL_IO  = 2     # Additional IO (Voltages, Inputs, Outputs, Analogs, etc)

  class DriverKey < BinData::Record
    endian :little

    uint64  :driver_key
  end

  class AdditionalIO < BinData::Record
    endian :little

    hide :unassigned_bit

    # Mask bits (read MSB to LSB? Why? )
    bit1   :unassigned_bit
    bit1   :has_orientation
    bit1   :has_output_3
    bit1   :has_input_3
    bit1   :has_adc_input_2
    bit1   :has_adc_input_1
    bit1   :has_ext_voltage
    bit1   :has_int_voltage

    # Internal Battery
    choice :int_voltage, :selection => :has_int_voltage do
      skip_null 0
      uint16    1
    end

    # External Power
    choice :ext_voltage, :selection => :has_ext_voltage do
      skip_null 0
      uint16    1
    end

    # ADC Input 1
    u_int8_if :adc_input_1, :selection => :has_adc_input_1

    # ADC Input 2
    u_int8_if :adc_input_2, :selection => :has_adc_input_2

    # Input 3
    u_int8_if :input_3, :selection => :has_input_3

    # Output 3
    u_int8_if :output_3, :selection => :has_output_3

    # Orientation
    u_int8_if :orientation, :selection => :has_orientation
  end

  class ReportData < BinData::Record
    endian :little

    uint8 :id
    choice :data, :selection => :id do
      driver_key     REPORT_DATA_ID_DRIVER_KEY
      additional_io  REPORT_DATA_ID_ADDITIONAL_IO

      skip  :default, :length => 0, :value => "Unknown Data ID"
    end
  end
end