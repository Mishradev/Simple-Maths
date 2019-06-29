//
//  QuizVC.swift
//  Maths Master
//
//  Created by Nitish Mishra on 5/24/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//


import UIKit

class QuizVC: CustomTransitionViewController {

  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet var buttons: [UIButton]!
  
  lazy private var slideInTransitioningDelegate = SlideInPresentationManager()
  
  private var timerView: UIView!
  private var questionCounter = 0 {
    didSet {
      if QuestionGenerator.gameMode == .time && questionCounter <= 40 {
        navigationItem.title = " \(questionCounter) of 40"
      }
    }
  }
  private var currentQuestion: Question!
  private var score = 0 {
    didSet {
      if QuestionGenerator.gameMode == .survival {
        navigationItem.title = "Score: \(score)"
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .always
    setupViews()
    setupGameMode()
    generateQuestion()
  }
  
  private func setupViews() {
    questionLabel.layer.borderColor = #colorLiteral(red: 0.7651568651, green: 0.8784276247, blue: 0.8978976607, alpha: 1)
    questionLabel.layer.borderWidth = 2
    questionLabel.layer.cornerRadius = 8
    
    buttons.forEach { (btn) in
      btn.layer.cornerRadius = btn.frame.width / 2
    }
  }
  
  private func setupGameMode() {
    switch QuestionGenerator.gameMode {
    case .time:
      createTimer()
      navigationItem.title = " 1 of 40"
    case .survival:
      navigationItem.title = " Score: 0"
    }
  }
  
  private func createTimer() {
    let y = questionLabel.frame.minY - 40
    timerView = UIView(frame: CGRect(x: 0, y: y, width: 0, height: 10))
    timerView.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
    timerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(timerView)
  }
  
  private func resetTimer() {
    guard QuestionGenerator.gameMode == .time else {return}
    guard questionCounter <= 40 else {
      timerView.layer.removeAllAnimations()
      performSegue(withIdentifier: "showScore", sender: nil)
      return
    }
    timerView.layer.removeAllAnimations()
    let y = questionLabel.frame.minY - 40
    timerView.frame = CGRect(x: 0, y: y, width: 0, height: 10)

    UIView.animate(withDuration: 10, delay: 0, options: .curveLinear, animations: {
      self.timerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 10)
    }, completion: { [weak self] completed in
      if completed {
        self?.checkAnswer()
      }
    })
    
  }
  
  private func loseSurvivalMode() {
    guard QuestionGenerator.gameMode == .survival else {return}
    performSegue(withIdentifier: "showScore", sender: nil)
  }
  
  private func generateQuestion() {
    switch questionCounter {
    case 0...7:
      QuestionGenerator.difficulty = .easy
    case 8...20:
      QuestionGenerator.difficulty = .medium
    case 21...30:
      QuestionGenerator.difficulty = .hard
    case 31...:
      QuestionGenerator.difficulty = .veryHard
    default:
      break
    }
    let question = QuestionGenerator.generateQuestion()
    currentQuestion = question
    questionCounter += 1
    questionLabel.text = question.toString()
    answerLabel.text = "__"
    resetTimer()
  }
  
  private func checkAnswer() {
    if answerLabel.text == "\(currentQuestion.calculateAnswer())" {
      score += 1
      generateQuestion()
      return
    } else {
      loseSurvivalMode()
    }
    
    if QuestionGenerator.gameMode == .time {
      generateQuestion()
    }
  }
  
  private func flashScore(correct: Bool) {
    
  }
  
  @IBAction func numberPressed(_ sender: UIButton) {
    if answerLabel.text != "__" {
      answerLabel.text?.append("\(sender.tag)")
    } else {
      answerLabel.text = "\(sender.tag)"
    }
  }

  @IBAction func backPressed(_ sender: UIButton) {
    guard var answer = answerLabel.text, !answer.isEmpty, answer != "__" else {return}
    answer.removeLast()
    answerLabel.text = !answer.isEmpty ? answer : "__"
  }
  
  @IBAction func enterPressed(_ sender: UIButton) {
    checkAnswer()
  }
  
  private func startOver() {
    score = 0
    questionCounter = 0
    generateQuestion()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let dest = segue.destination as? ScoreVC {
      slideInTransitioningDelegate.direction = .bottom
      slideInTransitioningDelegate.height = view.frame.height * 0.7
      dest.transitioningDelegate = slideInTransitioningDelegate
      dest.modalPresentationStyle = .custom
      dest.score = score
      dest.delegate = self
    }
  }
  
}

extension QuizVC: ScoreVCDelegate {
  
  func didPressHome() {
    navigationController?.popViewController(animated: false)
  }
  
  func didPressAgain() {
    startOver()
  }
  
}
