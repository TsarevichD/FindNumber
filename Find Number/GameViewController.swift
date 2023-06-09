//
//  GameViewController.swift
//  Find Number
//
//  Created by macbook on 05.06.2023.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var nextDigit: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    lazy var game = Game(countItem: buttons.count) { [weak self]status, second in
        guard let self = self else { return }
        
        self.timerLabel.text = second.secondsToString()
        self.updateInfoGame(with: status)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        game.stopGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        
        
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else { return }
        game.check(index: buttonIndex)
        updateUI()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
        
    }
    private func setupScreen() {
        for index in game.items.indices{
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
            //            buttons[index].isHidden = false
        }
        nextDigit.text = game.nextItem?.title
    }
    
    private func updateUI() {
        for index in game.items.indices {
            //            buttons[index].isHidden = game.items[index].isFound
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            buttons[index].isEnabled = !game.items[index].isFound
            
            if game.items[index].isError{
                UIView.animate(withDuration: 0.3) {[weak self] in
                    self?.buttons[index].backgroundColor = .red
                }completion: { [weak self](_) in
                    self?.buttons[index].backgroundColor = .white
                    self?.game.items[index].isError = false
                }
            }
        }
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame){
        switch status {
        case .start:
            statusLabel.text = "Игра началась"
            statusLabel.textColor = .black
            newGameButton.isHidden = true
        case.win:
            statusLabel.text = "Победа"
            statusLabel.textColor = .green
            newGameButton.isHidden = false
            if game.isnewRecord {
                showAlert()
            }else{
                showAlertActionSheet()
            }
        case.lose:
            statusLabel.text = "Вы Проиграли"
            statusLabel.textColor = .red
            newGameButton.isHidden = false
            showAlertActionSheet()
        }
    }
    private func showAlert() {
        
        let alert = UIAlertController(title: "Congratilation!", message: "You set a new record!", preferredStyle: .alert)
        let okatAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okatAction)
        
        present(alert, animated: true)
        
    }
    private func showAlertActionSheet() {
        
        let alert = UIAlertController(title: "what do you want to do next ?", message: nil, preferredStyle: .actionSheet)
        
        let newGameAction = UIAlertAction(title: "start a new game", style: .default) { [weak self](_) in
            self?.game.newGame()
            self?.setupScreen()
        }
        
        let showRecord = UIAlertAction(title: "See Records", style: .default) { [weak self](_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        let menuAction = UIAlertAction(title: "Go to menu", style: .destructive) { [weak self](_) in
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        //        MARK: - прописывает алерт контролерс для Ipad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view // либо вместе self.view - пишем к чему привязать alert и оно будет привязано к нему
            popover.sourceRect = CGRect(x: Int(self.view.bounds.midX), y: Int(self.view.bounds.midY), width: 0, height: 0)
            popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        }
        
        present(alert, animated: true)
    }
    
}
