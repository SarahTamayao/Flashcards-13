//
//  ViewController.swift
//  Flashcards
//
//  Created by Hamed Polo on 2/20/21.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var extraAnswerOne: String
    var extraAnswerTwo: String
}

class ViewController: UIViewController {
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    // Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    //Current flashcard index
    var currentIndex = 0
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
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
        
        // read saved flashcards
        readSavedFlashcards()
        
        // having an initial flashcard if needed
        if flashcards.count == 0{
            updateFlashcard(question: "What is considered the best programming language to learn first?", answer: "Python", extraAnswerOne: "Java", extraAnswerTwo: "C++", isExisting: true)
        }
        else{
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    @IBAction func didTapOnReset(_ sender: Any) {
        if questionLabel.isHidden == true{
            questionLabel.isHidden = false
        }
        if wrongButton2.isHidden == true{
            wrongButton2.isHidden = false
        }
        if wrongButton.isHidden == true{
            wrongButton.isHidden = false
        }
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
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //increase current index
        currentIndex += 1
        
        //update labels
        updateLabels()
        
        //update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex -= 1
        
        updateLabels()
        
        updateNextPrevButtons()
    }
    
    @IBAction func onClick(_ sender: Any) {
        if questionLabel.isHidden == false {
            questionLabel.isHidden = true
        }
        else if (questionLabel.isHidden == true){
            questionLabel.isHidden = false
        }
    }
    func updateLabels(){
        //get current flashcard
        if currentIndex <= flashcards.count - 1 && currentIndex >= 0 {
            let currentFlashcard = flashcards[currentIndex]
            
        
            //update labels
            questionLabel.text = currentFlashcard.question
            answerLabel.text = currentFlashcard.answer
            wrongButton.setTitle(currentFlashcard.extraAnswerOne, for: .normal)
            wrongButton2.setTitle(currentFlashcard.extraAnswerTwo, for: .normal)
            rightButton.setTitle(currentFlashcard.answer, for: .normal)
        }
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String, extraAnswerTwo: String, isExisting: Bool) {
        
        var flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
        
        questionLabel.text = flashcard.question
        answerLabel.text = flashcard.answer
        let extraAnswerOne = flashcard.extraAnswerOne
        let extraAnswerTwo = flashcard.extraAnswerTwo
        
        wrongButton.setTitle(extraAnswerOne, for: .normal)
        rightButton.setTitle(answer, for: .normal)
        wrongButton2.setTitle(extraAnswerTwo, for: .normal)
        
        // Adding flashcard in the flashcards array
        if currentIndex <= flashcards.count - 1 {
            if isExisting {
                if currentIndex < 0 {
                    flashcard = Flashcard(question: "Create/edit your own question and answers", answer: "", extraAnswerOne: "", extraAnswerTwo: "")
                }
                else{
                    flashcards[currentIndex] = flashcard
                }
            }
            else {
                flashcards.append(flashcard)
            
                //Logging to the console
                print("Added new flashcard")
                print("We now have \(flashcards.count) flashcards")
                
                //updating current index
                currentIndex = flashcards.count - 1
                print("Our current index is \(currentIndex)")
            }
        }
        //Update buttons
        updateNextPrevButtons()
        
        // update labels
        updateLabels()
        
        // save flashcards to disk
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons(){
        //Disable next button if at the end
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        }
        else{
            nextButton.isEnabled = true
        }
        //Disable prev button if at the beginning
        if currentIndex == 0{
            prevButton.isEnabled = false
        }
        else{
            prevButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // We know the destination of the segue is the navigation controller
        let navigationController = segue.destination as! UINavigationController
        
        // We know the navigation controller only contains a creation view controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        // Set the flashcardsController property to self
        creationController.flashcardsController = self
        if segue.identifier == "EditSegue"{
            creationController.initialQuestion = questionLabel.text
            creationController.initialAnswer = answerLabel.text
        }
    }
    
    func saveAllFlashcardsToDisk(){
        //converting flashcard array into dictinoary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer, "extraAnswerOne": card.extraAnswerOne, "extraAnswerTwo": card.extraAnswerTwo]
        }
        
        //save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // logging the save
        print("flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards(){
        //read dictionary array from disk (if one exist)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            
            //converting dictionary array back to regular flashcard array
            let savedCards = dictionaryArray.map { (dictionary) -> Flashcard in
                return Flashcard(question: dictionary["question"] ?? flashcards[currentIndex].question, answer: dictionary["answer"] ?? flashcards[currentIndex].answer, extraAnswerOne: dictionary["extraAnswerOne"] ?? flashcards[currentIndex].extraAnswerOne, extraAnswerTwo: dictionary["extraAnswerTwo"] ?? flashcards[currentIndex].extraAnswerTwo)
            }
            // put all the cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    @IBAction func didOnTapDelete(_ sender: Any) {
        //show confirmation
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteCurrentFlashcard()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard(){
        if currentIndex >= 0 {
            flashcards.remove(at: currentIndex)
        }
        
        //check if the last card was deleted
        if currentIndex > flashcards.count - 1{
            currentIndex = flashcards.count - 1
        }
        
        if currentIndex < 0{
            updateFlashcard(question: "Create/edit your own question and answers", answer: "", extraAnswerOne: "", extraAnswerTwo: "", isExisting: true)
        }
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
}

