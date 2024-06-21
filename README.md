# Desserts 🧁

![Getting Started](./Screenshots/Dessert-Poster.jpg)

## Motivation

The Desserts app leverages the following APIs:

1. https://themealdb.com/api/json/v1/1/filter.php?c=Dessert
2. https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID

The app is designed to display a list of desserts and detailed information about each dessert to the user.

## Features

1. **iOS and iPadOS Compatibility**: Utilizes the `NavigationSplitView` API to provide seamless navigation across devices.

2. **Image Caching**: Implements caching for `AsyncImage`, minimizing network calls and improving scrolling performance in the dessert list.

3. **Automatic Data Re-fetch**: Automatically re-fetches data when the app transitions from offline to online states.

4. **Search Functionality**: Allows users to search for desserts by name within the dessert list.

5. **Light and Dark Mode Support**: Ensures a consistent and pleasing user experience in both light and dark modes.

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/bsshanky/Desserts.git
   ```
   
2. Navigate to the project directory:
    ```
    cd Desserts
    ```
    
3. Open the project in Xcode:
    ```
    open Desserts.xcodeproj
    ```
    
4. Build and run the project on your chosen simulator or device.

## Project Structure

1. `Cache`: Contains class related to caching AsyncImage.
2. `Resources`: Stores API endpoints.
3. `Modifiers`: Custom view modifiers for animations and UI enhancements.
4. `Services`: Networking and error handling services.
5. `Model`: Data models representing desserts and their details.
6. `ViewModel`: Logic for managing data and business logic.
7. `View`: SwiftUI views that compose the UI.

## API Documentation

1. Dessert List API: Fetches a list of desserts.
- Endpoint: https://themealdb.com/api/json/v1/1/filter.php?c=Dessert
- Response: JSON array of desserts.

2. Dessert Detail API: Fetches detailed information about a specific dessert.
- Endpoint: https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID
- Response: JSON object with dessert details.

## Acknowledgements

I would like to extend my sincere gratitude to the recruitment team at Fetch for providing me with this opportunity to work on this take-home assignment. It has been an invaluable learning experience.

Having primarily worked with Core Data in SwiftUI, this project was my first foray into fetching and displaying data from an API using SwiftUI. While the concepts are not entirely new to me—thanks to my experience with similar projects in UIKit—implementing them in SwiftUI has been a rewarding challenge.

I am excited about the possibility of advancing to the next stages of the recruitment process and look forward to the opportunity to contribute further.
