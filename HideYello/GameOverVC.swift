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

