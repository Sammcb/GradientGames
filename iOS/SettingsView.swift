//
//  SettingsView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct SettingsView: View {
	@Environment(\.managedObjectContext) private var context
	@EnvironmentObject private var settings: Settings
	@EnvironmentObject private var navigation: Navigation
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var chessThemes: FetchedResults<ChessTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var reversiThemes: FetchedResults<ReversiTheme>
	@AppStorage(Settings.Key.chessEnableUndo.rawValue) private var chessEnableUndo = true
	@AppStorage(Settings.Key.chessEnableTimer.rawValue) private var chessEnableTimer = true
	@AppStorage(Settings.Key.reversiEnableUndo.rawValue) private var reversiEnableUndo = true
	@AppStorage(Settings.Key.reversiEnableTimer.rawValue) private var reversiEnableTimer = true
	
	private func deleteChessTheme(at indexSet: IndexSet) {
		for index in indexSet {
			context.delete(chessThemes[index])
		}
		
		var deleted = 0
		for (index, theme) in chessThemes.enumerated() {
			guard !indexSet.contains(index) else {
				deleted += 1
				continue
			}
			
			if theme.index != index - deleted {
				theme.index = Int64(index - deleted)
			}
		}
		Store.shared.save()
	}
	
	private func deleteReversiTheme(at indexSet: IndexSet) {
		for index in indexSet {
			context.delete(reversiThemes[index])
		}
		
		var deleted = 0
		for (index, theme) in reversiThemes.enumerated() {
			guard !indexSet.contains(index) else {
				deleted += 1
				continue
			}
			
			if theme.index != index - deleted {
				theme.index = Int64(index - deleted)
			}
		}
		Store.shared.save()
	}
	
	private func moveChessThemeRow(from offsets: IndexSet, to offset: Int) {
		var themesArray = Array(chessThemes)
		themesArray.move(fromOffsets: offsets, toOffset: offset)
		for (index, themeRow) in themesArray.enumerated() {
			if themeRow.index != index {
				themeRow.index = Int64(index)
			}
		}
		Store.shared.save()
	}
	
	private func moveReversiThemeRow(from offsets: IndexSet, to offset: Int) {
		var themesArray = Array(reversiThemes)
		themesArray.move(fromOffsets: offsets, toOffset: offset)
		for (index, themeRow) in themesArray.enumerated() {
			if themeRow.index != index {
				themeRow.index = Int64(index)
			}
		}
		Store.shared.save()
	}
	
	var body: some View {
		Form {
			Section("Chess") {
				Toggle(isOn: $chessEnableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
						.symbolVariant(.circle.fill)
						.foregroundColor(.primary)
				}
				Toggle(isOn: $chessEnableTimer) {
					Label("Timers", systemImage: "clock")
						.symbolVariant(.fill)
						.foregroundColor(.primary)
				}
			}
			.headerProminence(.increased)
			
			Section("Theme") {
				List {
					ForEach(chessThemes) { theme in
						NavigationLink(destination: EditChessThemeView(theme), tag: theme.id!, selection: $navigation.editing) {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: settings.chessThemeId == theme.id ? "checkmark.circle.fill" : "circle")
									.foregroundColor(settings.chessThemeId == theme.id ? .green : .gray)
							}
						}
						.swipeActions(edge: .leading) {
							Button {
								settings.chessThemeId = settings.chessThemeId == theme.id ? nil : theme.id
							} label: {
								if settings.chessThemeId == theme.id {
									Label("Deselect", systemImage: "xmark")
								} else {
									Label("Select", systemImage: "checkmark")
								}
							}
						}
						.tint(settings.chessThemeId == theme.id ? .gray : .green)
						.swipeActions(edge: .trailing) {
							Button(role: .destructive) {
								deleteChessTheme(at: [chessThemes.firstIndex(of: theme)!])
							} label: {
								Label("Delete", systemImage: "trash")
							}
						}
					}
					.onDelete(perform: deleteChessTheme)
					.onMove(perform: moveChessThemeRow)
					
					Button {
						navigation.sheet = .newChess
					} label: {
						Label("Create theme", systemImage: "plus")
					}
				}
			}
			
			Section("Reversi") {
				Toggle(isOn: $reversiEnableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
						.symbolVariant(.circle.fill)
						.foregroundColor(.primary)
				}
				Toggle(isOn: $reversiEnableTimer) {
					Label("Timers", systemImage: "clock")
						.symbolVariant(.fill)
						.foregroundColor(.primary)
				}
			}
			.headerProminence(.increased)
			
			Section("Theme") {
				List {
					ForEach(reversiThemes) { theme in
						NavigationLink(destination: EditReversiThemeView(theme), tag: theme.id!, selection: $navigation.editing) {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: settings.reversiThemeId == theme.id ? "checkmark.circle.fill" : "circle")
									.foregroundColor(settings.reversiThemeId == theme.id ? .green : .gray)
							}
						}
						.swipeActions(edge: .leading) {
							Button {
								settings.reversiThemeId = settings.reversiThemeId == theme.id ? nil : theme.id
							} label: {
								if settings.reversiThemeId == theme.id {
									Label("Deselect", systemImage: "xmark")
								} else {
									Label("Select", systemImage: "checkmark")
								}
							}
						}
						.tint(settings.reversiThemeId == theme.id ? .gray : .green)
						.swipeActions(edge: .trailing) {
							Button(role: .destructive) {
								deleteReversiTheme(at: [reversiThemes.firstIndex(of: theme)!])
							} label: {
								Label("Delete", systemImage: "trash")
							}
						}
					}
					.onDelete(perform: deleteReversiTheme)
					.onMove(perform: moveReversiThemeRow)
					
					Button {
						navigation.sheet = .newReversi
					} label: {
						Label("Create theme", systemImage: "plus")
					}
				}
			}
		}
		.sheet(item: $navigation.sheet) { sheet in
			switch sheet {
			case .newChess:
				NewChessThemeView()
			case .newReversi:
				NewReversiThemeView()
			}
		}
		.navigationTitle("Settings")
		.toolbar {
			if !chessThemes.isEmpty || !reversiThemes.isEmpty {
				EditButton()
			}
		}
	}
}
