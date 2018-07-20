# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo, type: :model do
  let!(:user) { create(:user) }
  subject { create(:repo, slug: 'foo-bar', user: user) }

  it { should validate_presence_of(:name) }
  it { should belong_to(:user) }

  it 'should validate uniqueness and presence of slug' do
    described_class.skip_callback(:validation, :before, :assign_slug)

    subject.slug = nil
    expect(subject.save).to be_falsy
    expect { create(:repo, slug: 'foo-bar', user: user) }.to raise_error(
      ActiveRecord::RecordInvalid, 'Validation failed: Slug has already been taken'
    )

    described_class.set_callback(:validation, :before, :assign_slug)
  end

  it 'should update a slug from name' do
    subject.name = 'Bar Baz'
    subject.save

    expect(subject.slug).to eq('bar-baz')
  end
end
