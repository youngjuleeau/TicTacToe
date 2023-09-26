//
//  ContentView.swift
//  TicTacToe
//
//  Created by Young Ju Lee on 18/9/2023.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var game: GameService
    @StateObject var connectionManager: MPConnectionManager
    @State private var gameType : GameType = .undetermined
    @AppStorage("yourName") var yourName = ""
    @State private var opponentName = ""
    @FocusState private var focus : Bool
    @State private var startGame = false
    @State private var changeName = false
    @State private var newName = ""
    init(yourName: String) {
        self.yourName = yourName
        _connectionManager = StateObject(wrappedValue: MPConnectionManager(yourName: yourName))
    }
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
                        TextField("Opponent Name", text: $opponentName)
                    }
                case .bot:
                    EmptyView()
                case .peer:
                    MPPeersView(startGame : $startGame)
                        .environmentObject(connectionManager)
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
                    gameType == .single && opponentName.isEmpty
                )
                Image("LaunchScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                Text("Your name is \(yourName)")
                Button("Change my name") {
                    changeName.toggle()
                }
                .buttonStyle(.bordered)
            }
            Spacer()
            
        }
        .padding()
        .navigationTitle("Xs and Os")
        .fullScreenCover(isPresented: $startGame) {
            GameView()
                .environmentObject(connectionManager)
        }
        .alert("Change Name", isPresented: $changeName, actions: {
            TextField("New name", text: $newName)
            Button("OK", role: .destructive) {
                yourName = newName
                //force a quit
                exit(-1)
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Tapping the OK button will quit the application so you can relaunch to use your changed name.")
        })
        .inNavigationStack()
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(yourName: "Sample")
            .environmentObject(GameService())
    }
}
