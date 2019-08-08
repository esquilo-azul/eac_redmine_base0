# frozen_string_literal: true

namespace :eac_redmine_base0 do
  namespace :plugins do
    desc 'Lists plugins maintained by E.A.C..'
    task list: :environment do
      ::EacRedmineBase0.maintained_plugins.each do |plugin|
        ::Rails.logger.info("Plugin: #{plugin.name} (ID: #{plugin.id})")
      end
    end
  end

  task plugins: 'plugins:list'
end
