//
//  ContentView.swift
//  TicTacToe
//
//  Created by Young Ju Lee on 18/9/2023.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var game: GameService
    //Type GameType set with initial value of "undetermined"
    @State private var gameType : GameType = .undetermined
    //String properties bound to text fields
    @State private var yourName = ""
    @State private var opponentName = ""
    //We want to dismiss keyboard from the text fields when the game starts
    @FocusState private var focus : Bool
    @State private var startGame = false
    var body: some View {
        VStack {
            Picker("Select Game", selection: $gameType){
                //use tag to update GameType with that value when it is selected
                Text("Select Game Type").tag(GameType.undetermined)
                Text("Two Sharing Device").tag(GameType.single)
                Text("Challenge your device").tag(GameType.bot)
                Text("Challenge a friend").tag(GameType.peer)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
            Text(gameType.description)
                .padding()
            VStack {
                switch gameType {
                case .single:
                    VStack {
                        TextField("Your Name", text: $yourName)
                        TextField("Opponent Name", text: $opponentName)
                    }
                case .bot:
                    TextField("Your Name", text: $yourName)
                case .peer:
                    EmptyView()
                case .undetermined:
                    EmptyView()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .frame(width: 350)
            if gameType != .peer {
                Button("Start Game") {
                    game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
                    focus = false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    gameType == .undetermined ||
                    gameType == .bot && yourName.isEmpty ||
                    gameType == .single &&
                    (yourName.isEmpty || opponentName.isEmpty)
                )
                Image("LaunchScreen")
            }
            Spacer()
            
        }
        .padding()
        .navigationTitle("Xs and Os")
        .fullScreenCover(isPresented: $startGame) {
            GameView()
        }
        .inNavigationStack()
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(GameService())
    }
}
