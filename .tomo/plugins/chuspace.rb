# typed: strong

require_relative "nodenv/tasks"

module Tomo::Plugin
  module Chuspace
    extend Tomo::PluginDSL

    defaults bashrc_path: ".bashrc",
             nodenv_version: "0.34.0",
             nodenv_node_version: nil,
             nodenv_yarn_version: nil

    tasks Tomo::Plugin::Nodenv::Tasks
  end
end
