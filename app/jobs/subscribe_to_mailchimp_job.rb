class SubscribeToMailchimpJob < ActiveJob::Base
  queue_as :default

  def perform(email)
    mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    mailchimp.lists.subscribe('9ebbe8d5c1',
                              {"email" => email})
  end
end
