//
//  ScoreBoard.swift
//  HideYello
//
//  Created by Paresh Prajapati on 26/02/20.
//  Copyright © 2020 SolutionAnalysts. All rights reserved.
//

import Foundation
protocol UpdateScrollDelegate: class {
    func didUpdatePoint(text: String)
    func didUpdateBomb()
    func restartGame()
    func updateKilometer(text: String)
}
extension UpdateScrollDelegate {
    func restartGame() {
        
    }
}
class ScoreBoard: NSObject {
    static let shared = ScoreBoard()
    public weak var delegate:UpdateScrollDelegate!
    var totalStarPoint:String {
        return UserDefaults.standard.string(forKey: "coins") ?? "0"
    }
    var totalKm:Float = 0.00
    func updateStars(count: Double) {
        let old = Double(UserDefaults.standard.string(forKey: "coins") ?? "0")
        let newStarPoint = old! + count
        UserDefaults.standard.set("\(newStarPoint)", forKey: "coins")
        delegate.didUpdatePoint(text: "\(newStarPoint)")
    }
}
