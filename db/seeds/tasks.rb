tasks = [
  {name: "Solar Power", description: "Have solar panels installed on your home. A typical homeowner can save over 20% per month with solar. Your Domino energy savings concierge will guide you through the whole process to get and compare bids, find financing, and more."},
  {name: "Clean Power", description: "Sign up for the Clean Power Option with help from your concierge. You can power your home with renewable energy like wind and solar – even if you can’t put panels on your roof!"},
  {name: "LED lights", description: "Upgrade from traditional incadescents to modern, warm LED bulbs. You’ll save up to $4,000 over 20 years and avoid replacing bulbs all the time."},
  {name: "Cold Water for Clothes", description: "Wash your clothes in cold water – they’ll get just as clean, and you’ll save 75% in energy per load."},
  {name: "Easy Power Savers", description: "Avoid power drains: adjust power settings on your electronics, and cluster your appliances – like your TV and cable box – using smart power strips."},
  {name: "Use Large Appliances at Night", description: "Run large appliances like your washer/dryer and dishwasher at night, to take advantage of lower energy rates."},
  {name: "Hot Water Temp", description: "Reduce your hot water heater temperature to 120° F. You can save up to $100 each year, and also avoid scalding yourself."},
  {name: "Hypermile", description: "To improve your gas mileage and save up to $200 a year, stay within the speed limit, avoid idling, and check your tire pressure with our recommended tire gauge."},
  {name: "Thermostat", description: "Program your current thermostat or switch to a smart thermostat – it will do the work for you, increase your comfort, and could save you up to $150 each year."}
]

tasks.each do |task|
  Task.create(name: task[:name], description: task[:description], icon: "energy")
end
