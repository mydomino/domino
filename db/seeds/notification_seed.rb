# to run this file, type rake db:seed:notification_seed. In general, type rake db:seed:your_custom_seed_file_name


puts "Hello, Seeding records....\n"

#NotificationUser.destroy_all
#NotifyMethod.destroy_all
#Notification.destroy_all



notifications = [
  { description: "Remind me to complete daily food challenge", name: Notification::FAT_NOTIFICATION },
  { description: "Send me new findings about Solar products", name: "TEST_STR_1" },
  { description: "Send me new coupons about MyDomino", name: "TEST_STR_2" },
  { description: "Remind me to drink 5 cups of milk at dinner", name: "TEST_STR_3" },
  { description: "Send me new findings about wind products", name: "TEST_STR_4" },
  { description: "Send me updates about Solar plants", name: "TEST_STR_5" },
  
]


ActiveRecord::Base.transaction do

  notifications.each do |noti_task|
    Notification.find_or_create_by!(name: noti_task[:name]) do |t| 

      puts "Creating notify_task #{noti_task[:name]}\n"

      t.description = noti_task[:description]
      t.name = noti_task[:name]
    end
  end
end


# notify_methods = [
#   {name: "Email", desc: "Email notification"},
#   {name: "Web Push", desc: "Web push notificaiton"},
#   {name: "Text", desc: "Text notification"}
#   
# ]

# Associate all notifications with a default method
puts "Associating default send method to notifications..."
Notification.find_each do |n|

  if n.notify_methods.where(["name = ?", "Email"]).size == 0

    puts "Creating method email for #{n.description}..."
    method = NotifyMethod.create!(name: "Email", desc: "Email notification")
    n.notify_methods << method
  
    n.save!
  end
end