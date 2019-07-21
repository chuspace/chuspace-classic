namespace :nodenv do
  desc 'Init nodenv'
  task :init do
    on roles(:all) do
      run_locally do
        execute 'eval "$(nodenv init -)'
      end
    end
  end
end
