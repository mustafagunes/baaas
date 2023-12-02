//
//  ViewController.swift
//  baaas
//
//  Created by Mustafa Gunes on 2.12.2023.
//

import UIKit
import AVFAudio
import AVFoundation

final class BaaasHomeViewController: UIViewController {
  
  enum Sections: String, CaseIterable {
    case training = "Training"
    case entertainment = "Entertainment"
    
    var screen: [Screen] {
      switch self {
      case .training:
        return [.day1, .day2, .offDay, .day3, .day4]
      case .entertainment:
        return [.fetchMotivation]
      }
    }
  }
  
  enum Screen: String, CaseIterable {
    case day1 = "1. Antrenman (Göğüs & Sırt)"
    case day2 = "2. Antrenman (Biceps & Triceps)"
    case offDay = "Karın Egzersizleri"
    case day3 = "3. Antrenman (Omuz & Bacak)"
    case day4 = "4. Antrenman (Göğüs & Sırt)"
    case fetchMotivation = "Bir motivasyon çek!"
  }
  
  let sections = Sections.allCases
  let screens = Screen.allCases
  let videoHandler = VideoFileHandler()
  var player: AVAudioPlayer?
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLayout()
  }
  
  private func setLayout() {
    navigationItem.title = "Baaas"
    
    view.backgroundColor = .systemBackground
    
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    playSound()
  }
  
  
  func playSound() {
    guard let url = Bundle.main.url(forResource: "training-docs/public-docs/bas", withExtension: "mp3")
    else {
      return
    }
    
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      
      if let player {
        player.play()
      }
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      playSound()
    }
  }
}

extension BaaasHomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].rawValue
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    sections[section].screen.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    
    var config = cell.defaultContentConfiguration()
    config.text = sections[indexPath.section].screen[indexPath.row].rawValue.uppercased()
    cell.contentConfiguration = config
    
    return cell
  }
}

extension BaaasHomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch sections[indexPath.section].screen[indexPath.row] {
    case .day1, .day2, .day3, .day4, .offDay:
      var screen = "\(screens[indexPath.row])"
      if screen == "day4" {
        screen = "day1"
      }
      let videoData = videoHandler.getAllVideos(path: screen)
      let trainingViewController = TrainingViewController()
      trainingViewController.data = videoData
      trainingViewController.title = sections[indexPath.section].screen[indexPath.row].rawValue.uppercased()
      navigationController?.pushViewController(trainingViewController, animated: true)
    case .fetchMotivation: 
      playSound()
    }
  }
}
