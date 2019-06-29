//
//  MainVC.swift
//  Maths Master
//
//  Created by Nitish Mishra on 5/24/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//


import UIKit

class MainVC: CustomTransitionViewController, ATTransitionButtonDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    setupButtons()
  }

  private func setupButtons() {
    
    let smallY = view.frame.minY + 180
    let width = (view.frame.width * 0.7)
    let smallX = view.frame.midX - ( width / 2 )
    
    let extendedFrame = CGRect(x: view.frame.minX + 10, y: 10, width: view.frame.width - 20, height: view.frame.height - 200)
    
    let survivalBtn = createTransitionButton(frame: CGRect(x: smallX, y: smallY, width: width, height: 70),
                                            title: "Survival Mode")
    survivalBtn.tag = 1
    let timeBtn = createTransitionButton(frame: CGRect(x: smallX, y: smallY + 100, width: width, height: 70),
                                            title: "Time Mode")
    timeBtn.tag = 2
    
    let leaderboardView: LeaderboardView = .fromNib()
    let leaderboardBtn = createExpandableButton(frame: CGRect(x: smallX, y: smallY + 200, width: width, height: 70),
                                                expandedFrame: extendedFrame,
                                                innerView: leaderboardView,
                                                title: "Leaderboard")
    
    view.addSubview(survivalBtn)
    view.addSubview(timeBtn)
    view.addSubview(leaderboardBtn)
  }
  
  private func createExpandableButton(frame: CGRect, expandedFrame: CGRect, innerView: UIView, title: String) -> ATExpandableButton {
    let newButton = ATExpandableButton(frame: frame, expandedFrame: expandedFrame, innerView: innerView, title: title)
    newButton.iconTint = #colorLiteral(red: 0.7651568651, green: 0.8784276247, blue: 0.8978976607, alpha: 1)
    newButton.titleColor = #colorLiteral(red: 0.7651568651, green: 0.8784276247, blue: 0.8978976607, alpha: 1)
    newButton.backGroundColor = #colorLiteral(red: 0.1546225548, green: 0.266300261, blue: 0.4468588233, alpha: 1)
    return newButton
  }
  
  private func createTransitionButton(frame: CGRect, title: String) -> ATExpandableButton {
    let newButton = ATExpandableButton(frame: frame, title: title)
    newButton.iconTint = #colorLiteral(red: 0.7651568651, green: 0.8784276247, blue: 0.8978976607, alpha: 1)
    newButton.titleColor = #colorLiteral(red: 0.7651568651, green: 0.8784276247, blue: 0.8978976607, alpha: 1)
    newButton.backGroundColor = #colorLiteral(red: 0.1546225548, green: 0.266300261, blue: 0.4468588233, alpha: 1)
    newButton.delegate = self
    return newButton
  }
  
  func didEndTransitionAnimation(_ button: ATExpandableButton) {
    switch button.tag {
    case 1:
      QuestionGenerator.gameMode = .survival
    case 2:
      QuestionGenerator.gameMode = .time
    default:
      break
    }
    performSegue(withIdentifier: "toQuiz", sender: nil)
  }

}

