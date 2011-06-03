require 'rubygems'
require 'bundler/setup'

require 'active_support/core_ext/object/blank'
require 'barista'

Barista.setup_defaults

module Jasmine
  def self.app(config)
    Barista::Framework.register('jasmine', File.join(config.project_root, 'spec', 'coffeescripts'))

    Barista.configure do |c|
      c.add_preamble = false
      c.root = File.join(config.project_root, 'app', 'javascripts')
      c.change_output_root!('jasmine', config.spec_dir)
    end

    Rack::Builder.app do
      use Rack::Head

      map('/run.html')         { run Jasmine::Redirect.new('/') }
      map('/__suite__')        { run Barista::Filter.new(Jasmine::FocusedSuite.new(config)) }

      map('/__JASMINE_ROOT__') { run Rack::File.new(Jasmine.root) }
      map(config.spec_path)    { run Rack::File.new(config.spec_dir) }
      map(config.root_path)    { run Rack::File.new(config.project_root) }

      map('/favicon.ico')      { run Rack::File.new(File.join(config.project_root, 'public')) }

      map('/') do
        run Rack::Cascade.new([
          Rack::URLMap.new('/' => Rack::File.new(config.src_dir)),
          Barista::Filter.new(Jasmine::RunAdapter.new(config))
        ])
      end
    end
  end
end

module Jasmine
  class Config
    # Add your overrides or custom config code here
  end
end


# Note - this is necessary for rspec2, which has removed the backtrace
module Jasmine
  class SpecBuilder
    def declare_spec(parent, spec)
      me = self
      example_name = spec["name"]
      @spec_ids << spec["id"]
      backtrace = @example_locations[parent.description + " " + example_name]
      parent.it example_name, {} do
        me.report_spec(spec["id"])
      end
    end
  end
end
