# typed: false

def copy_env_vars
  env_vars = File.read('.env.production')
  remote.write text: env_vars, to: "#{paths.current}/.env"
end

def copy_sshd_config
  remote.run "cp #{paths.current}/openssh/sshd_config.example #{paths.current}/openssh/sshd_config"
end

def restart_puma_and_anycable
  remote.run 'systemctl --user restart anycable puma.service'
end
