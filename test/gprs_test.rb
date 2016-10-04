require 'test_helper'

require 'benchmark'

class GprsTest < Minitest::Test
  # TODO: Remove this later?
  def self.test_order
   :alpha
  end

  def test_that_it_has_a_version_number
    refute_nil ::Gprs::VERSION
  end

  def test_parse_report_1
    parse_report_single(true)
  end

  def test_parse_report_5
    parse_report_multiple(true)
  end

  def test_parse_report_bench
    puts ""
    puts "# Benchmarking report parsing performance:"

    Benchmark.bm(40) do |x|
      x.report("5000 packets (1 report 5000 times)") do
        for i in 0..5000
          parse_report_single(false)
        end
      end

      x.report("5000 packets (5 reports 1000 times)") do
        for i in 0..1000
          parse_report_multiple(false)
        end
      end

      x.report("10000 packets (1 report 10000 times)") do
        for i in 0..10000
          parse_report_single(false)
        end
      end

      x.report("100000 packets (1 report 100000 times)") do
        for i in 0..100000
          parse_report_single(false)
        end
      end
    end
  end
end
