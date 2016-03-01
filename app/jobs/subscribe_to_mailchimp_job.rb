class SubscribeToMailchimpJob < ActiveJob::Base
  queue_as :default

  def perform(lead)
    mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    mailchimp.lists.subscribe('0e3b74fe55',
                              {"email" => lead.email})
  end
end
