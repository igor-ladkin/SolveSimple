class DailyDigestWorker
	include Sidekiq::Worker
	include Sidetiq::Schedulable

	#recurrence { daily.hour_of_day(18) }

	def perform
		User.find_each do |user|
      DailyMailer.digest(user)
    end
	end
end