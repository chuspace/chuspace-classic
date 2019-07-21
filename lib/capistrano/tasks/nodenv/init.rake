namespace :nodenv do
  desc 'Init nodenv'
  task :init do
    on roles(:all) do
      execute 'eval "$(nodenv init -)'
    end
  end
end
