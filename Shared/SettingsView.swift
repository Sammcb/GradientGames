//
//  SettingsView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI
import SwiftData
import CloudKit

struct SettingsView: View {
	@Environment(\.modelContext) private var context
	@Query(sort: \Theme.index) private var themes: [Theme]
	@AppStorage(Setting.enableUndo.rawValue) private var enableUndo = true
	@AppStorage(Setting.enableTimer.rawValue) private var enableTimer = false
	@AppStorage(Setting.flipUI.rawValue) private var flipUI = false
	@AppStorage(Setting.showMoves.rawValue) private var showMoves = true
	@State private var icloudStatus: CKAccountStatus = .couldNotDetermine
	@State private var exportThemes = false
	@State private var importThemes = false
	@State private var showImportStatusAlert = false
	@State private var importStatusMessage = ""
	
	private func importThemesSucceeded(for importFileResult: Result<URL, Error>) -> Bool {
		switch importFileResult {
		case .success(let url):
			guard url.startAccessingSecurityScopedResource() else {
				return false
			}
			
			defer {
				url.stopAccessingSecurityScopedResource()
			}
			
			guard let data = try? Data(contentsOf: url) else {
				return false
			}
			
			guard let document = try? ThemesDocument(data: data) else {
				return false
			}

			for theme in document.themes {
				let index = themes.count
				theme.index = index
				context.insert(theme)
			}
			return true
		case .failure(_):
			return false
		}
	}
	
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
			
			#if os(macOS)
			Button {
				exportThemes.toggle()
			} label: {
				Label("Export All Themes", systemImage: "arrow.up.doc.fill")
			}
			Button {
				importThemes.toggle()
			} label: {
				Label("Import Themes", systemImage: "square.and.arrow.down")
			}
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
		#if os(iOS)
		.toolbar {
			ToolbarItem {
				Menu {
					Button {
						exportThemes.toggle()
					} label: {
						Label("Export All Themes", systemImage: "arrow.up.doc")
					}
					Button {
						importThemes.toggle()
					} label: {
						Label("Import Themes", systemImage: "square.and.arrow.down")
					}
				} label: {
					Label("Actions", systemImage: "ellipsis")
						.symbolVariant(.circle)
				}
			}
		}
#endif
		.fileExporter(isPresented: $exportThemes, document: ThemesDocument(themes), contentType: .json, defaultFilename: ThemesBackup.backupFileName) { _ in }
		.fileImporter(isPresented: $importThemes, allowedContentTypes: [.json]) { result in
			let importSucceeded = importThemesSucceeded(for: result)
			importStatusMessage = importSucceeded ? "Import succeeded" : "Import failed"
			showImportStatusAlert = true
		}
		.alert(importStatusMessage, isPresented: $showImportStatusAlert) {
			Button("OK", role: .cancel, action: {})
				.keyboardShortcut(.defaultAction)
		}
	}
}
