#  Features
•     Using RevolutApi to fetch rates for currencies
•     All the rates are displayed in a tableview. Top row of the table signifies the base currency.
•     Base currency can be changed by tapping any row of the tableview. Tapped row becomes the base currency and              rates are fetched based on new base currency.

# Architecture Used 
MVVM-C - Model View ViewModel with Coordinator

# Requirements
•    iOS 11.4+
•    Xcode 10.1

# Dependencies
## CocoaPods
platform :ios, '12.1'

pod 'Alamofire'
pod 'Promise'

# Sources
## For Mocked JSON to get Currency Name 
https://api.ratesexchange.eu/client/latestdetails?apiKey=a2e94da6-bc76-4a90-94fa-1368ad0c0421

## For Flags
https://github.com/Worldremit/flags


