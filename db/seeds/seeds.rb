#Concierge.create(email: 'josh@mydomino.com', password: 'password', password_confirmation: 'password', name: 'Josh Morrow')
#
#tasks = [
#  {name: "Solar Power", description: "Have solar panels installed on your home. A typical homeowner can save over 20% per month with solar. Your Domino energy savings concierge will guide you through the whole process to get and compare bids, find financing, and more."},
#  {name: "Clean Power", description: "Sign up for the Clean Power Option with help from your concierge. You can power your home with renewable energy like wind and solar – even if you can’t put panels on your roof!"},
#  {name: "LED lights", description: "Upgrade from traditional incadescents to modern, warm LED bulbs. You’ll save up to $4,000 over 20 years and avoid replacing bulbs all the time."},
#  {name: "Cold Water for Clothes", description: "Wash your clothes in cold water – they’ll get just as clean, and you’ll save 75% in energy per load."},
#  {name: "Easy Power Savers", description: "Avoid power drains: adjust power settings on your electronics, and cluster your appliances – like your TV and cable box – using smart power strips."},
#  {name: "Use Large Appliances at Night", description: "Run large appliances like your washer/dryer and dishwasher at night, to take advantage of lower energy rates."},
#  {name: "Hot Water Temp", description: "Reduce your hot water heater temperature to 120° F. You can save up to $100 each year, and also avoid scalding yourself."},
#  {name: "Hypermile", description: "To improve your gas mileage and save up to $200 a year, stay within the speed limit, avoid idling, and check your tire pressure with our recommended tire gauge."},
#  {name: "Thermostat", description: "Program your current thermostat or switch to a smart thermostat – it will do the work for you, increase your comfort, and could save you up to $150 each year."}
#]
#
#tasks.each do |task|
#  Task.create(name: task[:name], description: task[:description], icon: "energy")
#end
#
#products = [
#  { url: "http://www.amazon.com/Nest-Learning-Thermostat-2nd-Generation/dp/B009GDHYPQ%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB009GDHYPQ"},
#  { url: "http://www.amazon.com/Cree-Equivalent-Filament-Design-8-pack/dp/B00Y1883VU%3Fpsc%3D1%26SubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB00Y1883VU"},
#  { url: "http://www.amazon.com/Accutire-MS-4021B-Digital-Pressure-Gauge/dp/B00080QHMM%3Fpsc%3D1%26SubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB00080QHMM"},
#  { url: "http://www.amazon.com/Cree-Equivalent-White-Filament-Design/dp/B00U0YHRMU%3Fpsc%3D1%26SubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB00U0YHRMU"},
#  { url: "http://www.amazon.com/Nest-Learning-Thermostat-3rd-Generation/dp/B0131RG6VK%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB0131RG6VK"}
#]
#
#products.each do |product|
#  Product.create(url: product[:url])
#end

# to run this file, type rake db:seed:seeds. In general, type rake db:seed:your_custom_seed_file_name


puts "Hello, Seeding records....\n"




notifications = [
  {day: "everyday", time: 19, description: "Remind me to complete daily food challenge"},
  {day: "everyday", time: 19, description: "Send me new findings about Solar products"},
  {day: "Monday", time: 19, description: "Send me new coupons about MyDomino"},
  {day: "Tuesdayday", time: 19, description: "Remind me to drink 5 cups of milk at dinner"},
  {day: "everyday", time: 19, description: "Send me new findings about wind products"},
  {day: "everyday", time: 19, description: "Send me updates about Solar plants"},
  
]


ActiveRecord::Base.transaction do

  notifications.each do |noti_task|
    Notification.find_or_create_by!(description: noti_task[:description]) do |t| 

      puts "Creating notify_task #{noti_task[:name]}\n"

      t.description = noti_task[:description]
      t.day = noti_task[:day]
      t.time = noti_task[:time]
    end
  end
end


notify_methods = [
  {name: "Email", desc: "Email notification"},
  {name: "Web Push", desc: "Web push notificaiton"},
  {name: "Text", desc: "Text notification"}
  
]


ActiveRecord::Base.transaction do

  notify_methods.each do |noti_method|
    NotifyMethod.find_or_create_by!(name: noti_method[:name]) do |t| 

      puts "Creating notify_method #{noti_method[:name]}\n"

      t.name = noti_method[:name]
      t.desc = noti_method[:desc]
    end
  end
end





