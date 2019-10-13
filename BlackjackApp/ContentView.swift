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
    @State var displayedCards: [Card] = []
    @State var score = 0
    @State var gameOver = false
    var gameStatusLabel: String {
        score == 21 ? "You won" : "You lost"
    }

    var body: some View {
        VStack {
            ForEach(displayedCards, id: \.self) { card in
                CardView(card: card)
            }
            Text("Score: \(score)").bold()
            HStack {
                Button(action: {
                    self.addCard()
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

    func addCard() {
        guard score < 21 else { return }
        let nextCard = deckManager.nextCard()
        displayedCards.append(nextCard)
        score += nextCard.rank.rawValue
        gameOver = score >= 21 ? true : false
    }

    func reset() {
        score = 0
        displayedCards = []
        deckManager.shuffle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(deckManager: DeckManager())
    }
}
