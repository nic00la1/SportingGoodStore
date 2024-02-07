//
//  Ball.swift
//  SportingGoodStore
//
//  Created by Nicola Kaleta on 07/02/2024.
//

import Foundation
import SwiftUI

struct Ball: Identifiable {
    var id: UUID = UUID()
    var name: String
    var price: Double
    var image: String
    var color: Color
    var purchasedCount: Int = 0
    var favourite: Bool = false
}
