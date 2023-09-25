//
//  TicTacToeApp.swift
//  TicTacToe
//
//  Created by Young Ju Lee on 18/9/2023.
//

import SwiftUI

//entry point for app
@main
struct AppEntry: App {
    @AppStorage("yourName") var yourName = ""
    @StateObject var game = GameService()
    var body: some Scene {
        WindowGroup {
            if yourName.isEmpty {
                YourNameView()
                
            } else {
                StartView(yourName: yourName)
                    .environmentObject(game)
            }
        }
    }
}
