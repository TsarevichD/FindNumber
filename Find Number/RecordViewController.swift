//
//  RecordViewController.swift
//  Find Number
//
//  Created by macbook on 08.06.2023.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
        if record != 0 {
            recordLabel.text = "You record - \(record) sec"
        }else{
            recordLabel.text = "No record set "
        }
        
        
    }
    
    @IBAction func closedVC(_ sender: Any) {
        dismiss(animated: true)
    }
    

}
