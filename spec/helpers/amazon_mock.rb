WebMock.stub_request(:get, /http:\/\/webservices.amazon.com\/onca\/xml\?AWSAccessKeyId=.*&AssociateTag=.*&ItemId=.*&Operation=ItemLookup&ResponseGroup=Images,Offers,Small&Service=AWSECommerceService&Signature=.*=&SignatureMethod=.*&SignatureVersion=2&Timestamp=.*&Version=.*/).
         to_return(:status => 200, :body => "<?xml version=\"1.0\" ?><ItemLookupResponse xmlns=\"http://webservices.amazon.com/AWSECommerceService/2013-08-01\"><OperationRequest><HTTPHeaders><Header Name=\"UserAgent\" Value=\"Jeff/1.5.0 (Language=Ruby; Joshuas-MacBook-Pro.local)\"></Header></HTTPHeaders><RequestId>8a50f6da-5757-4fa3-9718-9fb5d295d891</RequestId><Arguments><Argument Name=\"AWSAccessKeyId\" Value=\"AKIAJQZCTRPP2KFB6YZA\"></Argument><Argument Name=\"AssociateTag\" Value=\"tag\"></Argument><Argument Name=\"ItemId\" Value=\"B009GDHYPQ\"></Argument><Argument Name=\"Operation\" Value=\"ItemLookup\"></Argument><Argument Name=\"ResponseGroup\" Value=\"Images,Offers,Small\"></Argument><Argument Name=\"Service\" Value=\"AWSECommerceService\"></Argument><Argument Name=\"SignatureMethod\" Value=\"HmacSHA256\"></Argument><Argument Name=\"SignatureVersion\" Value=\"2\"></Argument><Argument Name=\"Timestamp\" Value=\"2015-08-26T21:35:11Z\"></Argument><Argument Name=\"Version\" Value=\"2013-08-01\"></Argument><Argument Name=\"Signature\" Value=\"YNjOPj6ipEcso7aW58klBQFTC/dRd9I0FrqvEi2PYxs=\"></Argument></Arguments><RequestProcessingTime>0.0185060000000000</RequestProcessingTime></OperationRequest><Items><Request><IsValid>True</IsValid><ItemLookupRequest><IdType>ASIN</IdType><ItemId>B009GDHYPQ</ItemId><ResponseGroup>Images</ResponseGroup><ResponseGroup>Offers</ResponseGroup><ResponseGroup>Small</ResponseGroup><VariationPage>All</VariationPage></ItemLookupRequest></Request><Item><ASIN>B009GDHYPQ</ASIN><DetailPageURL>http://www.amazon.com/Nest-Learning-Thermostat-2nd-Generation/dp/B009GDHYPQ%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Dtag%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB009GDHYPQ</DetailPageURL><ItemLinks><ItemLink><Description>Technical Details</Description><URL>http://www.amazon.com/Nest-Learning-Thermostat-2nd-Generation/dp/tech-data/B009GDHYPQ%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Dtag%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB009GDHYPQ</URL></ItemLink><ItemLink><Description>Add To Baby Registry</Description><URL>http://www.amazon.com/gp/registry/baby/add-item.html%3Fasin.0%3DB009GDHYPQ%26SubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Dtag%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB009GDHYPQ</URL></ItemLink><ItemLink><Description>Add To Wedding Registry</Description><URL>http://www.amazon.com/gp/registry/wedding/add-item.html%3Fasin.0%3DB009GDHYPQ%26SubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Dtag%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB009GDHYPQ</URL></ItemLink><ItemLink><Description>Add To Wishlist</Description><URL>http://www.amazon.com/gp/registry/wishlist/add-item.html%3Fasin.0%3DB009GDHYPQ%26SubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Dtag%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB009GDHYPQ</URL></ItemLink><ItemLink><Description>Tell A Friend</Description><URL>http://www.amazon.com/gp/pdp/taf/B009GDHYPQ%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Dtag%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB009GDHYPQ</URL></ItemLink><ItemLink><Description>All Customer Reviews</Description><URL>http://www.amazon.com/review/product/B009GDHYPQ%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Dtag%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB009GDHYPQ</URL></ItemLink><ItemLink><Description>All Offers</Description><URL>http://www.amazon.com/gp/offer-listing/B009GDHYPQ%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Dtag%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB009GDHYPQ</URL></ItemLink></ItemLinks><SmallImage><URL>http://ecx.images-amazon.com/images/I/319N9SzWOeL._SL75_.jpg</URL><Height Units=\"pixels\">69</Height><Width Units=\"pixels\">75</Width></SmallImage><MediumImage><URL>http://ecx.images-amazon.com/images/I/319N9SzWOeL._SL160_.jpg</URL><Height Units=\"pixels\">148</Height><Width Units=\"pixels\">160</Width></MediumImage><LargeImage><URL>http://ecx.images-amazon.com/images/I/319N9SzWOeL.jpg</URL><Height Units=\"pixels\">462</Height><Width Units=\"pixels\">500</Width></LargeImage><ImageSets><ImageSet Category=\"variant\"><SwatchImage><URL>http://ecx.images-amazon.com/images/I/41YyVn%2B2b9L._SL30_.jpg</URL><Height Units=\"pixels\">29</Height><Width Units=\"pixels\">30</Width></SwatchImage><SmallImage><URL>http://ecx.images-amazon.com/images/I/41YyVn%2B2b9L._SL75_.jpg</URL><Height Units=\"pixels\">72</Height><Width Units=\"pixels\">75</Width></SmallImage><ThumbnailImage><URL>http://ecx.images-amazon.com/images/I/41YyVn%2B2b9L._SL75_.jpg</URL><Height Units=\"pixels\">72</Height><Width Units=\"pixels\">75</Width></ThumbnailImage><TinyImage><URL>http://ecx.images-amazon.com/images/I/41YyVn%2B2b9L._SL110_.jpg</URL><Height Units=\"pixels\">105</Height><Width Units=\"pixels\">110</Width></TinyImage><MediumImage><URL>http://ecx.images-amazon.com/images/I/41YyVn%2B2b9L._SL160_.jpg</URL><Height Units=\"pixels\">153</Height><Width Units=\"pixels\">160</Width></MediumImage><LargeImage><URL>http://ecx.images-amazon.com/images/I/41YyVn%2B2b9L.jpg</URL><Height Units=\"pixels\">479</Height><Width Units=\"pixels\">500</Width></LargeImage><HiResImage><URL>http://ecx.images-amazon.com/images/I/61UMyVRmlPL.jpg</URL><Height Units=\"pixels\">1040</Height><Width Units=\"pixels\">1086</Width></HiResImage></ImageSet><ImageSet Category=\"variant\"><SwatchImage><URL>http://ecx.images-amazon.com/images/I/31z7QRYCpbL._SL30_.jpg</URL><Height Units=\"pixels\">21</Height><Width Units=\"pixels\">30</Width></SwatchImage><SmallImage><URL>http://ecx.images-amazon.com/images/I/31z7QRYCpbL._SL75_.jpg</URL><Height Units=\"pixels\">52</Height><Width Units=\"pixels\">75</Width></SmallImage><ThumbnailImage><URL>http://ecx.images-amazon.com/images/I/31z7QRYCpbL._SL75_.jpg</URL><Height Units=\"pixels\">52</Height><Width Units=\"pixels\">75</Width></ThumbnailImage><TinyImage><URL>http://ecx.images-amazon.com/images/I/31z7QRYCpbL._SL110_.jpg</URL><Height Units=\"pixels\">77</Height><Width Units=\"pixels\">110</Width></TinyImage><MediumImage><URL>http://ecx.images-amazon.com/images/I/31z7QRYCpbL._SL160_.jpg</URL><Height Units=\"pixels\">112</Height><Width Units=\"pixels\">160</Width></MediumImage><LargeImage><URL>http://ecx.images-amazon.com/images/I/31z7QRYCpbL.jpg</URL><Height Units=\"pixels\">349</Height><Width Units=\"pixels\">500</Width></LargeImage><HiResImage><URL>http://ecx.images-amazon.com/images/I/61CM0qLrolL.jpg</URL><Height Units=\"pixels\">1239</Height><Width Units=\"pixels\">1777</Width></HiResImage></ImageSet><ImageSet Category=\"variant\"><SwatchImage><URL>http://ecx.images-amazon.com/images/I/311MByuVqCL._SL30_.jpg</URL><Height Units=\"pixels\">24</Height><Width Units=\"pixels\">30</Width></SwatchImage><SmallImage><URL>http://ecx.images-amazon.com/images/I/311MByuVqCL._SL75_.jpg</URL><Height Units=\"pixels\">59</Height><Width Units=\"pixels\">75</Width></SmallImage><ThumbnailImage><URL>http://ecx.images-amazon.com/images/I/311MByuVqCL._SL75_.jpg</URL><Height Units=\"pixels\">59</Height><Width Units=\"pixels\">75</Width></ThumbnailImage><TinyImage><URL>http://ecx.images-amazon.com/images/I/311MByuVqCL._SL110_.jpg</URL><Height Units=\"pixels\">86</Height><Width Units=\"pixels\">110</Width></TinyImage><MediumImage><URL>http://ecx.images-amazon.com/images/I/311MByuVqCL._SL160_.jpg</URL><Height Units=\"pixels\">126</Height><Width Units=\"pixels\">160</Width></MediumImage><LargeImage><URL>http://ecx.images-amazon.com/images/I/311MByuVqCL.jpg</URL><Height Units=\"pixels\">393</Height><Width Units=\"pixels\">500</Width></LargeImage><HiResImage><URL>http://ecx.images-amazon.com/images/I/71Roed1CfJL.jpg</URL><Height Units=\"pixels\">2011</Height><Width Units=\"pixels\">2560</Width></HiResImage></ImageSet><ImageSet Category=\"variant\"><SwatchImage><URL>http://ecx.images-amazon.com/images/I/51jx-lZpdPL._SL30_.jpg</URL><Height Units=\"pixels\">20</Height><Width Units=\"pixels\">30</Width></SwatchImage><SmallImage><URL>http://ecx.images-amazon.com/images/I/51jx-lZpdPL._SL75_.jpg</URL><Height Units=\"pixels\">50</Height><Width Units=\"pixels\">75</Width></SmallImage><ThumbnailImage><URL>http://ecx.images-amazon.com/images/I/51jx-lZpdPL._SL75_.jpg</URL><Height Units=\"pixels\">50</Height><Width Units=\"pixels\">75</Width></ThumbnailImage><TinyImage><URL>http://ecx.images-amazon.com/images/I/51jx-lZpdPL._SL110_.jpg</URL><Height Units=\"pixels\">73</Height><Width Units=\"pixels\">110</Width></TinyImage><MediumImage><URL>http://ecx.images-amazon.com/images/I/51jx-lZpdPL._SL160_.jpg</URL><Height Units=\"pixels\">107</Height><Width Units=\"pixels\">160</Width></MediumImage><LargeImage><URL>http://ecx.images-amazon.com/images/I/51jx-lZpdPL.jpg</URL><Height Units=\"pixels\">333</Height><Width Units=\"pixels\">500</Width></LargeImage><HiResImage><URL>http://ecx.images-amazon.com/images/I/91DjaOx87WL.jpg</URL><Height Units=\"pixels\">1707</Height><Width Units=\"pixels\">2560</Width></HiResImage></ImageSet><ImageSet Category=\"variant\"><SwatchImage><URL>http://ecx.images-amazon.com/images/I/41pHOrHVEGL._SL30_.jpg</URL><Height Units=\"pixels\">20</Height><Width Units=\"pixels\">30</Width></SwatchImage><SmallImage><URL>http://ecx.images-amazon.com/images/I/41pHOrHVEGL._SL75_.jpg</URL><Height Units=\"pixels\">50</Height><Width Units=\"pixels\">75</Width></SmallImage><ThumbnailImage><URL>http://ecx.images-amazon.com/images/I/41pHOrHVEGL._SL75_.jpg</URL><Height Units=\"pixels\">50</Height><Width Units=\"pixels\">75</Width></ThumbnailImage><TinyImage><URL>http://ecx.images-amazon.com/images/I/41pHOrHVEGL._SL110_.jpg</URL><Height Units=\"pixels\">73</Height><Width Units=\"pixels\">110</Width></TinyImage><MediumImage><URL>http://ecx.images-amazon.com/images/I/41pHOrHVEGL._SL160_.jpg</URL><Height Units=\"pixels\">107</Height><Width Units=\"pixels\">160</Width></MediumImage><LargeImage><URL>http://ecx.images-amazon.com/images/I/41pHOrHVEGL.jpg</URL><Height Units=\"pixels\">333</Height><Width Units=\"pixels\">500</Width></LargeImage><HiResImage><URL>http://ecx.images-amazon.com/images/I/81bHi2LPz5L.jpg</URL><Height Units=\"pixels\">1707</Height><Width Units=\"pixels\">2560</Width></HiResImage></ImageSet><ImageSet Category=\"primary\"><SwatchImage><URL>http://ecx.images-amazon.com/images/I/319N9SzWOeL._SL30_.jpg</URL><Height Units=\"pixels\">28</Height><Width Units=\"pixels\">30</Width></SwatchImage><SmallImage><URL>http://ecx.images-amazon.com/images/I/319N9SzWOeL._SL75_.jpg</URL><Height Units=\"pixels\">69</Height><Width Units=\"pixels\">75</Width></SmallImage><ThumbnailImage><URL>http://ecx.images-amazon.com/images/I/319N9SzWOeL._SL75_.jpg</URL><Height Units=\"pixels\">69</Height><Width Units=\"pixels\">75</Width></ThumbnailImage><TinyImage><URL>http://ecx.images-amazon.com/images/I/319N9SzWOeL._SL110_.jpg</URL><Height Units=\"pixels\">102</Height><Width Units=\"pixels\">110</Width></TinyImage><MediumImage><URL>http://ecx.images-amazon.com/images/I/319N9SzWOeL._SL160_.jpg</URL><Height Units=\"pixels\">148</Height><Width Units=\"pixels\">160</Width></MediumImage><LargeImage><URL>http://ecx.images-amazon.com/images/I/319N9SzWOeL.jpg</URL><Height Units=\"pixels\">462</Height><Width Units=\"pixels\">500</Width></LargeImage><HiResImage><URL>http://ecx.images-amazon.com/images/I/71iLXQEWBOL.jpg</URL><Height Units=\"pixels\">2365</Height><Width Units=\"pixels\">2560</Width></HiResImage></ImageSet></ImageSets><ItemAttributes><Manufacturer>Nest Labs</Manufacturer><ProductGroup>Home Improvement</ProductGroup><Title>Nest Learning Thermostat, 2nd Generation</Title></ItemAttributes><OfferSummary><LowestNewPrice><Amount>20949</Amount><CurrencyCode>USD</CurrencyCode><FormattedPrice>$209.49</FormattedPrice></LowestNewPrice><LowestUsedPrice><Amount>19499</Amount><CurrencyCode>USD</CurrencyCode><FormattedPrice>$194.99</FormattedPrice></LowestUsedPrice><TotalNew>50</TotalNew><TotalUsed>11</TotalUsed><TotalCollectible>0</TotalCollectible><TotalRefurbished>0</TotalRefurbished></OfferSummary><Offers><TotalOffers>1</TotalOffers><TotalOfferPages>1</TotalOfferPages><MoreOffersUrl>http://www.amazon.com/gp/offer-listing/B009GDHYPQ%3FSubscriptionId%3DAKIAJQZCTRPP2KFB6YZA%26tag%3Dtag%26linkCode%3Dxm2%26camp%3D2025%26creative%3D386001%26creativeASIN%3DB009GDHYPQ</MoreOffersUrl><Offer><OfferAttributes><Condition>New</Condition></OfferAttributes><OfferListing><OfferListingId>XSj%2BOPsmmHXyVDvaH6Tqgplctsro6zVM%2BzDQwvb8%2FgER1ZQp4SNBBfy5p144DwRGPJOt1DgI1DR6C0Ty1pR3jt%2BEK%2FWYYcSPqMxr9XrMxaemTYheMmSnpA%3D%3D</OfferListingId><Price><Amount>24900</Amount><CurrencyCode>USD</CurrencyCode><FormattedPrice>$249.00</FormattedPrice></Price><Availability>Usually ships in 24 hours</Availability><AvailabilityAttributes><AvailabilityType>now</AvailabilityType><MinimumHours>0</MinimumHours><MaximumHours>0</MaximumHours></AvailabilityAttributes><IsEligibleForSuperSaverShipping>1</IsEligibleForSuperSaverShipping><IsEligibleForPrime>1</IsEligibleForPrime></OfferListing></Offer></Offers></Item></Items></ItemLookupResponse>", :headers => {})