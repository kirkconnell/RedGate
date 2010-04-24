module GateGeneratorHelper
  attr_reader :gate_options, :gate_value_options, :receivers, :processes
  
  def parse(arguments)
    @processes = []
    @receivers = []
    @gate_options = []
    @gate_value_options = {}
    arguments.each { |arg| classify_argument(arg) }
    identify_processes
  end
  
  def classify_argument(arg)
    if /--(\w+)/ === arg
      @gate_options << $1
      @gate_value_options[$1.to_sym] = $2 if /--(\w+)=(.+)/ === arg
    else
      @receivers << arg
    end
  end
  
  def identify_processes
    valid_processes = %w{processor filter router splitter normalizer}
    gate_options.each { |opt| processes << opt.to_sym if valid_processes.include? opt }
  end
  
  def render(command)
    send("render_#{command.to_s}".to_sym)
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
  
  def gate_definition_params
    params = [":#{file_name}"]
    params << ":queue => true" if gate_options.include? "queue"
    params << ":guaranteed => true" if gate_options.include? "guaranteed"
    params.join(", ")
  end
  
end