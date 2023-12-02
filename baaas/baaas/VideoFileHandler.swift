//
//  VideoFileHandler.swift
//  baaas
//
//  Created by Mustafa Gunes on 2.12.2023.
//

import Foundation

class VideoFileHandler {
  let bundle: Bundle = .main
  
  public init() {}
  
  func getAllVideos(path: String) -> [(path: String, name: String)] {
    var videos: [(path: String, name: String)] = []
    
    if let directoryURL = bundle.resourceURL?.appendingPathComponent("training-docs/private-docs/\(path)") {
      do {
        let contents = try FileManager.default.contentsOfDirectory(
          at: directoryURL,
          includingPropertiesForKeys: nil,
          options: []
        )
        
        for url in contents where url.pathExtension.lowercased() == "mp4" {
          videos.append((path: "file://" + url.path, name: url.lastPathComponent))
        }
        
        // sorted videos
        videos = videos.sorted {
          guard let number1 = Int($0.name.components(separatedBy: .decimalDigits.inverted).joined()),
                let number2 = Int($1.name.components(separatedBy: .decimalDigits.inverted).joined()) else {
            return false
          }
          return number1 < number2
        }
        
      } catch {
        print("Error: \(error)")
      }
    }
    return videos
  }
}
