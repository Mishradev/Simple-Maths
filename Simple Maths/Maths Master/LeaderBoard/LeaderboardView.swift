//
//  LeaderboardView.swift
//  Knowledge Master Quiz
//
//  Created by Nitish Mishra on 5/24/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//


import UIKit

class LeaderboardView: UIView {

  @IBOutlet var nameLabels: [UILabel]!
  @IBOutlet var scoreLabels: [UILabel]!
  @IBOutlet weak var segments: UISegmentedControl!
  
  var namesArray = [String]()
  var scoresArray = [Int]()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    fetchLeaderboard()
  }
  
  @IBAction func didSelectMode(_ sender: UISegmentedControl) {
    fetchLeaderboard()
  }
  
  func fetchLeaderboard() {
    let mode = segments.selectedSegmentIndex == 0 ? "survival" : "time"
    let namesArray1 = UserDefaults.standard.array(forKey: "LeaderboardNames-\(mode)")
    let scoresArray1 = UserDefaults.standard.array(forKey: "LeaderboardScores-\(mode)")
    namesArray = []
    scoresArray = []
    
    if let names = namesArray1 as? [String], let scores = scoresArray1 as? [Int] {
      namesArray = names
      scoresArray = scores
    }
    displayScores()
  }
  
  private func displayScores() {
    guard namesArray.count == scoresArray.count else {return}

    for i in 0..<nameLabels.count {
      if i < namesArray.count {
        nameLabels[i].text = "\(i + 1). \(namesArray[i])"
        scoreLabels[i].text = "\(scoresArray[i])"
        nameLabels[i].alpha = 1
        scoreLabels[i].alpha = 1
      } else {
        nameLabels[i].alpha = 0
        scoreLabels[i].alpha = 0
      }
    }
  }
  
}
