//
//  Question.swift
//  Maths Master
//
//  Created by Nitish Mishra on 5/24/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//


import Foundation

struct Question {
  
  let leftHand: Int!
  let rightHand: Int!
  let operation: String!
  
  func calculateAnswer() -> Int  {
    switch operation {
    case "+":
      return leftHand + rightHand
    case "-":
      return leftHand - rightHand
    case "*":
      return leftHand * rightHand
    case "/":
      return leftHand / rightHand
    default:
      return 0
    }
  }
  
  func validated() -> Bool {
    switch operation {
    case "-":
      return leftHand >= rightHand
    case "/":
      return leftHand.isMultiple(of: rightHand) && rightHand != 0
    default:
      return true
    }
  }
  
  func toString() -> String {
    guard let left = leftHand, let right = rightHand, let op = operation else {return ""}
    return "\(left) \(op) \(right)"
  }
  
}

