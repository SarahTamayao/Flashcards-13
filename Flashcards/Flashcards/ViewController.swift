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
    
    var correctAnswerButton: UIButton!
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var wrongButton2: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //First start with the flashcard invisible and slightly smaller in size
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        rightButton.alpha = 0.0
        rightButton.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        wrongButton.alpha = 0.0
        wrongButton.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        wrongButton2.alpha = 0.0
        wrongButton2.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        // Animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: []) {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
            
            self.rightButton.alpha = 1.0
            self.rightButton.transform = CGAffineTransform.identity
            
            self.wrongButton2.alpha = 1.0
            self.wrongButton2.transform = CGAffineTransform.identity
            
            self.wrongButton.alpha = 1.0
            self.wrongButton.transform = CGAffineTransform.identity
        }

    }
    
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
        if wrongButton2.isEnabled == false{
            wrongButton2.isEnabled = true
        }
        if wrongButton.isEnabled == false{
            wrongButton.isEnabled = true
        }
        if rightButton.isEnabled == false{
            rightButton.isEnabled = true
        }
    }
    
    @IBAction func onTapOption2(_ sender: Any) {
        if rightButton == correctAnswerButton{
            flipFlashcard()
        }
        else{
            questionLabel.isHidden = false
            rightButton.isEnabled = false
        }
    }
    @IBAction func onTapOption3(_ sender: Any) {
        if wrongButton == correctAnswerButton {
            flipFlashcard()
        }
        else{
            questionLabel.isHidden = false
            wrongButton.isEnabled = false
        }
    }
    @IBAction func onTapOption1(_ sender: Any) {
        if wrongButton2 == correctAnswerButton {
            flipFlashcard()
        }
        else {
            questionLabel.isHidden = false
            wrongButton2.isEnabled = false
        }
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //increase current index
        currentIndex += 1
        
        //update buttons
        updateNextPrevButtons()
        
        animateCardOut()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex -= 1
        
        updateNextPrevButtons()
        
        animateCardIn()
    }
    
    @IBAction func onClick(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
       UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight) {
        if self.questionLabel.isHidden == false {
            self.questionLabel.isHidden = true
            }
        else if (self.questionLabel.isHidden == true){
            self.questionLabel.isHidden = false
            }
        }
    }
    
    func animateCardOut(){
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        } completion: { (finished) in
            //Update labels
            self.updateLabels()
            
            self.animateCardIn()
        }

    }
    
    func animateCardIn(){
        // Start on the right side (don't animate this)
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
        self.updateLabels()
    }
    
    func updateLabels(){
        //get current flashcard
        if currentIndex <= flashcards.count - 1 && currentIndex >= 0 {
            let currentFlashcard = flashcards[currentIndex]
            
            //update labels
            questionLabel.text = currentFlashcard.question
            answerLabel.text = currentFlashcard.answer
            
            let buttons = [wrongButton2, rightButton, wrongButton].shuffled()
            
            let answers = [currentFlashcard.answer, currentFlashcard.extraAnswerOne, currentFlashcard.extraAnswerTwo].shuffled()
            
            for (button, answer) in zip(buttons, answers) {
                // Set the title of this random button, with a random answer
                button?.setTitle(answer, for: .normal)
                
                // If this is the correct answer save the button
                if answer == currentFlashcard.answer {
                    correctAnswerButton = button
                }
            }
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

