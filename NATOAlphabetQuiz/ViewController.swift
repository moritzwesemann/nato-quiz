//
//  ViewController.swift
//  NATOAlphabetQuiz
//
//  Created by Moritz on 14.01.23.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    //-----Variables-----
    
    let fixedAlphabete = [Term(character: "A", word: "Alpha"), Term(character: "B", word: "Bravo"), Term(character: "C", word: "Charlie"), Term(character: "D", word: "Delta"), Term(character: "E", word: "Echo"), Term(character: "F", word: "Foxtrot"), Term(character: "G", word: "Golf"), Term(character: "H", word: "Hotel")]
    var usedAlphabete: [Term] = []
    var words = ["Da", "Cafe", "Dach"]
    var currentCharacterIndex = 0
    
    var mode: Mode = .letter
    var state: State = .question
    var score = 0
    var answerCorrect = false
    var correctWords: [String] = []
    
    //-----Outlets-----
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var nextActionButton: UIButton!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    
    //-----Actions-----
    
    @IBAction func switchModes(_ sender: Any) {
        switch modeSelector.selectedSegmentIndex{
        case 0:
            usedAlphabete = fixedAlphabete
            mode = .letter
        case 1:
            usedAlphabete = fixedAlphabete.shuffled()
            mode = .letter
        case 2:
            mode = .word
        default:
            print("Error: modeSelector.selectedSegmentIndex out of range")
        }
        resetQuiz()
        updateUI()
    }
    
    //Controll
    @IBAction func submitTextField(_ sender: Any) {
        let enteredText = textField.text!
        switch mode{
        case .letter:
            testLetter(text: enteredText)
        case .word:
            testWord(text: enteredText)
        }
        state = .answer
        updateUI()
    }
    
    //Controll nextButton
    
    @IBAction func nextButton(_ sender: Any) {
        var arrayCount: Int = 0
        
        switch state {
        case .question:
            textField.sendActions(for: .primaryActionTriggered)
        case .answer:
            switch mode {
            case .letter:
                arrayCount = usedAlphabete.count
            case .word:
                arrayCount = words.count
            }
            if currentCharacterIndex >= arrayCount - 1{
                state = .score
            } else {
                currentCharacterIndex += 1
                state = .question
            }
            case .score:
                resetQuiz()
        }
        updateUI()
    }
    
    //-----UI Updates-----
    
    //Update UI for normal and random mode
    func updateLetterMode(){
        topLabel.text = usedAlphabete[currentCharacterIndex].character
        
        switch state {
        case .question:
            return
        case .answer:
            if answerCorrect{
                textLabel.text = usedAlphabete[currentCharacterIndex].word + " ✅"
            } else {
                textLabel.text = "❌\n Correct Answer: " +  usedAlphabete[currentCharacterIndex].word
            }
        case .score:
            let percentageScore = calculatePercentage(score: score, questions: usedAlphabete.count)
            textLabel.text = "You've got \(percentageScore)% correct!"
        }
    }

    //Update UI for word mode
    
    func updateWordMode(){
        topLabel.text = words[currentCharacterIndex]
        
        switch state {
        case .question:
            return
        case .answer:
            if answerCorrect{
                textLabel.text = "✅"
            } else {
                textLabel.text = "❌\n Correct Answer: " +  correctWords.joined(separator: " ")
            }
        case .score:
            let percentageScore = calculatePercentage(score: score, questions: words.count)
            textLabel.text = "You've got \(percentageScore)% correct!"
        }
    }
    
    //All updates on the UI
    
    func updateUI(){
        switch mode{
        case .letter:
            updateLetterMode()
        case .word:
            updateWordMode()
        }
        //UI Updates that are the same for .word and .letter
        switch state {
        case .question:
            textLabel.text = "❓❓❓"
            nextActionButton.setTitle("Submit", for: .normal)
            textField.isEnabled = true
            textField.text = ""
            textField.isHidden = false
        case .answer:
            nextActionButton.setTitle("Next", for: .normal)
            textField.isEnabled = false
        case .score:
            topLabel.text = "Score: \(score)"
            nextActionButton.setTitle("Restart", for: .normal)
            textField.isHidden = true
        }
    }
    
    //-----Check functions-----
    
    //Checks if word matches letter
    func testLetter(text: String){
        if text.lowercased() == usedAlphabete[currentCharacterIndex].word.lowercased(){
            answerCorrect = true
            score += 1
        } else{
            answerCorrect = false
        }
    }
    
    //Checks if enteredWords and correctWords (from the words array) agree
    
    func testWord(text: String) {
        let lowerCasedText = text.lowercased()
        let enteredWords = lowerCasedText.components(separatedBy: " ")
        correctWords.removeAll()

        for character in words[currentCharacterIndex].lowercased(){
            if let term = fixedAlphabete.first(where: {$0.character == String(character).uppercased() }) {
                correctWords.append(term.word.lowercased())
            }
        }
        
        if enteredWords == correctWords{
            answerCorrect = true
            score += 1
        } else {
            answerCorrect = false
        }
    }
    
    //Calculate percentage number of correct answers
    func calculatePercentage(score: Int, questions: Int) -> Int{
        var percentage: Int = 0
        
        if mode == .letter {
            percentage = Int(round(Double(score) / Double(usedAlphabete.count) * 100))
        } else {
            percentage = Int(round(Double(score) / Double(words.count) * 100))
        }
        return percentage
    }
    
    //Reset Quiz values
    func resetQuiz(){
        currentCharacterIndex = 0
        score = 0
        state = .question
    }
    
    //After app launched initial setup
    override func viewDidLoad() {
        super.viewDidLoad()
        usedAlphabete = fixedAlphabete
        updateUI()
    }
}

