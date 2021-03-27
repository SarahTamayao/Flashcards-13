//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Hamed Polo on 3/6/21.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!
    
    @IBOutlet weak var questionTextField: UITextField!
    
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var extraAnswerTextField: UITextField!
    
    @IBOutlet weak var extraAnswer2TextField: UITextField!
    
    var initialQuestion: String?
    var initialAnswer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        // Getting the text in the question text field

        let questionText = questionTextField.text
        
        // Getting the text in the answer text field
        let answerText = answerTextField.text
        let extraAnswerText = extraAnswerTextField.text
        let extraAnswerText2 = extraAnswer2TextField.text
        
        if questionText == nil || answerText == nil || extraAnswerText == nil || extraAnswerText2 == nil || questionText!.isEmpty || answerText!.isEmpty || extraAnswerText!.isEmpty || extraAnswerText2!.isEmpty{
            
            let alert = UIAlertController(title: "Missing text!", message: "You need to have both a question and its answers.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            
            present(alert, animated: true)
        }
        else{
            // Call the function to update the flashcard
            var isExisiting = false
            
            if initialQuestion != nil{
                isExisiting = true
            }
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, extraAnswerOne: extraAnswerText!, extraAnswerTwo: extraAnswerText2!, isExisting: isExisiting)
            
            //Dismiss
            dismiss(animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
