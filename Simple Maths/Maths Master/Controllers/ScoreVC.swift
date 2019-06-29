//
//  ScoreVC.swift
//  Knowledge Master Quiz
//
//  Created by Nitish Mishra on 5/24/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//

import UIKit

protocol ScoreVCDelegate: class {
  func didPressHome()
  func didPressAgain()
}

class ScoreVC: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var scoreNumberLabel: UILabel!
  @IBOutlet weak var nameField: UITextField!
  
  weak var delegate: ScoreVCDelegate?
  private var namesArray = [String]()
  private var scoresArray = [Int]()
  private var highScoreIndex: Int!
  var score = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    nameField.delegate = self
    fetchLeaderboard()
    checkIfHighScore()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    guard let index = highScoreIndex else { return false }
    namesArray.insert(textField.text!, at: index)
    scoresArray.insert(score, at: index)
    textField.isHidden = true
    if namesArray.count > 5 {
      namesArray.removeLast()
      scoresArray.removeLast()
    }
    let mode = QuestionGenerator.gameMode == .time ? "time" : "survival"
    UserDefaults.standard.set(namesArray, forKey: "LeaderboardNames-\(mode)")
    UserDefaults.standard.set(scoresArray, forKey: "LeaderboardScores-\(mode)")
    return true
  }
  
  private func checkIfHighScore() {
    guard score > 0 else {
      setupScore(highScore: false)
      return
    }
    
    guard !scoresArray.isEmpty else {
      highScoreIndex = 0
      setupScore(highScore: true)
      return
    }
    
    for score in scoresArray {
      if self.score > score {
        let index = scoresArray.firstIndex(of: score)
        highScoreIndex = index
        setupScore(highScore: true)
        return
      }
    }
    
    if scoresArray.count < 5 {
      highScoreIndex = scoresArray.count
      setupScore(highScore: true)
      return
    }
    
    setupScore(highScore: false)
  }
  
  private func setupScore(highScore: Bool) {
    scoreLabel.text =  highScore ? "NEW HIGH SCORE" : "Your score is"
    scoreNumberLabel.text = "\(score)"
    nameField.isHidden = !highScore
  }

  @IBAction func goHome(_ sender: UIButton) {
    dismiss(animated: false)
    delegate?.didPressHome()
  }
  
  @IBAction func playAgain(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
    delegate?.didPressAgain()
  }
  
  private func fetchLeaderboard() {
    let mode = QuestionGenerator.gameMode == .time ? "time" : "survival"
    let namesArray1 = UserDefaults.standard.array(forKey: "LeaderboardNames-\(mode)")
    let scoresArray1 = UserDefaults.standard.array(forKey: "LeaderboardScores-\(mode)")
    if let names = namesArray1 as? [String], let scores = scoresArray1 as? [Int] {
      namesArray = names
      scoresArray = scores
    }
  }
  
}
