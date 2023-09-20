//
//  GameSquare.swift
//  TicTacToe
//
//  Created by Young Ju Lee on 20/9/2023.
//

import SwiftUI

//Each GameSquare will have 2 properties: Index, Player
struct GameSquare {
    //Index from 1-9 to represent one of the squares
    var id: Int
    //Optional player object associated with that square
    var player: Player?
    
    var image: Image {
        if let player = player {
            return player.gamePiece.image
        } else {
            return Image("none")
        }
    }
    
    static var reset: [GameSquare] {
        var squares = [GameSquare]()
        for index in 1...9 {
            squares.append(GameSquare(id: index))
        }
        return squares
    }
}
