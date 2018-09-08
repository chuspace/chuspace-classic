# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { create(:post, slug: 'foo-bar') }

  it { is_expected.to belong_to(:person) }

  it 'should validate uniqueness and presence of slug' do
    described_class.skip_callback(:validation, :before, :assign_slug)

    subject.slug = nil
    expect(subject).to be_invalid
    expect { create(:post, slug: 'foo-bar') }.to raise_error(
      ActiveRecord::RecordInvalid, 'Validation failed: Slug has already been taken'
    )

    described_class.set_callback(:validation, :before, :assign_slug)
  end

  it 'should update a slug from title' do
    subject.title = 'Bar Baz'
    subject.save

    expect(subject.slug).to eq('bar-baz')
  end
end
