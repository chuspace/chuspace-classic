# typed: false

def copy_env_vars
  env_vars = File.read('.env.production')
  remote.write text: env_vars, to: "#{paths.current}/.env"
end

def compile_mobius
  remote.run "cd #{paths.current} && bundle exec rails chuspace:setup"
end

def copy_sshd_config
  remote.run "cp #{paths.current}/openssh/sshd_config.example #{paths.current}/openssh/sshd_config"
end

def restart_puma_and_anycable
  remote.run 'systemctl --user restart anycable puma.service delayed_job'
end

def setup_error_pages
  public_500_html = File.join(paths.release, 'public/500.html')
  execute :curl, '-k', 'https://chuspace.com/500', "> #{public_500_html}"
end
