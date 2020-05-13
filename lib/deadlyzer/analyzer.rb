require 'deadlyzer/analyzer/utils'
require 'deadlyzer/analyzer/configurator'
require 'deadlyzer/constant_loader'
require 'deadlyzer/ast_parser'

require 'spinning_cursor'
require 'corol'

module Deadlyzer
  class Analyzer
    include Deadlyzer::Analyzer::Utils
    
    # @api private
    # @since 0.1.0
    attr_reader :config_file

    # @api private
    # @since 0.1.0
    attr_reader :config

    # @api private
    # @since 0.1.0
    attr_reader :config_file_ctx

    # @api private
    # @since 0.1.0
    attr_reader :target_constants

    # @api private
    # @since 0.1.0
    attr_reader :against_constants

    # @api private
    # @since 0.1.0
    attr_reader :constants_may_not_used

    attr_reader :empty_files
    
    def initialize(argv = [])
      @config_file            = argv.pop || default_config_file
      @empty_files            = []
      @constants_may_not_used = []
    end

    # Main wrapper analize method
    # @since 0.1.0
    def analize!
      SpinningCursor.run do
        banner "Analyzing".yellow
        type :dots
        
        action do
          read_configs!
          load_config!
          load_target_constants!
          load_against_constants!
          match!
          send_out!
        end
      end
    end

    private
    # @api private
    # @since 0.1.0
    def read_configs!
      @config_file_ctx = parse_yaml(config_file)
    rescue
      puts 'No config file found'
      exit 1
    end

    # @api private
    # @since 0.1.0
    def load_config!
      @config = Configurator.new(config_file_ctx)
    end

    # @api private
    # @since 0.1.0
    def load_target_constants!
      cl = ConstantLoader.new(
        directory:       config.target.fetch('path',           nil),
        excluded_dirs:   config.target.fetch('exclude_dirs',   nil),
        excluded_consts: config.target.fetch('exclude_consts', nil),
      )
      
      empty_files.push cl.empty_files.uniq
      @target_constants = cl.constants.uniq
    end

    # @api private
    # @since 0.1.0
    def load_against_constants!
      cl = ConstantLoader.new(
        directory:       config.against.fetch('path',           nil),
        excluded_dirs:   config.against.fetch('exclude_dirs',   nil),
        excluded_consts: config.against.fetch('exclude_consts', nil),
      )
      
      empty_files.push cl.empty_files.uniq
      @against_constants = cl.constants.uniq
    end

    # @api private
    # @since 0.1.0
    def match!
      match_constants(target: target_constants, against: against_constants)
      constants_may_not_used
    end

    # @api private
    # @since 0.1.0
    def send_out!
      puts "Files might be empty"
      empty_files.each do |file|
        puts file
      end

      puts "\nContants may not refered\n"
      constants_may_not_used.each do |constant|
        puts constant
      end
    end

    # @api private
    # @since 0.1.0
    def match_constants(target:, against:)
      used_constants = target.select do |tc|
         tc.name if against.any? {|ac| ac.name == tc.name}
      end
      
      constants = (used_constants + target).group_by(&:itself).transform_values(&:count)
      constants.each do |constant, count|
        constants_may_not_used.push constant if count < 2
      end
    end

  end
end