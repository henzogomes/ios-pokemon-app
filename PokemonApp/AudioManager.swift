//
//  AudioManager.swift
//  PokemonApp
//
//  Created by Henzo Marinho Ferreira Gomes on 21/01/25.
//

import AVFoundation
import OggDecoder

class AudioManager: ObservableObject {
  private var player: AVAudioPlayer?
  private let decoder = OGGDecoder()
  private var cache: [String: URL] = [:]
  
  func playCry(urlString: String) {
    guard let url = URL(string: urlString) else {
      print("Invalid URL")
      return
    }
    
    if let cachedURL = cache[urlString] {
      // If the WAV file is already cached, play it directly
      playWavFile(url: cachedURL)
      return
    }
    
    // Download the OGG file
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let self = self, let data = data, error == nil else {
        print("Error downloading audio: \(error?.localizedDescription ?? "Unknown error")")
        return
      }
      
      // Save the downloaded data to a temporary file
      let tempFileURL = self.saveToTemporaryFile(data: data)
      
      // Decode OGG to WAV
      self.decoder.decode(tempFileURL) { savedWavUrl in
        guard let savedWavUrl = savedWavUrl else {
          print("Failed to decode OGG to WAV")
          return
        }
        
        // Cache the decoded WAV file URL
        self.cache[urlString] = savedWavUrl
        
        // Play the WAV file
        DispatchQueue.main.async {
          self.playWavFile(url: savedWavUrl)
        }
      }
    }.resume()
  }
  
  private func saveToTemporaryFile(data: Data) -> URL {
    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString + ".ogg")
    
    do {
      try data.write(to: temporaryFileURL)
      return temporaryFileURL
    } catch {
      print("Error saving temporary file: \(error.localizedDescription)")
      return temporaryFileURL // Return the URL even if saving fails
    }
  }
  
  private func playWavFile(url: URL) {
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player?.prepareToPlay()
      player?.play()
    } catch {
      print("Error playing WAV file: \(error.localizedDescription)")
    }
  }
  
  // Call this method when you want to clear the cache (e.g., when memory is low)
  func clearCache() {
    for (_, url) in cache {
      try? FileManager.default.removeItem(at: url)
    }
    cache.removeAll()
  }
}
