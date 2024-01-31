//
//  SettingsView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI
import CloudKit

struct SettingsView: View {
	@AppStorage(Setting.enableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	@AppStorage(Setting.showMoves.rawValue) private var showMoves = true
	@State private var icloudStatus: CKAccountStatus = .couldNotDetermine
	
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
#endif
			}
			.headerProminence(.increased)
			
			let statusDescription = switch icloudStatus {
			case .couldNotDetermine: "iCloud account status could not be determined."
			case .temporarilyUnavailable: "Currently unable to connect to iCloud account."
			case .noAccount: "Device not signed into iCloud."
			case .restricted: "Access to iCloud not allowed."
			case .available: "iCloud account connected."
			default: "iCloud account status could not be determined."
			}
			let syncStatus = icloudStatus == .available ? "Themes will sync across devices!" : "Themes will not be synced across devices."
			Section {
				let statusIcon = switch icloudStatus {
				case .couldNotDetermine: "xmark.icloud"
				case .temporarilyUnavailable: "bolt.horizontal.icloud"
				case .noAccount: "icloud.slash"
				case .restricted: "lock.icloud"
				case .available: "checkmark.icloud"
				default: "xmark.icloud"
				}
				let statusCategory = switch icloudStatus {
				case .couldNotDetermine: "Could not determine"
				case .temporarilyUnavailable: "Temporarily unavailable"
				case .noAccount: "No account"
				case .restricted: "Restricted"
				case .available: "Available"
				default: "Could not determine"
				}
#if os(macOS)
				VStack(alignment: .leading) {
					Label(statusCategory, systemImage: statusIcon)
					Text("\(statusDescription) \(syncStatus)")
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
#else
				Label(statusCategory, systemImage: statusIcon)
#endif
			} header: {
				Text("iCloud Status")
			} footer: {
#if !os(macOS)
				Text("\(statusDescription) \(syncStatus)")
#endif
			}
			.headerProminence(.increased)
			
#if !os(tvOS)
			Section("Themes Management") {
				ThemesManagementView()
			}
			.headerProminence(.increased)
#endif
			
			Section {
				VStack(alignment: .leading) {
					Text("Built using")
					Label("Swift • SwiftUI", systemImage: "swift")
					Label("SwiftData", systemImage: "swiftdata")
					Spacer()
					Label("Thanks for downloading!", systemImage: "heart")
				}
				.symbolVariant(.fill)
				.font(.footnote)
				.foregroundStyle(.secondary)
			}
			.listRowBackground(Color.clear)
		}
		.task {
			guard let accountStatus = try? await CKContainer.default().accountStatus() else {
				return
			}
			icloudStatus = accountStatus
		}
		.refreshable {
			guard let accountStatus = try? await CKContainer.default().accountStatus() else {
				return
			}
			icloudStatus = accountStatus
		}
		.navigationTitle("Settings")
	}
}
