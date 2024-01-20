//
//  macOSSettingsView.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/20/24.
//

import SwiftUI

import SwiftUI
import SwiftData

#if os(macOS)
struct SettingsView: View {
	private struct SelectedTheme: Identifiable {
		let id: UUID
	}
	
	@Environment(\.modelContext) private var context
	@Query(sort: \Theme.index) private var themes: [Theme]
	@AppStorage(Setting.enableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	@AppStorage(Setting.showMoves.rawValue) private var showMoves = true
	@AppStorage(Setting.chessTheme.rawValue) private var chessTheme = ""
	@AppStorage(Setting.reversiTheme.rawValue) private var reversiTheme = ""
	@AppStorage(Setting.checkersTheme.rawValue) private var checkersTheme = ""
	@State private var sheetTheme: SelectedTheme? = nil
	
	private func deleteTheme(for game: Theme.Game, at indexSet: IndexSet) {
		let gameThemes = themes.filter({ $0.game == game })
		for gameThemeIndex in indexSet {
			let id = gameThemes[gameThemeIndex].id
			guard let theme = themes.first(where: { $0.id == id }) else {
				continue
			}
			
			context.delete(theme)
		}
		for (index, theme) in themes.filter({ $0.game == game }).enumerated() {
			theme.index = index
		}
	}
	
	private func moveTheme(for game: Theme.Game, from offsets: IndexSet, to offset: Int) {
		var ids = themes.filter({ $0.game == game }).map({ $0.id })
		ids.move(fromOffsets: offsets, toOffset: offset)
		for (index, id) in ids.enumerated() {
			guard let theme = themes.first(where: { $0.id == id }) else {
				continue
			}
			
			theme.index = index
		}
	}
	
	var body: some View {
		Form {
			Section("General") {
				Toggle(isOn: $enableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
				}
				Toggle(isOn: $enableTimer) {
					Label("Timers", systemImage: "clock")
				}
				Toggle(isOn: $showMoves) {
					Label("Show available moves", systemImage: "sparkle.magnifyingglass")
				}
			}
			.headerProminence(.increased)
			
			Section("Chess") {
				let chessThemes = themes.filter({ $0.game == .chess })
				List {
					ForEach(chessThemes) { theme in
						let themeSelected = chessTheme == theme.id.uuidString
						HStack {
							Text(theme.symbol)
							Spacer()
							Button {
								chessTheme = themeSelected ? "" : theme.id.uuidString
							} label: {
								Label("Selected", systemImage: "checkmark.circle.fill")
									.labelStyle(.iconOnly)
									.opacity(themeSelected ? 1 : 0)
									.foregroundStyle(.green)
							}
						}
						.swipeActions(edge: .leading) {
							Button {
								sheetTheme = SelectedTheme(id: theme.id)
							} label: {
								Label("Edit", systemImage: "pencil")
									.tint(.blue)
							}
						}
					}
					.onDelete { indexSet in
						deleteTheme(for: .chess, at: indexSet)
					}
					.onMove { indexSet, index in
						moveTheme(for: .chess, from: indexSet, to: index)
					}
					
					Button {
						let theme = Theme(game: .chess)
						if let lastThemeIndex = chessThemes.last?.index {
							theme.index = lastThemeIndex + 1
						}
						context.insert(theme)
						sheetTheme = SelectedTheme(id: theme.id)
					} label: {
						Label("Create theme", systemImage: "plus")
					}
				}
			}
			.headerProminence(.increased)
			
			Section("Reversi") {
				let reversiThemes = themes.filter({ $0.game == .reversi })
				List {
					ForEach(reversiThemes) { theme in
						let themeSelected = reversiTheme == theme.id.uuidString
						HStack {
							Text(theme.symbol)
							Spacer()
							Button {
								reversiTheme = themeSelected ? "" : theme.id.uuidString
							} label: {
								Label("Selected", systemImage: "checkmark.circle.fill")
									.labelStyle(.iconOnly)
									.opacity(themeSelected ? 1 : 0)
									.foregroundStyle(.green)
							}
						}
						.swipeActions(edge: .leading) {
							Button {
								sheetTheme = SelectedTheme(id: theme.id)
							} label: {
								Label("Edit", systemImage: "pencil")
									.tint(.blue)
							}
						}
					}
					.onDelete { indexSet in
						deleteTheme(for: .reversi, at: indexSet)
					}
					.onMove { indexSet, index in
						moveTheme(for: .reversi, from: indexSet, to: index)
					}
					
					Button {
						let theme = Theme(game: .reversi)
						if let lastThemeIndex = reversiThemes.last?.index {
							theme.index = lastThemeIndex + 1
						}
						context.insert(theme)
						sheetTheme = SelectedTheme(id: theme.id)
					} label: {
						Label("Create theme", systemImage: "plus")
					}
				}
			}
			.headerProminence(.increased)
			
			Section("Checkers") {
				let checkersThemes = themes.filter({ $0.game == .checkers })
				List {
					ForEach(checkersThemes) { theme in
						let themeSelected = checkersTheme == theme.id.uuidString
						HStack {
							Text(theme.symbol)
							Spacer()
							Button {
								checkersTheme = themeSelected ? "" : theme.id.uuidString
							} label: {
								Label("Selected", systemImage: "checkmark.circle.fill")
									.labelStyle(.iconOnly)
									.opacity(themeSelected ? 1 : 0)
									.foregroundStyle(.green)
							}
						}
						.swipeActions(edge: .leading) {
							Button {
								sheetTheme = SelectedTheme(id: theme.id)
							} label: {
								Label("Edit", systemImage: "pencil")
									.tint(.blue)
							}
						}
					}
					.onDelete { indexSet in
						deleteTheme(for: .checkers, at: indexSet)
					}
					.onMove { indexSet, index in
						moveTheme(for: .checkers, from: indexSet, to: index)
					}
					
					Button {
						let theme = Theme(game: .checkers)
						if let lastThemeIndex = checkersThemes.last?.index {
							theme.index = lastThemeIndex + 1
						}
						context.insert(theme)
						sheetTheme = SelectedTheme(id: theme.id)
					} label: {
						Label("Create theme", systemImage: "plus")
					}
				}
			}
			.headerProminence(.increased)
		}
		.padding()
		.sheet(item: $sheetTheme) { selectedTheme in
			if let theme = themes.first(where: { $0.id == selectedTheme.id }) {
				ThemeView(theme: theme)
			}
		}
//		.onReceive(navigation.themeLinkOpened) { themeLinkOpened in
//			guard themeLinkOpened else {
//				return
//			}
//
//			sheetTheme = nil
//			navigation.themeLinkOpened = false
//		}
		.navigationTitle("Settings")
	}
}
#endif
