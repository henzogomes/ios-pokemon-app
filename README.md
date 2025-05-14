# Pokémon App

<img src="_docs/pokemon-app.png" alt="drawing" width="400"/>

## Overview

Pokémon App is a simple and intuitive iOS application that allows users to search and discover information about different Pokémon. Using the [PokéAPI](https://pokeapi.co/) as its data source, the app provides details such as Pokémon types, abilities, physical characteristics, and even plays their iconic cries.

## Features

- **Search by Name**: Look up any Pokémon by entering its name
- **Detailed Information**: View comprehensive details including:
  - Pokémon ID number
  - Type classification
  - Height and weight
  - Special abilities
- **Visual Display**: See the Pokémon's official sprite image
- **Interactive Audio**: Listen to the Pokémon's cry with a fun bouncing animation
- **Error Handling**: User-friendly error messages when a Pokémon can't be found

## Technical Details

### Built With
- Swift and SwiftUI for the UI components
- AVFoundation for audio playback
- OggDecoder library for handling Pokémon cry audio files
- URLSession for API communication

### API Integration
The app fetches data from the free [PokéAPI](https://pokeapi.co/), which provides comprehensive information about the Pokémon universe.

### Audio Processing
- Downloads OGG format audio files of Pokémon cries
- Converts OGG to WAV format for playback
- Implements caching for better performance

## Getting Started

### Prerequisites
- Xcode 14.0 or higher
- iOS 15.0+ target device or simulator
- Swift 5.7 or higher

### Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/henzogomes/ios-pokemon-app.git
   ```
2. Open `PokemonApp.xcodeproj` in Xcode
3. Install any required dependencies
4. Build and run the application on your simulator or device

## Usage

1. Launch the app
2. Enter a Pokémon's name in the search field
3. Tap "Get Pokémon Info" to search
4. View the returned information including sprite image
5. Tap "Play Cry" to hear the Pokémon's voice

## License

This project is distributed under the MIT License. See `LICENSE` file for more information.

## Acknowledgments

- [PokéAPI](https://pokeapi.co/) for providing the Pokémon data
- Nintendo, Game Freak, and The Pokémon Company for creating Pokémon