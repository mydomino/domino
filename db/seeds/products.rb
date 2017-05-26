products = [
 { url: "http://www.amazon.com/Nest-Learning-Thermostat-2nd-Generation/dp/B009GDHYPQ%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB009GDHYPQ"},
 { url: "http://www.amazon.com/Cree-Equivalent-Filament-Design-8-pack/dp/B00Y1883VU%3Fpsc%3D1%26SubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB00Y1883VU"},
 { url: "http://www.amazon.com/Accutire-MS-4021B-Digital-Pressure-Gauge/dp/B00080QHMM%3Fpsc%3D1%26SubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB00080QHMM"},
 { url: "http://www.amazon.com/Cree-Equivalent-White-Filament-Design/dp/B00U0YHRMU%3Fpsc%3D1%26SubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB00U0YHRMU"},
 { url: "http://www.amazon.com/Nest-Learning-Thermostat-3rd-Generation/dp/B0131RG6VK%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Ddomino09d-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB0131RG6VK"}
]

products.each do |product|
 Product.create(url: product[:url])
end
