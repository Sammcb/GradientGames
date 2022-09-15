//
//  SettingsView.swift
//  GradientGamestvOS
//
//  Created by Sam McBroom on 2/15/22.
//

import SwiftUI

struct SettingsView: View {
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var chessThemes: FetchedResults<ChessTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var reversiThemes: FetchedResults<ReversiTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\CheckersTheme.index, order: .forward)]) private var checkersThemes: FetchedResults<CheckersTheme>
	@AppStorage(Setting.chessTheme.rawValue) private var chessTheme = ""
	@AppStorage(Setting.chessEnableUndo.rawValue) private var chessEnableUndo = true
	@AppStorage(Setting.chessEnableTimer.rawValue) private var chessEnableTimer = true
	@AppStorage(Setting.reversiTheme.rawValue) private var reversiTheme = ""
	@AppStorage(Setting.reversiEnableUndo.rawValue) private var reversiEnableUndo = true
	@AppStorage(Setting.reversiEnableTimer.rawValue) private var reversiEnableTimer = true
	@AppStorage(Setting.checkersTheme.rawValue) private var checkersTheme = ""
	@AppStorage(Setting.checkersEnableUndo.rawValue) private var checkersEnableUndo = true
	@AppStorage(Setting.checkersEnableTimer.rawValue) private var checkersEnableTimer = true
	
	var body: some View {
		Form {
			Section("Chess") {
				Toggle(isOn: $chessEnableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
						.symbolVariant(.circle.fill)
				}
				Toggle(isOn: $chessEnableTimer) {
					Label("Timers", systemImage: "clock")
						.symbolVariant(.fill)
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
						let themeSelected = chessTheme == theme.id!.uuidString
						Button {
							chessTheme = themeSelected ? "" : theme.id!.uuidString
						} label: {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: themeSelected ? "checkmark.circle.fill" : "circle")
									.foregroundColor(themeSelected ? .green : .gray)
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
				}
				Toggle(isOn: $reversiEnableTimer) {
					Label("Timers", systemImage: "clock")
						.symbolVariant(.fill)
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
						let themeSelected = reversiTheme == theme.id!.uuidString
						Button {
							reversiTheme = themeSelected ? "" : theme.id!.uuidString
						} label: {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: themeSelected ? "checkmark.circle.fill" : "circle")
									.foregroundColor(themeSelected ? .green : .gray)
							}
						}
					}
				}
			}
			.headerProminence(.increased)
			
			Section("Checkers") {
				Toggle(isOn: $checkersEnableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
						.symbolVariant(.circle.fill)
				}
				Toggle(isOn: $checkersEnableTimer) {
					Label("Timers", systemImage: "clock")
						.symbolVariant(.fill)
				}
			}
			
			Section("Theme") {
				List {
					if checkersThemes.isEmpty {
						Text("Please create themes on your iOS device. They will show up here if you are signed into iCloud.")
							.listRowBackground(Color.clear)
							.frame(maxWidth: .infinity, alignment: .center)
					}
					ForEach(checkersThemes) { theme in
						let themeSelected = checkersTheme == theme.id!.uuidString
						Button {
							checkersTheme = themeSelected ? "" : theme.id!.uuidString
						} label: {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: themeSelected ? "checkmark.circle.fill" : "circle")
									.foregroundColor(themeSelected ? .green : .gray)
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
