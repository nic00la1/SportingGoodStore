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
        Ball(name: "Soccer Ball", price: 5.99, image: "soccerball", color: .indigo),
        Ball(name: "Volleyball", price: 7.77, image: "volleyball", color: .gray),
        Ball(name: "Tennis Ball", price: 1.99, image: "volleyball.fill", color: .gray),
        Ball(name: "Tennis Ball", price: 1.99, image: "tennisball.fill", color: .green)
    ]
    
    static let itemsHaveBeenPurchased = Tips.Event(id: "itemsHaveBeenPurchased")
    
    let purchasedTip = PurchasedTip()
    let favouriteTip = FavouriteTip()
    
    
    var body: some View {
        NavigationStack {
            List {
                // Section for favourited balls
                Section(header: Text("Favourites")) {
                    ForEach($balls.filter { $0.favourite.wrappedValue }) { $ball in
                        ballView(ball: $ball)
                        
                    }
                }
                
                // Section for the rest of the balls
                Section(header: Text("Merchandise")) {
                    ForEach($balls.filter { !$0.favourite.wrappedValue }) { $ball in
                        ballView(ball: $ball)
                    }
                }
                
                // Section for purchased balls
                Section(header: Text("Purchased")) {
                    
                    TipView(purchasedTip)
                    
                    ForEach($balls) { $ball in
                        if ball.purchasedCount > 0 {
                            HStack {
                                Image(systemName: ball.image)
                                    .foregroundStyle(ball.color)
                                    .font(.title2)
                                Text("\(ball.name)s")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text("\(ball.purchasedCount)")
                                    .fontWeight(.bold)
                                    .contentTransition(.numericText())
                            }
                        }
                    }
                }
            }
            .navigationTitle("Sporting Goods")
        }
    }
    
    // Reusable view for a ball
    @ViewBuilder
    private func ballView(ball: Binding<Ball>) -> some View {
        HStack {
            Image(systemName: ball.wrappedValue.image)
                .foregroundStyle(ball.wrappedValue.color)
                .font(.title2)
            Text("\(ball.wrappedValue.name):")
                .fontWeight(.semibold)
            Text("\(ball.wrappedValue.price.formatted(.number.precision(.fractionLength(2))))")
            Image( systemName: ball.wrappedValue.favourite ? "star.fill" : "star")
                .foregroundStyle(.yellow)
                .font(.title2)
                .contentTransition(.symbolEffect(.replace))
                .popoverTip(favouriteTip)
                .onTapGesture {
                    withAnimation {
                        ball.favourite.wrappedValue.toggle()
                        favouriteTip.invalidate(reason: .actionPerformed)
                    }
                }
            Spacer()
            Button(action: {
                withAnimation {
                    ball.purchasedCount.wrappedValue += 1
                }
                purchasedTip.invalidate(reason: .actionPerformed)
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

struct PurchasedTip: Tip {
    var title: Text {
        Text("Purchased Items")
    }
    var message: Text? {
        Text("Purchased items will be displayed here")
    }
    var image: Image? {
        Image(systemName: "bag")
    }
}

struct FavouriteTip: Tip {
    var rules: [Rule] {
        #Rule(ContentView.itemsHaveBeenPurchased) {
            $0.donations.count >= 3
        }
    }
    
    var title: Text {
        Text("Favourite")
    }
    var message: Text? {
        Text("Tap the star to mark an item as a favourite")
    }
    var image: Image? {
        Image(systemName: "star")
    }
}

#Preview {
    ContentView()
}
