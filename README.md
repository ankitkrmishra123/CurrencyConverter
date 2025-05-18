# currency_converter

Flutter Currency Converter
    A comprehensive currency converter application built with Flutter that allows users to convert multiple currencies simultaneously and calculate their total value in a base currency using real-time exchange rates.

Overview
    This Flutter-based Advanced Currency Converter application allows users to input amounts in multiple currencies, calculate their total value, and provide a normalized sum in a base currency using real-time exchange rates from the ExchangeRates API.


Features
    Multiple Currency Inputs: Add and remove currency input fields dynamically
    Real-time Exchange Rates: Fetch current exchange rates from ExchangeRates API
    Base Currency Selection: Change the base currency for normalization
    Currency List: View all available currencies with their codes and names
    Offline Support: Cache exchange rates for offline functionality
    Responsive UI: Adapts to different screen sizes and orientations
    Error Handling: Graceful handling of network failures and invalid inputs

Screenshots

Main Screen: Shows the currency input fields, "Add Currency" button, and the total value in the base currency
Settings Screen: Displays options to change the base currency
Currencies List Screen: Shows all available currencies with their codes and names    

Architecture
    The application follows the MVVM (Model-View-ViewModel) architecture pattern using Provider for state management:

Setup Instructions
    Prerequisites
        Flutter SDK (latest stable version)
        Dart SDK
        Android Studio or VS Code with Flutter extensions
        An API key from APILayer ExchangeRates API

Prerequisites
    Flutter SDK (latest stable version)
    Dart SDK
    Android Studio or VS Code with Flutter extensions
    An API key from APILayer ExchangeRates API


### Installation

1. Clone the repository:
2. Install dependencies: (flutter pub get)
3. Run the application: flutter run

## Dependencies

  - **provider**: ^6.0.5 - For state management
  - **http**: ^0.13.5 - For making API requests
  - **shared_preferences**: ^2.0.15 - For caching exchange rates


The application includes unit tests for the core functionality:

- Provider tests
- Currency conversion tests
- API service tests


  To run the tests: flutter test
  

 ### https://apilayer.com/marketplace/exchangerates_data-api -> reference to create api key from the marketplace