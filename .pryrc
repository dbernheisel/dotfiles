Pry.config.editor = 'nvim'

unless Pry::VERSION.include?("0.9.")
  Pry.config.pager = false

  # Prompt with ruby version
  Pry.config.prompt = Pry::Prompt.new(
    "Ruby Version Prompt",
    "Ruby Version Prompt",
    [
      proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " },
      proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }
    ]
  )

  # loading rails configuration if it is running as a rails console
  # load File.dirname(__FILE__) + '/.railsrc' if defined?(Rails) && Rails.env
end

if defined?(PryByeBug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

begin
  require "awesome_print"
rescue LoadError
  nil
end
