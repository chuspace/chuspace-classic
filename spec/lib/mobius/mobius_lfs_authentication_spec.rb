# frozen_string_literal: true

require 'spec_helper'
require 'mobius_lfs_authentication'
require 'json'

describe MobiusLfsAuthentication do
  subject do
    MobiusLfsAuthentication.build_from_json(
      JSON.generate(
        username: 'dzaporozhets',
        lfs_token: 'wsnys8Zm8Jn7zyhHTAAK',
        repository_http_path: 'http://mobius.dev/repo'
      )
    )
  end

  describe '#build_from_json' do
    it { subject.username.should == 'dzaporozhets' }
    it { subject.lfs_token.should == 'wsnys8Zm8Jn7zyhHTAAK' }
    it { subject.repository_http_path.should == 'http://mobius.dev/repo' }
  end

  describe '#authentication_payload' do
    result = '{"header":{"Authorization":"Basic ZHphcG9yb3poZXRzOndzbnlzOFptOEpuN3p5aEhUQUFL"},"href":"http://mobius.dev/repo/info/lfs/"}'

    it { subject.authentication_payload.should eq(result) }

    it 'should be a proper JSON' do
      payload = subject.authentication_payload
      json_payload = JSON.parse(payload)

      json_payload['header']['Authorization'].should eq('Basic ZHphcG9yb3poZXRzOndzbnlzOFptOEpuN3p5aEhUQUFL')
      json_payload['href'].should eq('http://mobius.dev/repo/info/lfs/')
    end
  end
end
