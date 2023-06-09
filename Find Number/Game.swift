//
//  Game.swift
//  Find Number
//
//  Created by macbook on 05.06.2023.
//

import Foundation

enum StatusGame {
    case start
    case win
    case lose
}

class Game {
    
    struct Item {
        var title: String
        var isFound:Bool = false
        var isError = false
        
    }
    
    
    private let data = Array(1...99)
    
     var items:[Item] = []
    
    private var countItem: Int
    
    var nextItem: Item?
    
    var isnewRecord = false
    
    var status:StatusGame = .start {
        didSet {
            if status != .start {
                if status == .win{
                    let newRecord = timeForGame - secondsGame
                    
                    let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
                    
                    if record == 0 || newRecord < record {
                        UserDefaults.standard.setValue(newRecord, forKey: KeysUserDefaults.recordGame)
                        isnewRecord = true
                    }
                    
                }
                stopGame()
            }
        }
    }
    private var timeForGame: Int
    private var secondsGame: Int {
        didSet {
            if secondsGame == 0 {
                status = .lose
            }
            updateTimer(status,secondsGame)
        }
    }
    
    private var timer: Timer?
    
    private var updateTimer: ((StatusGame,Int)-> Void)
    
    init(countItem: Int, updateTimer:@escaping (_ status: StatusGame, _ second: Int)->Void) {
        self.countItem = countItem
        self.timeForGame = Settings.shared.currentSettings.timeForGame
        self.secondsGame = self.timeForGame
        self.updateTimer = updateTimer
        setupGame()
    }
    
    
    private func setupGame() {
        isnewRecord = false
        var digits = data.shuffled()
        items.removeAll()
        while items.count < countItem {
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        nextItem = items.shuffled().first
        
        updateTimer(status,secondsGame)
        
        if Settings.shared.currentSettings.timerState{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                self?.secondsGame -= 1
            })
        }
    }
    
    func newGame() {
        status = .start
        self.secondsGame = self.timeForGame
        setupGame()
    }
    
    func check(index: Int) {
        guard status == .start else { return }
        if items[index].title == nextItem?.title {
            items[index].isFound = true
            nextItem = items.shuffled().first(where: { item in
                item.isFound == false
            })
        }else {
            items[index].isError = true
        }
        
        if nextItem == nil {
            status = .win
        }
    }
    
    func stopGame () {
        timer?.invalidate()
    }
    
}

extension Int {
    func secondsToString() -> String{
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%d:%02d", minutes,seconds)
    }
}
