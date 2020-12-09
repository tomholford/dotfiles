require 'amazing_print'

# == Pry-Nav - Using pry as a debugger ==
Pry.commands.alias_command 'c', 'continue' rescue nil
Pry.commands.alias_command 's', 'step' rescue nil
Pry.commands.alias_command 'n', 'next' rescue nil

def benchmark_time(repetitions = 100, &block)
  require 'benchmark'
  Benchmark.bm{ |b| b.report{ repetitions.times(&block) } }
end
