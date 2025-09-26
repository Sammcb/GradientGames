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
#if os(macOS)
				.frame(minWidth: 400, minHeight: 400)
#endif
		}
		.modelContainer(container)
#if os(macOS)
		Settings {
			SettingsView()
				.formStyle(.grouped)
				.frame(maxWidth: 600)
		}
		.modelContainer(container)
#endif
	}
	
	init() {
		let schema = Schema(versionedSchema: SchemaV1_0_0.self)
		let modelConfiguration = ModelConfiguration(schema: schema)
		do {
			container = try ModelContainer(for: schema, migrationPlan: MigrationPlan.self, configurations: modelConfiguration)
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}
}
