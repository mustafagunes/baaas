//
//  TrainingViewController.swift
//  baaas
//
//  Created by Mustafa Gunes on 2.12.2023.
//

import UIKit
import AVKit

final class TrainingViewController: UIViewController {
  
  var data: [(path: String, name: String)] = [(path: "", name: "")]
  
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
    view.backgroundColor = .systemBackground
    
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}

extension TrainingViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
    
    var config = cell.defaultContentConfiguration()
    config.text = data[indexPath.row].name.video
    cell.contentConfiguration = config
    
    return cell
  }
}

extension TrainingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    showVideoPlayer(with: indexPath.row)
  }
  
  private func showVideoPlayer(with index: Int) {
    let videoURL = URL(string: data[index].path)
    guard let url = videoURL else {
      debugPrint("video not found")
      return
    }
    let player = AVPlayer(url: url)
    let vc = AVPlayerViewController()
    vc.player = player
    
    present(vc, animated: true) {
      vc.player?.play()
    }
  }
}

fileprivate extension String {
  var video: String {
    var names = components(separatedBy: "-")
    names.remove(at: 0)
    let name = names.joined(separator: " ").replacingOccurrences(of: ".MP4", with: "")
    return name.uppercased()
  }
}
