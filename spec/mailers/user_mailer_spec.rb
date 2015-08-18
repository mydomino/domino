require 'rails_helper'

describe UserMailer do
  
  let(:subject) { UserMailer }
  let(:lead) { FactoryGirl.create(:lead) }

  it "sends an email right now" do
    expect { subject.welcome_email(lead).deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it "sends an email later" do
    expect { subject.welcome_email(lead).deliver_later }.to enqueue_a ActionMailer::DeliveryJob
  end

end