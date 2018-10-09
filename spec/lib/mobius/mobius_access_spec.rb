# frozen_string_literal: true

require 'spec_helper'
require 'mobius_access'

describe MobiusAccess do
  let(:repository_path) { '/home/git/repositories' }
  let(:repo_name)   { 'dzaporozhets/mobius-ci' }
  let(:repo_path)  { File.join(repository_path, repo_name) + '.git' }
  let(:api) do
    double(MobiusNet).tap do |api|
      api.stub(check_access: GitAccessStatus.new(true, 'ok', '/home/git/repositories'))
    end
  end
  subject do
    MobiusAccess.new(repo_path, 'key-123', 'wow', 'ssh').tap do |access|
      access.stub(exec_cmd: :exec_called)
      access.stub(api: api)
    end
  end

  before do
    MobiusConfig.any_instance.stub(repos_path: repository_path)
  end

  describe :initialize do
    it { subject.repo_path.should == repo_path }
    it { subject.changes.should == ['wow'] }
    it { subject.protocol.should == 'ssh' }
  end

  describe '#exec' do
    context 'access is granted' do

      it 'returns true' do
        expect(subject.exec).to be_true
      end
    end

    context 'access is denied' do

      before do
        api.stub(check_access: GitAccessStatus.new(false, 'denied', nil))
      end

      it 'returns false' do
        expect(subject.exec).to be_false
      end
    end

    context 'API connection fails' do

      before do
        api.stub(:check_access).and_raise(MobiusNet::ApiUnreachableError)
      end

      it 'returns false' do
        expect(subject.exec).to be_false
      end
    end
  end
end
