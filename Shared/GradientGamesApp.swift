//
//  GradientGamesApp.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

@main
struct GradientGamesApp: App {
	var body: some Scene {
		WindowGroup {
			GamesView()
				.environment(\.managedObjectContext, Store.shared.container.viewContext)
		}
	}
}
