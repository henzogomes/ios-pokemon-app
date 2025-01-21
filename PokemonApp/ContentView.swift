import SwiftUI
import AVFoundation

struct ContentView: View {
  @State private var searchTerm: String = ""
  @State private var errorMessage: String = ""
  @State private var pokemonName: String? = nil
  @State private var pokemonID: Int?
  @State private var pokemonType: String = ""
  @State private var pokemonImageURL: String = ""
  @State private var isLoading: Bool = false
  @State private var height: Int = 0
  @State private var weight: Int = 0
  @State private var abilities: [String] = []
  @State private var pokemonCryURL: String? = nil
  @StateObject private var audioManager = AudioManager()
  @State private var isPlaying = false
  @State private var bounceEffect: CGFloat = 1.0
  
  init() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Failed to set audio session category: \(error)")
    }
  }

  var body: some View {
    VStack(spacing: 16) {
      TextField("Enter Pokémon name", text: $searchTerm)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      Button(action: fetchPokemon) {
        Text("Get Pokémon Info")
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      
      if isLoading {
        ProgressView("Loading...").padding()
      } else {
        displayErrorMessage()
        displayPokemonInfo()
      }
    }
    .padding()
  }

  private func fetchPokemon() {
    guard validateInput(searchTerm) else {
      errorMessage = "Please enter a valid Pokémon name (letters only)."
      return
    }
    
    resetPokemonData()
    isLoading = true
    
    let urlString = "https://pokeapi.co/api/v2/pokemon/\(searchTerm.lowercased())"
    
    guard let url = URL(string: urlString) else {
      isLoading = false
      errorMessage = "Invalid URL. Please try again."
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      DispatchQueue.main.async {
        isLoading = false
      }
      
      if let error = error {
        print("Error fetching data: \(error)")
        DispatchQueue.main.async {
          self.errorMessage = "Error fetching data. Please try again."
        }
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        DispatchQueue.main.async {
          self.errorMessage = "Pokémon not found. Please try another name."
        }
        return
      }
      
      guard let data = data else {
        DispatchQueue.main.async {
          self.errorMessage = "No data returned. Please try again."
        }
        return
      }
      
      do {
        let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
        DispatchQueue.main.async {
          self.pokemonName = pokemon.name.capitalized
          self.pokemonID = pokemon.id
          self.pokemonType = pokemon.types.first?.type.name ?? "Unknown"
          self.pokemonImageURL = pokemon.sprites.front_default
          self.abilities = pokemon.abilities.map { $0.ability.name }
          self.height = pokemon.height
          self.weight = pokemon.weight
          self.pokemonCryURL = pokemon.cries.legacy
          self.errorMessage = ""
          print("Cry URL: \(self.pokemonCryURL ?? "No URL")")
        }
      } catch {
        print("Error decoding data: \(error)")
        DispatchQueue.main.async {
          self.errorMessage = "Error decoding data. Please try again later."
        }
      }
    }
    
    task.resume()
  }

  private func validateInput(_ input: String) -> Bool {
    let characterSet = CharacterSet.letters
    return input.rangeOfCharacter(from: characterSet.inverted) == nil
  }

  private func resetPokemonData() {
    pokemonID = nil
    pokemonType = ""
    pokemonImageURL = ""
    errorMessage = ""
    height = 0
    weight = 0
    abilities = []
    pokemonName = nil
    pokemonCryURL = nil
  }

  private func displayErrorMessage() -> some View {
    if !errorMessage.isEmpty {
      return AnyView(Text(errorMessage).foregroundColor(.red))
    }
    return AnyView(EmptyView())
  }

  private func displayPokemonInfo() -> some View {
    Group {
      if let name = pokemonName {
        Text("Name: \(name)")
          .font(.headline)
        
        if let id = pokemonID {
          Text("# \(id)")
        }
      }
      
      if !pokemonType.isEmpty {
        Text("Type: \(pokemonType)")
      }
      
      if pokemonID != nil {
        Text("Height: \(formattedHeight(from: height))")
        Text("Weight: \(formattedWeight(from: weight))")
      }
      
      if !abilities.isEmpty {
        Text("Abilities: \(abilities.joined(separator: ", "))")
      }
      
      if !pokemonImageURL.isEmpty {
        AsyncImage(url: URL(string: pokemonImageURL)) { image in
          image
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
            .scaleEffect(bounceEffect)
            .animation(
                isPlaying ?
                    Animation.easeInOut(duration: 0.2)
                    .repeatForever(autoreverses: true) :
                    .default,
                value: bounceEffect
            )
        } placeholder: {
          ProgressView()
        }
      }
      
      if let cryURL = pokemonCryURL {
        Button(action: {
          playCry(urlString: cryURL)
        }) {
          Text("Play Cry")
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
      }
    }
  }

  private func playCry(urlString: String) {
    print("Attempting to play cry from URL: \(urlString)")
    isPlaying = true
    bounceEffect = 1.2
    audioManager.playCry(urlString: urlString)
    
    // Stop the animation after 1 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        isPlaying = false
        bounceEffect = 1.0 // Reset the bouncing effect
    }
  }

  private func formattedHeight(from height: Int) -> String {
    if height < 100 {
      return "\(height) cm"
    } else {
      let meters = Double(height) / 10.0
      return String(format: "%.1f m", meters)
    }
  }

  private func formattedWeight(from weight: Int) -> String {
    if weight < 10 {
      return "\(weight * 10) grams"
    } else {
      let kilograms = Double(weight) / 10.0
      return String(format: "%.1f kg", kilograms)
    }
  }
}

#Preview {
  ContentView()
}
