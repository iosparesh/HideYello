//
//  GameOverVC.swift
//  HideYello
//
//  Created by Paresh Prajapati on 27/02/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import UIKit

class GameOverVC: UIViewController {

    @IBOutlet weak var startAgainButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = ScoreBoard.shared.totalStarPoint
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startAgainTouched(_ sender: Any) {
        ScoreBoard.shared.delegate.restartGame()
        self.dismiss(animated: true, completion: nil)
    }
}

class PresentAbleVC: UIViewController {
    
    @IBOutlet weak var topConstrint: NSLayoutConstraint!
    @IBOutlet weak var handleView: UIView!
    enum CardViewState {
        case expanded
        case normal
    }
    var cardViewState : CardViewState = .normal
    var cardPanStartingTopConstant : CGFloat = 0.0
    var cardViewTopConstraint: CGFloat {
        set {
            var frame = self.view.frame
            frame.origin.y = newValue
            self.view.frame = frame
        }
        get {
            return self.view.frame.origin.y
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        topConstrint.constant = (UIScreen.main.bounds.height * 0.3415178571)
        handleView.clipsToBounds = true
        handleView.layer.cornerRadius = 3.0
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        self.view.addGestureRecognizer(viewPan)
    }
    
    @IBAction func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        // how much distance has user dragged the card view
        // positive number means user dragged downward
        // negative number means user dragged upward
        let translation = panRecognizer.translation(in: self.view)
        let velocity = panRecognizer.velocity(in: self.view)
        switch panRecognizer.state {
        case .began:
            cardPanStartingTopConstant = cardViewTopConstraint
        case .changed :
            if self.cardPanStartingTopConstant + translation.y > 0.0 {
                self.cardViewTopConstraint = self.cardPanStartingTopConstant + translation.y
            }
        case .ended :
            if velocity.y > 1500.0 {
                showCard(atState: .normal)
              return
            }
            if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
              let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
              
                if self.cardViewTopConstraint < (safeAreaHeight + bottomPadding) * 0.25 {
                showCard(atState: .expanded)
              } else if self.cardViewTopConstraint < (safeAreaHeight) - 70 {
                showCard(atState: .normal)
              } else {
                self.showCard(atState: .normal)
              }
            }
        default:
            break
        }
    }
}
extension PresentAbleVC {
    private func showCard(atState: CardViewState = .normal) {
       
      self.view.layoutIfNeeded()
      if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
        let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
        
        if atState == .expanded {
          // if state is expanded, top constraint is 30pt away from safe area top
          cardViewTopConstraint = 0.0
        } else {
            cardViewTopConstraint = (safeAreaHeight + bottomPadding) / 2
        }
        
        cardPanStartingTopConstant = cardViewTopConstraint
      }
      
      // move card up from bottom
      // create a new property animator
      let showCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
        self.view.layoutIfNeeded()
      })
      
      // show dimmer view
      // this will animate the dimmerView alpha together with the card move up animation
      showCard.addAnimations {
        self.view.alpha = 0.7
      }
      
      // run the animation
      showCard.startAnimation()
    }
}
