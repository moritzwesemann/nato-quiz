//
//  Models.swift
//  NATOAlphabetQuiz
//
//  Created by Moritz on 15.01.23.
//

import Foundation

enum State{
    case question, answer, score
}

enum Mode{
    case letter, word
}

struct Term{
    var character: String
    var word: String
}
