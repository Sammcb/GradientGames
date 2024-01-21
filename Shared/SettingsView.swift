//
//  SettingsView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct SettingsView: View {
	@AppStorage(Setting.enableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	@AppStorage(Setting.showMoves.rawValue) private var showMoves = true
	
	var body: some View {
		Form {
			Section {
				Toggle(isOn: $enableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
				}
				Toggle(isOn: $enableTimer) {
					Label("Timers", systemImage: "clock")
				}
#if os(iOS)
				Toggle(isOn: $flipUI) {
					Label("Flip UI each turn", systemImage: "arrow.up.arrow.down")
				}
#endif
				Toggle(isOn: $showMoves) {
					Label("Show available moves", systemImage: "sparkle.magnifyingglass")
				}
			} header: {
				Text("General")
			} footer: {
#if os(tvOS)
				Label("Press the play/pause button to undo.", systemImage: "playpause")
					.symbolVariant(.circle)
#else
				EmptyView()
#endif
			}
			.headerProminence(.increased)
		}
		.navigationTitle("Settings")
	}
}
