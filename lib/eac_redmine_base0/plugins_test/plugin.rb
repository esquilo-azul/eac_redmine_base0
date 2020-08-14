# frozen_string_literal: true

require 'avm/instances/configuration' # TO-DO: remove when fixed in gem "avm-tools"
require 'avm/patches/eac_ruby_gems_utils/gem'
require 'avm/result'
require 'eac_ruby_utils/simple_cache'

module EacRedmineBase0
  class PluginsTest
    class Plugin < ::SimpleDelegator
      include ::EacRubyUtils::SimpleCache

      def initialize(plugin)
        super(plugin)
      end

      def maintained?
        ::EacRedmineBase0.maintained_plugins.any? { |plugin| plugin.id == id }
      end

      def tests
        return [test_by_type(:unmaintened_stub)] unless maintained?

        [test_by_type(:rake_task)]
      end

      private

      def test_by_type(type)
        ::EacRedmineBase0::PluginsTest.const_get(type.to_s.camelize + 'Test').new(self)
      end

      def rails_gem_uncached
        ::EacRubyGemsUtils::Gem.new(::Rails.root)
      end
    end
  end
end
