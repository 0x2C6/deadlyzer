module Deadlyzer
  module AST
    class Parser
      # AST Parser
      # @api private
      # @since 0.1.0

      # @api private
      # @since 0.1.0
      attr_reader :parser
      
      # @since 0.1.0
      attr_reader :ast

      # @since 0.1.0
      attr_reader :file

      def initialize(parser: nil)
        @parser = parser || default_parser
      end

      # @api private
      # @since 0.1.0
      def parse(code, file = nil)
        processed_source = parse_code(code, file)
        @ast             = processed_source.ast
        @file            = processed_source.path
        self
      end

      private
      # @api private
      # @since 0.1.0
      def default_parser
        require 'rubocop'
        RuboCop::ProcessedSource
      end

      # @api private
      # @since 0.1.0
      def parse_code(code, file)
        parser.new(code, RUBY_VERSION.to_f, file)
      end

    end
  end
end