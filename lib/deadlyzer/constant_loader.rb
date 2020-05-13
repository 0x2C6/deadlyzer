require 'deadlyzer/ast_parser'
require 'deadlyzer/ast_matcher'

module Deadlyzer
  class ConstantLoader
    CURRENT_DIRECTORY = File.expand_path('.', __dir__)
    DEFAULT_PATTERN   = '/**/*.rb'
    
    # @api private
    # @since 0.1.0
    attr_reader :directory

    # @api private
    # @since 0.1.0
    attr_reader :excluded_dirs

    # @api private
    # @since 0.1.0
    attr_reader :empty_files

    # @api private
    # @since 0.1.0
    attr_reader :excluded_consts

    # @api private
    # @since 0.1.0
    attr_reader :exclude

    # @api private
    # @since 0.1.0
    attr_reader :pattern

    # @api private
    # @since 0.1.0
    attr_accessor :ast
    
    def initialize(directory: nil, excluded_dirs: nil, excluded_consts: nil, pattern: nil)
      @directory       = directory
      @excluded_dirs   = excluded_dirs || []
      @excluded_consts = excluded_consts || []
      @pattern         = pattern       || DEFAULT_PATTERN
      @ast             = []
      @constants       = []
      @empty_files     = []
    end

    # @api private
    # @since 0.1.0
    def constants
      load_ast!
      load_matcher!
      load_constants!
      @constants
    end

    private
    # @api private
    # @since 0.1.0
    def load_ast!
      files.each do |file|
        # TODO: check momory issue
        parser = Deadlyzer::AST::Parser.new
        ast.push parser.parse(read(file), file)
      end
    end

    # @api private
    # @since 0.1.0
    def load_matcher!
      @matcher = Deadlyzer::AST::Matcher.new
    end

    # @api private
    # @since 0.1.0
    def load_constants!
      ast.each do |node|
        @empty_files.push node.file && next if node.ast.nil?
        
        file    = node.file
        results = determine_consts(@matcher, node.ast)

        results.each do |result|
          line, name = humanize_const(result)
          @constants.push(Constant.new(file, line, name)) unless excluded_consts.include?(name)
        end
      end
    end

    # @api private
    # @since 0.1.0
    def determine_consts(matcher, node)
      match = matcher.match(node: node)
      if match
        match == true ? node : [match, node]
      else
        if node.respond_to?(:children) && !node.children.empty?
          node.children.grep(RuboCop::AST::Node).flat_map{|e| determine_consts(matcher, e)}.compact
        end
      end
    end

    # @api private
    # @since 0.1.0
    def humanize_const(result)
      if result.is_a?(RuboCop::AST::Node)
        range = result.source_range
        result = result.source
      else
        result, node = result
        range = node.source_range
      end
      [range.line, result, :ruby]
    end

    # @api private
    # @since 0.1.0
    def files
      target_directory = list_dir(path(directory + pattern))
      remove(files: excluded_files, from: target_directory)
    end

    # @api private
    # @since 0.1.0
    def excluded_files
      excluded_dirs.flat_map {|dir| list_dir(path(dir+ pattern))}.flatten
    end

    # @api private
    # @since 0.1.0
    # def excluded_constants

    # end
    
    # @api private
    # @since 0.1.0
    def path(dir)
      File.expand_path(dir)
    end

    # @api private
    # @since 0.1.0
    def list_dir(dir)
      Dir[dir]
    end

    # @api private
    # @since 0.1.0
    def remove(files:, from:)
      files.each do |file|
        from.delete file
      end
      from
    end

    # @api private
    # @since 0.1.0
    def read(file)
      File.read file
    end

    # @api private
    # @since 0.1.0
    class Constant
      require 'coderay'

      attr_reader :file
      attr_reader :line
      attr_reader :name
      def initialize(file, line, name)
        @file = file
        @line = line
        @name = name
      end

      def to_s
        [file, line, rubyize(name)].join(':')
      end

      private
      def rubyize(name)
        " #{CodeRay.scan(name, :ruby).term}"
      end
    end

  end
end