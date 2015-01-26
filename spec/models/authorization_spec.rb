require 'rails_helper'

RSpec.describe Authorization, :type => :model do
  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }
end
