//
//  ViewController.swift
//  Flashcards
//
//  Created by Hamed Polo on 2/20/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var wrongButton2: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        card.clipsToBounds = true
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        questionLabel.clipsToBounds = true
        answerLabel.clipsToBounds = true
        
        rightButton.layer.cornerRadius = 20.0
        wrongButton.layer.cornerRadius = 20.0
        wrongButton2.layer.cornerRadius = 20.0
        rightButton.layer.borderWidth = 3.0
        wrongButton2.layer.borderWidth = 3.0
        wrongButton.layer.borderWidth = 3.0
        rightButton.layer.borderColor = #colorLiteral(red: 0, green: 1, blue: 0.07706925133, alpha: 1)
        wrongButton2.layer.borderColor = #colorLiteral(red: 0, green: 1, blue: 0.07706925133, alpha: 1)
        wrongButton.layer.borderColor = #colorLiteral(red: 0, green: 1, blue: 0.07706925133, alpha: 1)

    }
    
    @IBAction func onTapOption2(_ sender: Any) {
        questionLabel.isHidden = true
    }
    @IBAction func onTapOption3(_ sender: Any) {
        wrongButton.isHidden = true
    }
    @IBAction func onTapOption1(_ sender: Any) {
        wrongButton2.isHidden = true
    }
    
    @IBAction func onClick(_ sender: Any) {
        if questionLabel.isHidden == false {
            questionLabel.isHidden = true
        }
        else if (questionLabel.isHidden == true){
            questionLabel.isHidden = false
        }
    }
}

