# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRedmineBase0
  class PluginsTest
    class RakeTaskTest
      enable_simple_cache
      common_constructor :plugin

      def test_task?
        ::Rake::Task.task_defined?(test_task_name)
      end

      def test_task_name
        "#{plugin.id}:test"
      end

      def stderr_log
        log_path('stderr')
      end

      def stdout_log
        log_path('stdout')
      end

      private

      def log_path(suffix)
        r = ::Rails.root.join('log', 'eac_redmine_base0', "#{plugin.id}_test_#{suffix}.log")
        ::FileUtils.mkdir_p(::File.dirname(r))
        r
      end

      def run_test_uncached
        r = run_test_command.execute
        ::File.write(stderr_log, r.fetch(:stderr))
        ::File.write(stdout_log, r.fetch(:stdout))
        r.fetch(:exit_code).zero?
      end

      def run_test_command
        plugin.rails_gem.bundle('exec', 'rake', test_task_name).envvar('RAILS_ENV', 'test')
      end

      def test_result_uncached
        return ::Avm::Result.neutral("task \"#{test_task_name}\" not found") unless test_task?

        ::Avm::Result.success_or_error(
          run_test, 'success', "failed (Log: #{stdout_log})"
        )
      end
    end
  end
end
