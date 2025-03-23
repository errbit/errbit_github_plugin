# frozen_string_literal: true

require "rails/engine"

module ErrbitGithubPlugin
  class Engine < ::Rails::Engine
    initializer :assets do
      Rails.application.config.assets.paths << root.join("app", "assets", "images", "errbit_github_plugin")
    end
  end
end
