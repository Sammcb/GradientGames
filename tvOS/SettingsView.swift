//
//  SettingsView.swift
//  GradientGamestvOS
//
//  Created by Sam McBroom on 2/15/22.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject private var settings: Settings
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var chessThemes: FetchedResults<ChessTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var reversiThemes: FetchedResults<ReversiTheme>
	@AppStorage(Settings.Key.chessEnableUndo.rawValue) private var chessEnableUndo = true
	@AppStorage(Settings.Key.chessEnableTimer.rawValue) private var chessEnableTimer = true
	@AppStorage(Settings.Key.reversiEnableUndo.rawValue) private var reversiEnableUndo = true
	@AppStorage(Settings.Key.reversiEnableTimer.rawValue) private var reversiEnableTimer = true
	
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
			
			Section("Theme") {
				List {
					if chessThemes.isEmpty {
						Text("Please create themes on your iOS device. They will show up here if you are signed into iCloud.")
							.listRowBackground(Color.clear)
							.frame(maxWidth: .infinity, alignment: .center)
					}
					ForEach(chessThemes) { theme in
						Button {
							settings.chessThemeId = settings.chessThemeId == theme.id ? nil : theme.id
						} label: {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: settings.chessThemeId == theme.id ? "checkmark.circle.fill" : "circle")
									.foregroundColor(settings.chessThemeId == theme.id ? .green : .gray)
							}
						}
					}
				}
			}
			.headerProminence(.increased)
			
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
			
			Section("Theme") {
				List {
					if reversiThemes.isEmpty {
						Text("Please create themes on your iOS device. They will show up here if you are signed into iCloud.")
							.listRowBackground(Color.clear)
							.frame(maxWidth: .infinity, alignment: .center)
					}
					ForEach(reversiThemes) { theme in
						Button {
							settings.reversiThemeId = settings.reversiThemeId == theme.id ? nil : theme.id
						} label: {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: settings.reversiThemeId == theme.id ? "checkmark.circle.fill" : "circle")
									.foregroundColor(settings.reversiThemeId == theme.id ? .green : .gray)
							}
						}
					}
				}
			}
			.headerProminence(.increased)
		}
		.navigationTitle("Settings")
	}
}
