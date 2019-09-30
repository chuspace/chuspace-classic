# typed: false
# frozen_string_literal: true

every 1.day, at: '5:30 am' do
  runner 'RunGitGcJob.perform_later'
end
