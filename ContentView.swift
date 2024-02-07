//
//  ContentView.swift
//  SportingGoodStore
//
//  Created by Nicola Kaleta on 07/02/2024.
//

import SwiftUI
import TipKit

struct ContentView: View {
    @State var balls: [Ball] = [
        Ball(name: "Football", price: 7.77, image: "football.fill", color: .brown),
        Ball(name: "Basketball", price: 10.33, image: "basketball.fill", color: .orange),
        Ball(name: "Baseball", price: 3.99, image: "baseball", color: .red),
        Ball(name: "Soccer Ball", price: 5.99, image: "socerball", color: .indigo),
        Ball(name: "Volleyball", price: 7.77, image: "volleyball", color: .gray),
        Ball(name: "Tennis Ball", price: 1.99, image: "volleyball.fill", color: .gray),
        Ball(name: "Tennis Ball", price: 1.99, image: "tennisball.fill", color: .green)
    ]
    
    static let itemsHaveBeenPurchased = Tips.Event(id: "itemsHaveBeenPurchased")
    
    
    var body: some View {
        NavigationStack {
            List {
                // Section for favourited balls
                Section(header: Text("Favourites")) {
                    ForEach($balls.filter { $0.favourite.wrappedValue }) { $ball in
                        ballView(ball: $ball)
                        
                    }
                }
            }
        }
    }
    
    // Reusable view for a ball
    @ViewBuilder
    private func ballView(ball: Binding<Ball>) -> some View {
        HStack {
            Image(systemName: ball.wrappedValue.image)
                .foregroundStyle(ball.wrappedValue.color)
                .font(.title2)
            Text("\(ball.wrappedValue.price.formatted(.number.precision(.fractionLength(2))))")
            Image( systemName: ball.wrappedValue.favourite ? "star.fill" : "star")
                .foregroundStyle(.yellow)
                .font(.title2)
                .contentTransition(.symbolEffect(.replace))
                .onTapGesture {
                    withAnimation {
                        ball.favourite.wrappedValue.toggle()
                    }
                }
            Spacer()
            Button(action: {
                withAnimation {
                    ball.purchasedCount.wrappedValue += 1
                }
                Self.itemsHaveBeenPurchased.sendDonation()
            }, label: {
                Text("Buy")
            })
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.green)
        }
    }
}

#Preview {
    ContentView()
}
