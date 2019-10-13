//
//  ContentView.swift
//  BlackjackApp
//
//  Created by Paweł Dziennik on 03/10/2019.
//  Copyright © 2019 Crux Solutions. All rights reserved.
//

import Cards
import SwiftUI

struct ContentView: View {
    let deckManager: DeckManager
    
    @State var dealerCards: [Card] = []
    @State var displayedCards: [Card] = []
    @State var yourScore = 0
    @State var dealerScore = 0
    @State var gameOver = false
    @State var youAreWinner = false
    
    var gameStatusLabel: String {
        youAreWinner ? "You won" : "You lost"
    }

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Your cards")
                    ForEach(displayedCards, id: \Card.id) { card in
                        CardView(card: card)
                    }
                    Text("Score: \(yourScore)").bold()
                }
                VStack {
                    Text("Dealer cards")
                    ForEach(dealerCards, id: \Card.id) { card in
                        CardView(card: card)
                    }
                    Text("Score: \(dealerScore)").bold()

                }
            }
            
            HStack {
                Button(action: {
                    self.addCard()
                    self.addCard(dealer: true)
                }) {
                    Text("Add card")
                }
                Button(action: {
                    self.reset()
                }) {
                    Text("Reset")
                }
            }
        }.alert(isPresented: $gameOver) {
            Alert(
                title: Text("Game is over"),
                message: Text(gameStatusLabel),
                dismissButton: Alert.Button.cancel()
            )
        }
    }

    func addCard(dealer: Bool = false) {
        guard !gameOver else { return }
        let nextCard = deckManager.nextCard()
        if dealer {
            dealerCards.append(nextCard)
            dealerScore += nextCard.rank.rawValue
        } else {
            displayedCards.append(nextCard)
            yourScore += nextCard.rank.rawValue
        }
        checkScore()
    }
    
    func checkScore() {
        gameOver = (yourScore >= 21 || dealerScore >= 21) ? true : false
        guard gameOver else { return }
        if yourScore < 21 && dealerScore > 21 {
            youAreWinner = true
        } else if yourScore < 21 && dealerScore < yourScore {
            youAreWinner = true
        } else if yourScore == 21 {
            youAreWinner = true
        } else {
            youAreWinner = false
        }
    }

    func reset() {
        yourScore = 0
        dealerScore = 0
        displayedCards = []
        dealerCards = []
        deckManager.shuffle()
        youAreWinner = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(deckManager: DeckManager())
    }
}
