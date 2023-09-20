//
//  GameView.swift
//  TicTacToe
//
//  Created by Young Ju Lee on 19/9/2023.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameService
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            if [game.player1.isCurrent, game.player2.isCurrent].allSatisfy({$0 == false}) {
                Text("Select a player to start")
            }
            HStack {
                Button(game.player1.name) {
                    game.player1.isCurrent = true
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
                Button(game.player2.name) {
                    game.player2.isCurrent = true
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player2.isCurrent))
            }
            .disabled(game.gameStarted)
            VStack {
                HStack {
                    ForEach (0...2, id:\.self) { index in
                        SquareView(index: index)
                    }
                }
                HStack {
                    ForEach (3...5, id:\.self) { index in
                        SquareView(index: index)
                    }
                }
                HStack {
                    ForEach (6...8, id:\.self) { index in
                        SquareView(index: index)
                    }
                }
            }
            .disabled(game.boardDisabled)
            VStack {
                if game.gameOver {
                    Text("Game Over")
                    if game.possibleMoves.isEmpty {
                        Text("Nobody wins")
                    } else {
                        Text("\(game.currentPlayer.name) wins")
                    }
                    Button("New Game") {
                        game.reset()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .font(.largeTitle)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End Game") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Xs and Os")
        //Ensure board is reset everytime game view appears -could exit screen without clearing the board-
        .onAppear{
            game.reset()
        } 
        .inNavigationStack()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameService())
    }
}

struct PlayerButtonStyle: ButtonStyle {
    let isCurrent: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(isCurrent  ? Color.green : Color.gray)
            )
            .foregroundColor(.white)
    }
    
}
