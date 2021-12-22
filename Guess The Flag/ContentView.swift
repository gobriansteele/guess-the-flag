//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Brian Steele on 12/19/21.
//

import SwiftUI

let GAME_LENGTH = 3

func handleCountrySelect(numberSelected: Int, correctAnswer: Int) -> Bool {
    return numberSelected == correctAnswer
}

func initializeQuestion() -> ([String], Int) {
    let localCountryCandidates = countries.shuffled()
    let localCorrectAnswer = Int.random(in: 0...2)
    return (localCountryCandidates, localCorrectAnswer)
}

func getAlertTitle(isCorrect: Bool) -> Text {
    var response: Text
    if isCorrect {
        response = Text("You got it!")
    } else {
        response = Text("Nope 😔")
    }
    return response
}

func getScoreMessage(score: Int) -> Text {
    return Text("\(score) out of \(GAME_LENGTH) correct")
}

let countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US" ]

struct FlagImage: View {
    let flagImage: String
    var body: some View {
        Image(flagImage)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct BlueText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.largeTitle)
    }
}

extension View {
    func blueText() -> some View {
        modifier(BlueText())
    }
}

struct ContentView: View {
    @State private var countryCandidates = countries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userScore = 0
    @State private var showingMessage = false
    @State private var isCorrect = false
    @State private var questionsAsked = 0
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 150, endRadius: 800   )
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                Text("Guess the Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    
                Spacer()
                    
                VStack(spacing: 20) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                        Text("\(countryCandidates[correctAnswer])")
                            .foregroundStyle(.primary)
                            .font(.title)
                    }
                    ForEach(0..<3) { number in
                        Button {
                            if handleCountrySelect(numberSelected: number, correctAnswer: correctAnswer) {
                                userScore += 1
                                isCorrect = true
                            } else {
                                isCorrect = false
                            }
                            questionsAsked += 1
                            showingMessage = true
                        } label: {
                            FlagImage(flagImage: countryCandidates[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 20)
                Spacer()
                Spacer()
                HStack {
                    Text("Score:")
                        .foregroundColor(.white)
                        .font(.body)
                    Text(" \(userScore)")
                        .foregroundColor(.white)
                        .font(.body)
                        .fontWeight(.bold)
                }
                Spacer()
            }.padding(.horizontal, 20)

        }.alert(isPresented: $showingMessage) {
            Alert(title: getAlertTitle(isCorrect: isCorrect), message: getScoreMessage(score: userScore),
                  primaryButton: .default(Text(questionsAsked < GAME_LENGTH ? "Next Question" : "Game Over")) {
                nextQuestion()
            },
                  secondaryButton: .destructive(Text("Reset").fontWeight(.light)) {
                resetGame()
            }
            )
        }
    }
    func resetGame() {
        userScore = 0
        shuffleCountries()
        randomAnswer()
    }
    func nextQuestion() {
        if questionsAsked >= GAME_LENGTH {
            resetGame()
            return
        }
        shuffleCountries()
        randomAnswer()
    }
    func shuffleCountries() {
        countryCandidates = countryCandidates.shuffled()
    }
    func randomAnswer() {
        correctAnswer = Int.random(in: 0...2)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
