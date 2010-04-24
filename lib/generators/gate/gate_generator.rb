class GateGenerator < Rails::Generator::NamedBase
  include GateGeneratorHelper
  
  def manifest
    record do |m|
      parse args
      m.template "gate.rb.erb", "config/gates/#{file_name}.rb"
    end
  end
end