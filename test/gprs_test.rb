require 'test_helper'

require 'benchmark'

class GprsTest < Minitest::Test
  def self.test_order
    :alpha
  end

  def test_that_it_has_a_version_number
    refute_nil ::Gprs::VERSION
  end

=begin
  def test_1_parse_report_single
    parse_report_single(true, true)
  end

  def test_2_parse_report_multiple
    parse_report_multiple(true, true)
  end

  def test_3_parse_report_bench
    puts ""
    puts "# Benchmarking report parsing performance (BinData):"

    Benchmark.bm(40) do |x|
      x.report("1 packet (1 report 1 time)") do
        parse_report_single(false, true)
      end

      x.report("5000 packets (1 report 5000 times)") do
        for i in 0..5000
          parse_report_single(false, true)
        end
      end

      x.report("10000 packets (1 report 10000 times)") do
        for i in 0..10000
          parse_report_single(false, true)
        end
      end

      x.report("100000 packets (1 report 100000 times)") do
        for i in 0..100000
          parse_report_single(false, true)
        end
      end
    end
  end
=end

  # Parse a report and print to console
  def test_5_parse_report_single_c
    parse_report_single(true, false)
  end

  def test_6_parse_report_multiple_c
    parse_report_multiple(true, false)
  end

  def test_7_parse_report_other_c
    parse_report_other(true)
  end

  def test_8_parse_report_bench_c
    puts ""
    puts "# Benchmarking report parsing performance (C extension):"

    Benchmark.bm(40) do |x|

      x.report("1 packet (1 report 1 time)") do
        parse_report_single(false, false)
      end

      x.report("5000 packets (1 report 5000 times)") do
        for i in 0..5000
          parse_report_single(false, false)
        end
      end

      x.report("10000 packets (1 report 10000 times)") do
        for i in 0..10000
          parse_report_single(false, false)
        end
      end

      x.report("100000 packets (1 report 100000 times)") do
        for i in 0..100000
          parse_report_single(false, false)
        end
      end
    end
  end

  def test_9_detect_packet_types
    detect_packet_types(true)
  end

end
