# frozen_string_literal: true

require 'eac_ruby_utils/console/speaker'
require 'eac_ruby_utils/envs'

module EacRedmineBase0
  class PluginsTest
    include ::EacRubyUtils::Console::Speaker

    def run
      @plugins = []
      ::Redmine::Plugin.registered_plugins.each_value do |plugin|
        check_plugin(plugin)
      end
      check_results
    end

    def check_plugin(plugin)
      infom "Checking plugin \"#{plugin.id}\"..."
      test_plugin = ::EacRedmineBase0::PluginsTest::Plugin.new(plugin)
      test_plugin.test_result
      infom "Plugin \"#{plugin.id}\" checked"
      @plugins << test_plugin
      results_banner
    end

    def results_banner
      infom 'Plugins\' test results:'
      @plugins.each do |plugin|
        infov "  * #{plugin.id}", plugin.test_result.label
      end
    end

    def plugins_failed
      @plugins.select { |plugin| plugin.test_result.error? }
    end

    def check_results
      if plugins_failed.any?
        fatal_error "Some test did not pass:\n" +
                    plugins_failed.map { |p| "  * #{p.id} (Log: #{p.stdout_log})" }.join("\n")
      else
        success 'All tests passed'
      end
    end
  end
end
