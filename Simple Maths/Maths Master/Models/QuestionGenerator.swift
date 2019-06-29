//
//  QuestionGenerator.swift
//  Maths Master
//
//  Created by Nitish Mishra on 5/24/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//

import Foundation

class QuestionGenerator {
  
  static var gameMode: GameMode = .time
  static var difficulty: Difficulty = .easy
  static let oprations = ["+","/","*","-","+","-","/"]
  
  enum Difficulty {
    case easy
    case medium
    case hard
    case veryHard
  }
  
  enum GameMode {
    case time
    case survival
  }
  
  static func generateQuestion() -> Question {
    var leftHand = 0
    var rightHand = 0
    
    switch difficulty {
    case .easy:
      leftHand = Int.random(in: 0...10)
      rightHand = Int.random(in: 0...10)
    case .medium:
      leftHand = Int.random(in: 10...30)
      rightHand = Int.random(in: 0...30)
    case .hard:
      leftHand = Int.random(in: 10...40)
      rightHand = Int.random(in: 10...40)
    case .veryHard:
      leftHand = Int.random(in: 1...100)
      rightHand = Int.random(in: 1...200)
    }
    
    let question = Question(leftHand: leftHand, rightHand: rightHand, operation: oprations.randomElement())
    if question.validated() {
      return question
    } else {
     return generateQuestion()
    }
  }
  
  
}
