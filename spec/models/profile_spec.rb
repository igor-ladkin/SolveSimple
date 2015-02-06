require 'rails_helper'

RSpec.describe Profile, :type => :model do
  it { is_expected.to belong_to :user }

  describe '#display_name' do
  	let(:profile_with_full_info) { create(:profile) }
  	let(:profile_with_first_name) { create(:profile, last_name: nil, nickname: nil) }
  	let(:profile_with_last_name) { create(:profile, first_name: nil, nickname: nil) }
  	let(:profile_with_nickname) { create(:profile, last_name: nil, first_name: nil) }

  	it 'returns full name if all info present' do
  		expect(profile_with_full_info.display_name).to eq "#{profile_with_full_info.first_name} #{profile_with_full_info.last_name}"
  	end

  	it 'returns last name if there is last_name but no first_name' do
  		expect(profile_with_last_name.display_name).to eq profile_with_last_name.last_name
  	end

  	it 'returns last name if there is first_name but no last_name' do
  		expect(profile_with_first_name.display_name).to eq profile_with_first_name.first_name
  	end

  	it 'returns nickname if there is no last_name and no first_name' do
  		expect(profile_with_nickname.display_name).to eq profile_with_nickname.nickname
  	end
  end
end
