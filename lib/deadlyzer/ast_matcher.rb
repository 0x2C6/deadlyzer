module Deadlyzer
  module AST
    class Matcher
      # @api private
      # @since 0.1.0
      DEFAULT_PATTERN = '(const ... )'

      # @api private
      # @since 0.1.0
      attr_reader :matcher
      
      # @api private
      # @since 0.1.0
      attr_reader :pattern
      
      def initialize(matcher: nil, pattern: nil)
        @matcher  = matcher || default_matcher
        @pattern  = pattern || DEFAULT_PATTERN
      end

      # @api private
      # @since 0.1.0
      def match(node:)
        matcher.new(pattern).match(node)
      end

      private
      # @api private
      # @since 0.1.0
      def default_matcher
        require 'rubocop'
        RuboCop::NodePattern
      end    
    end
  end
end