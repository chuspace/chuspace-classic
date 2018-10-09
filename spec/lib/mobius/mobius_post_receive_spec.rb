# coding: utf-8
# frozen_string_literal: true


require 'spec_helper'
require 'mobius_post_receive'

describe MobiusPostReceive do
  let(:repository_path) { '/home/git/repositories' }
  let(:repo_name)   { 'dzaporozhets/mobius-ci' }
  let(:actor)   { 'key-123' }
  let(:changes) { "123456 789012 refs/heads/tést\n654321 210987 refs/tags/tag" }
  let(:wrongly_encoded_changes) { changes.encode('ISO-8859-1').force_encoding('UTF-8') }
  let(:base64_changes) { Base64.encode64(wrongly_encoded_changes) }
  let(:repo_path)  { File.join(repository_path, repo_name) + '.git' }
  let(:mobius_post_receive) { MobiusPostReceive.new(repo_path, actor, wrongly_encoded_changes) }
  let(:message) { 'test ' * 10 + 'message ' * 10 }
  let(:redis_client) { double('redis_client') }
  let(:enqueued_at) { Time.new(2016, 6, 23, 6, 59) }

  before do
    MobiusConfig.any_instance.stub(repos_path: repository_path)
    MobiusNet.any_instance.stub(broadcast_message: {})
    MobiusNet.any_instance.stub(:merge_request_urls).with(repo_path, wrongly_encoded_changes) { [] }
    MobiusNet.any_instance.stub(notify_post_receive: true)
    expect(Time).to receive(:now).and_return(enqueued_at)
  end

  describe '#exec' do
    before do
      allow_any_instance_of(MobiusNet).to receive(:redis_client).and_return(redis_client)
      allow_any_instance_of(MobiusReferenceCounter).to receive(:redis_client).and_return(redis_client)
      allow(redis_client).to receive(:get).and_return(1)
      allow(redis_client).to receive(:incr).and_return(true)
      allow(redis_client).to receive(:decr).and_return(0)
      allow(redis_client).to receive(:rpush).and_return(true)
    end

    context 'Without broad cast message' do
      context 'pushing new branch' do
        before do
          MobiusNet.any_instance.stub(:merge_request_urls).with(repo_path, wrongly_encoded_changes) do
            [{
              'branch_name' => 'new_branch',
              'url' => 'http://localhost/dzaporozhets/mobius-ci/merge_requests/new?merge_request%5Bsource_branch%5D=new_branch',
              'new_merge_request' => true
            }]
          end
        end

        it 'prints the new merge request url' do
          expect(redis_client).to receive(:rpush)

          expect(mobius_post_receive).to receive(:puts).ordered
          expect(mobius_post_receive).to receive(:puts).with(
            'To create a merge request for new_branch, visit:'
          ).ordered
          expect(mobius_post_receive).to receive(:puts).with(
            '  http://localhost/dzaporozhets/mobius-ci/merge_requests/new?merge_request%5Bsource_branch%5D=new_branch'
          ).ordered
          expect(mobius_post_receive).to receive(:puts).ordered

          mobius_post_receive.exec
        end
      end

      context 'pushing existing branch with merge request created' do
        before do
          MobiusNet.any_instance.stub(:merge_request_urls).with(repo_path, wrongly_encoded_changes) do
            [{
              'branch_name' => 'feature_branch',
              'url' => 'http://localhost/dzaporozhets/mobius-ci/merge_requests/1',
              'new_merge_request' => false
            }]
          end
        end

        it 'prints the view merge request url' do
          expect(redis_client).to receive(:rpush)

          expect(mobius_post_receive).to receive(:puts).ordered
          expect(mobius_post_receive).to receive(:puts).with(
            'View merge request for feature_branch:'
          ).ordered
          expect(mobius_post_receive).to receive(:puts).with(
            '  http://localhost/dzaporozhets/mobius-ci/merge_requests/1'
          ).ordered
          expect(mobius_post_receive).to receive(:puts).ordered

          mobius_post_receive.exec
        end
      end
    end

    context 'show broadcast message and merge request link' do
      before do
        MobiusNet.any_instance.stub(:merge_request_urls).with(repo_path, wrongly_encoded_changes) do
          [{
            'branch_name' => 'new_branch',
            'url' => 'http://localhost/dzaporozhets/mobius-ci/merge_requests/new?merge_request%5Bsource_branch%5D=new_branch',
            'new_merge_request' => true
          }]
        end
        MobiusNet.any_instance.stub(broadcast_message: { 'message' => message })
      end

      it 'prints the broadcast message and create new merge request link' do
        expect(redis_client).to receive(:rpush)

        expect(mobius_post_receive).to receive(:puts).ordered
        expect(mobius_post_receive).to receive(:puts).with(
          '========================================================================'
        ).ordered
        expect(mobius_post_receive).to receive(:puts).ordered

        expect(mobius_post_receive).to receive(:puts).with(
          '   test test test test test test test test test test message message'
        ).ordered
        expect(mobius_post_receive).to receive(:puts).with(
          '    message message message message message message message message'
        ).ordered

        expect(mobius_post_receive).to receive(:puts).ordered
        expect(mobius_post_receive).to receive(:puts).with(
          '========================================================================'
        ).ordered

        expect(mobius_post_receive).to receive(:puts).ordered
        expect(mobius_post_receive).to receive(:puts).with(
          'To create a merge request for new_branch, visit:'
        ).ordered
        expect(mobius_post_receive).to receive(:puts).with(
          '  http://localhost/dzaporozhets/mobius-ci/merge_requests/new?merge_request%5Bsource_branch%5D=new_branch'
        ).ordered
        expect(mobius_post_receive).to receive(:puts).ordered


        mobius_post_receive.exec
      end
    end

    it 'pushes a Sidekiq job onto the queue' do
      expect(redis_client).to receive(:rpush).with(
        'resque:mobius:queue:post_receive',
         %Q/{"class":"PostReceive","args":["#{repo_path}","#{actor}",#{base64_changes.inspect}],"jid":"#{mobius_post_receive.jid}","enqueued_at":#{enqueued_at.to_f}}/
      ).and_return(true)

      mobius_post_receive.exec
    end

    context 'reference counter' do
      it 'decreases the reference counter for the project' do
        expect_any_instance_of(MobiusReferenceCounter).to receive(:decrease).and_return(true)

        mobius_post_receive.exec
      end

      context 'when the redis command succeeds' do
        before do
          allow(redis_client).to receive(:decr).and_return(0)
        end

        it 'returns true' do
          expect(mobius_post_receive.exec).to eq(true)
        end
      end

      context 'when the redis command fails' do
        before do
          allow(redis_client).to receive(:decr).and_raise('Fail')
        end

        it 'returns false' do
          expect(mobius_post_receive.exec).to eq(false)
        end
      end
    end

    context 'post_receive notification' do
      it 'calls the api to notify the execution of the hook' do
        expect_any_instance_of(MobiusNet).to receive(:notify_post_receive).
          with(repo_path)

        mobius_post_receive.exec
      end
    end

    context 'when the redis command succeeds' do

      before do
        allow(redis_client).to receive(:rpush).and_return(true)
      end

      it 'returns true' do
        expect(mobius_post_receive.exec).to eq(true)
      end
    end

    context 'when the redis command fails' do

      before do
        allow(redis_client).to receive(:rpush).and_raise('Fail')
      end

      it 'returns false' do
        expect(mobius_post_receive.exec).to eq(false)
      end
    end
  end
end
