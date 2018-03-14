//
//  File.swift
//  Namit
//
//  Created by Adrian on 3/13/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import Foundation

class Person {
    var charName: String
    var hp: Int
    var playerName: String
    var playerOrder: Int
    // TODO v2.0: keep tracks of punishment data
    
    init(charName: String, hp: Int, playerOrder: Int, playerName: String) {
        self.charName = charName
        self.hp = hp
        self.playerOrder = playerOrder
        self.playerName = playerName
    }
    
}
