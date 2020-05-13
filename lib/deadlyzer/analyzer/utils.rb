require 'yaml'

module Deadlyzer
  class Analyzer
    module Utils
      def self.included(base)
        base.include InstanceMethods
      end

      module InstanceMethods
        # @api private
        # @since 0.1.0
        def parse_yaml(path)
          ctx = read_file(path)

          YAML.load(ctx)
        end
        
        # Default name of config file
        # @api private
        # @since 0.1.0
        def default_config_file
          './deadlyzer.yml'
        end

        # @api private
        # @since 0.1.0
        def read_file(path)
          File.read(File.expand_path(path))
        end
        
      end
    end
  end
end