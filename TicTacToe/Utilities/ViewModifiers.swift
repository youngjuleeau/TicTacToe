//
//  ViewModifiers.swift
//  TicTacToe
//
//  Created by Young Ju Lee on 19/9/2023.
//

import SwiftUI

struct NavStackContainer: ViewModifier{
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}

extension View {
    public func inNavigationStack() -> some View {
        return self.modifier(NavStackContainer())
    } 
}
 
