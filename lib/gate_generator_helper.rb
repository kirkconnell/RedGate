module GateGeneratorHelper
  attr_reader :gate_options, :gate_value_options, :receivers, :processes
  
  def parse(arguments)
    @valid_options = %w{queue guaranteed processor filter router splitter poller}
    @processes = []
    @receivers = []
    @gate_options = []
    arguments.each { |arg| classify_argument(arg) }
    identify_processes
  end
  
  def classify_argument(arg)
    if @valid_options.include? arg
      @gate_options << arg
    else
      @receivers << arg
    end
  end
  
  def identify_processes
    valid_processes = %w{processor filter router splitter}
    gate_options.each { |opt| processes << opt.to_sym if valid_processes.include? opt }
  end
  
  def render(command)
    if command.kind_of? Hash
      send "render_#{command.values.first.to_s}".to_sym
    else
      send "render_#{command.to_s}".to_sym
    end
  end
  
  def render_gate_definition
    "gate #{gate_definition_params}"
  end
  
  def render_receivers
    if receivers.length == 1
      "receiver '#{receivers.first}'"
    elsif receivers.length > 1
      "receivers #{receivers.collect{|r| "'#{r}'"}.join(', ')}"
    end
  end
  
  def render_processor
    desc = "#{file_name.singularize} processor"
"process \"#{desc}\" do |#{file_name.singularize}|
  # to do: process body
end"
  end
  
  def render_filter
    desc = "#{file_name.singularize} filter"
"process \"#{desc}\" do |#{file_name.singularize}|
  discard if false # to do: filter condition
end"
  end
  
  def render_router
"process \"#{file_name.singularize} router\" do |#{file_name.singularize}|
  # to do: write real conditions and uri's
  if condition1
    deliver :message => sample, :to => uri1
  elseif condition2
    deliver :message => sample, :to => uri2
  else
    deliver :message => sample, :to => uri3
  end
end"
  end
  
  def render_splitter
"process \"#{file_name.singularize} splitter\" do |#{file_name.singularize}|
  part1, part2, part3 = split(#{file_name.singularize})
  # to do: write the real uri's
  deliver :message => part1, :to => uri1
  deliver :message => part2, :to => uri2
  deliver :message => part3, :to => uri3
end

def split(#{file_name.singularize})
  # to do: write the splitting logic
  [#{file_name.singularize}, #{file_name.singularize}, #{file_name.singularize}]  
end"
  end
  
  def gate_definition_params
    params = [":#{file_name}"]
    params << ":queue => true" if gate_options.include? "queue"
    params << ":guaranteed => true" if gate_options.include? "guaranteed"
    params.join(", ")
  end
  
end