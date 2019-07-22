# typed: ignore
require "shellwords"

module Tomo::Plugin::Nodenv
  class Tasks < Tomo::TaskLibrary
    def install
      remote.mkdir_p raw("$HOME/.nodenv")
      modify_bashrc
      run_installer
      install_node
      install_yarn
    end

    private

    def run_installer
      require_setting :nodenv_version

      nodenv_version = settings[:nodenv_version]
      install_url = "https://raw.githubusercontent.com/creationix/nodenv/"\
                    "v#{nodenv_version}/install.sh"
      remote.run("curl -o- #{install_url.shellescape} | bash")
    end

    def modify_bashrc
      existing_rc = remote.capture("cat", paths.bashrc, raise_on_error: false)
      return if existing_rc.include?("nodenv init")

      remote.write(text: <<~BASHRC + existing_rc, to: paths.bashrc)
        export PATH="$HOME/.nodenv/bin:$PATH"
        ~/.nodenv/bin/nodenv init
      BASHRC
    end

    def install_node
      require_setting :nodenv_node_version
      node_version = settings[:nodenv_node_version]

      unless node_installed?(node_version)
        remote.run "nodenv", "install", node_version
      end

      remote.run "nodenv", "global", node_version
    end

    def install_yarn
      version = settings[:nodenv_yarn_version]
      return remote.run "npm i -g yarn@#{version.shellescape}" if version

      logger.info "No :nodenv_yarn_version specified; skipping yarn installation."
    end

    def node_installed?(version)
      versions = remote.capture("nodenv versions", raise_on_error: false)
      if versions.include?(version)
        logger.info("Node #{version} is already installed.")
        return true
      end
      false
    end
  end
end
