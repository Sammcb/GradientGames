//
//  GamesView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/15/22.
//

import SwiftUI

struct GamesView: View {
	var body: some View {
		NavigationView {
			List {
				NavigationLink {
					ChessView()
						.buttonStyle(.plain)
				} label: {
					Label("Chess", systemImage: "crown")
						.contextMenu {
							Button(role: .destructive, action: ChessState.reset) {
								Label("New game", systemImage: "trash")
							}
						}
				}
				
				NavigationLink {
					ReversiView()
						.buttonStyle(.plain)
				} label: {
					Label("Reversi", systemImage: "circle")
						.contextMenu {
							Button(role: .destructive, action: ReversiState.reset) {
								Label("New game", systemImage: "trash")
							}
						}
				}
				
				NavigationLink {
					CheckersView()
						.buttonStyle(.plain)
				} label: {
					Label("Checkers", systemImage: "circle")
						.symbolVariant(.circle)
						.contextMenu {
							Button(role: .destructive, action: CheckersState.reset) {
								Label("New game", systemImage: "trash")
							}
						}
				}
				
				Section("Settings") {
					NavigationLink(destination: SettingsView()) {
						Label("Settings", systemImage: "gearshape")
					}
				}
			}
			.navigationTitle("Games")
			.symbolVariant(.fill)
		}
	}
}
