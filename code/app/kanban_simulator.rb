require File.dirname(__FILE__) + "/../model/simulation.rb"

# Executable for running Kanban simulations
#
# Author:: John S. Ryan (jtigger@infosysengr.com)
class TextUi
  PROGRAM = File.basename(__FILE__)
  attr_accessor :verbosity
  
  def initialize
    @verbosity = 3
  end
  
  def error(message)
    $stderr.puts("#{PROGRAM}:ERROR:#{message}")  
  end
  
  def warn(message)
    $stderr.puts("#{PROGRAM}:WARN:#{message}") if @verbosity >= 0
  end
  
  def info(message)
    $stderr.puts("#{PROGRAM}:INFO:#{message}") if @verbosity >= 1    
  end
  
  def debug(message)
    $stderr.puts("#{PROGRAM}:DEBUG:#{message}") if @verbosity >= 2
  end

  def trace(message)
    $stderr.puts("#{PROGRAM}:TRACE:#{message}") if @verbosity >= 3
  end
end

class KanbanSimulator

  def initialize
    @ui = TextUi.new
    @simulation = Simulation.new
  end
  
  def usage
    @ui.info("Usage:")
    @ui.info("  ruby kanban_simulator.rb <number of stories>")
    @ui.info("where:")
    @ui.info("  <number of stories> = initial size of the backlog.")
  end
  
  def parse_options
    expected_num_of_params = 1
    
    if ARGV.size == expected_num_of_params
      @num_of_stories = ARGV[0].to_i
      @ui.trace("ARGV = #{ARGV.to_s}")
    else
      raise "Invalid number of parameters.  Expected #{expected_num_of_params} but there was #{ARGV.size}."
    end
  end
  
  def main
      @ui.info("KanbanSimulator(R)   Software Development Workflow Simulator    2010-11-05")
      begin
        parse_options
      rescue RuntimeError
        usage
        return -1
      end
      @ui.info("Configuring the workflow...")
      
      @simulation.configure(File.dirname(__FILE__) + "/simulation_config.txt")
      
      @ui.info("Workflow definition:")
      @simulation.workflow.steps.each_with_index { |step, idx|
        # @ui.info("Step #{idx} = #{step.name} (WIP Limit = #{step.wip_limit})")
        @ui.info("Step #{idx} = #{step.name}")
      }

      # @ui.info("Initializing backlog...")
      # @simulation.generate_to_backlog(@num_of_stories) do |work_item, idx|
      #   work_item.priority = idx
      #   work_item.estimated_points = WorkItem::Acceptable_Point_Values[rand(5)]
      # end
      # @simulation.work_items.each_with_index { |work_item, idx|
      #   @ui.info("Story card \##{idx}: priority = #{work_item.priority}; estimate = #{work_item.estimated_points}")  
      # }
  end
end

KanbanSimulator.new.main()