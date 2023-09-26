//
//  MPPeersView.swift
//  TicTacToe
//
//  Created by Young Ju Lee on 25/9/2023.
//

import SwiftUI

struct MPPeersView: View {
    
    @EnvironmentObject var connectionManger: MPConnectionManager
    @EnvironmentObject var game: GameService
    @Binding var startGame: Bool
    var body: some View {
        VStack {
            Text("Available Players")
            List(connectionManger.availablePeers, id: \.self) { peer in
                HStack {
                    Text(peer.displayName)
                    Spacer()
                    Button("Select") {
                        game.gameType = .peer
                        connectionManger.nearbyServiceBrowser.invitePeer(peer, to: connectionManger.session, withContext: nil, timeout: 30)
                        game.player1.name = connectionManger.myPeerId.displayName
                        game.player2.name = peer.displayName
                    }
                    .buttonStyle(.borderedProminent)
                }
                .alert("Received Invitation from \(connectionManger.receivedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManger.receivedInvite) {
                    Button("Accept") {
                        if let invitationHandler = connectionManger.invitationHandler {
                            invitationHandler(true, connectionManger.session)
                            game.player1.name = connectionManger.receivedInviteFrom?.displayName ?? "Unknown"
                            game.player2.name = connectionManger.myPeerId.displayName
                            game.gameType = .peer
                        }
                    }
                    Button("Reject") {
                        if let invitationHandler = connectionManger.invitationHandler {
                            invitationHandler(false, nil)
                        }
                    }
                }
            }
        }
        .onAppear {
            connectionManger.isAvailableToPlay = true
            connectionManger.startBrowsing()
        }
        .onDisappear {
            connectionManger.stopBrowsing()
            connectionManger.stopAdvertising()
            connectionManger.isAvailableToPlay = false
        }
        .onChange(of: connectionManger.paired) { newValue in
            startGame = newValue        }
    }
}

struct MPPeersView_Previews: PreviewProvider {
    static var previews: some View {
        MPPeersView(startGame: .constant(false))
            .environmentObject(MPConnectionManager(yourName: "Sample"))
            .environmentObject(GameService())
    }
}
