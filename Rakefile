require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :benchmark do
  require 'konstructor'
  require 'benchmark'

  n = 10000

  Benchmark.bm(30) do |x|
    x.report('def:') do
      n.times do
        Class.new do
          def one; end
          def two; end
          def three; end
          def four; end
          def five; end
        end
      end
    end
    x.report('attr_accessor:') do
      n.times do
        Class.new do
          attr_accessor :one, :two, :three, :four, :five
        end
      end
    end
    x.report('konstructor after:') do
      n.times do
        Class.new do
          def one; end
          def two; end
          def three; end
          def four; end
          def five; end

          konstructor :one, :two, :three, :four, :five
        end
      end
    end
    x.report('konstructor before:') do
      n.times do
        Class.new do
          konstructor :one, :two, :three, :four, :five

          def one; end
          def two; end
          def three; end
          def four; end
          def five; end
        end
      end
    end
    x.report('konstructor nameless:') do
      n.times do
        Class.new do
          konstructor
          def one; end
          konstructor
          def two; end
          konstructor
          def three; end
          konstructor
          def four; end
          konstructor
          def five; end
        end
      end
    end
  end
end