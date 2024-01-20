//
//  GradientGamesApp.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI
import SwiftData

@main
struct GradientGamesApp: App {
	let container: ModelContainer
	
	var body: some Scene {
		WindowGroup {
			GamesView()
		}
		.modelContainer(container)
		#if os(macOS)
		Settings {
			SettingsView()
		}
		.modelContainer(container)
		#endif
	}
	
	init() {
		let schema = Schema([Theme.self, ChessBoard.self, ReversiBoard.self, CheckersBoard.self])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
		
		do {
			container = try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}
}
