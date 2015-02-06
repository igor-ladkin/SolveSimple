require "rails_helper"

RSpec.describe DailyMailer, :type => :mailer do
  let(:user) { create(:user) }

  describe '#digest' do
  	let!(:questions) { create_list(:question, 2) }
  	let(:mail) { DailyMailer.digest(user) }

  	it 'renders the subject' do
  		expect(mail.subject).to eql('Latest questions of SolveSimple')
  	end

  	it 'renders the receiver email' do
  	  expect(mail.to).to eql([user.email])
  	end

  	it 'renders the sender email' do
      expect(mail.from).to eql(["solve.simple.app@gmail.com"])
    end

  	it 'assigns @questions array' do
      expect(mail.body.encoded).to match("/questions/#{questions[0].id}")
      expect(mail.body.encoded).to match("/questions/#{questions[1].id}")
    end
  end
end
