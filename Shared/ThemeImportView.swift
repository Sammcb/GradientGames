//
//  ThemeImportView.swift
//  GradientGames
//
//  Created by Sam McBroom on 8/1/25.
//

import SwiftUI
import SwiftData

struct ThemeImportView: View {
	@Environment(\.modelContext) private var context
	@Query(sort: \Theme.index) private var themes: [Theme]
	@State private var importThemes = false
	@State private var showImportStatusAlert = false
	@State private var importStatusMessage = ""
	@State private var themesDataJSON = ""

	private func importThemes(_ themes: [ThemeData], context: ModelContext, themesCount: Int) {
		for (index, themeData) in themes.enumerated() {
			let importIndex = themesCount + index
			let theme = Theme(index: importIndex, symbol: themeData.symbol, game: themeData.game, colors: themeData.colors)
			context.insert(theme)
		}
	}

#if !os(tvOS)
	private func importThemes(for importFileResult: Result<URL, Error>, context: ModelContext, themesCount: Int) -> Bool {
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

			importThemes(document.themes, context: context, themesCount: themesCount)
			return true
		case .failure(_):
			return false
		}
	}
#endif

	private func importThemes(from jsonData: String, context: ModelContext) -> Bool {
		guard let themesData = jsonData.data(using: .utf8) else {
			return false
		}

		guard let backup = try? JSONDecoder().decode(ThemeBackupData.self, from: themesData) else {
			return false
		}

		guard ThemesBackup.supportedSchemaVersions.contains(backup.schemaVersion) else {
			return false
		}

		importThemes(backup.themes, context: context, themesCount: themes.count)
		return true
	}

	var body: some View {
		Group {
#if !os(tvOS)
			Button {
				importThemes.toggle()
			} label: {
				Label("Import Themes File", systemImage: "arrow.down.doc")
			}
			.fileImporter(isPresented: $importThemes, allowedContentTypes: [.json]) { result in
				let importSucceeded = importThemes(for: result, context: context, themesCount: themes.count)
				importStatusMessage = importSucceeded ? "Import succeeded" : "Import failed"
				showImportStatusAlert = true
			}
#endif
			TextField(text: $themesDataJSON, prompt: Text("Theme Data JSON")) {
				Label("Import Themes Data", systemImage: "ellipsis.curlybraces")
			}
			.onSubmit {
				guard !themesDataJSON.isEmpty else {
					return
				}
				let importSucceeded = importThemes(from: themesDataJSON, context: context)
				themesDataJSON = ""
				importStatusMessage = importSucceeded ? "Import succeeded" : "Import failed"
				showImportStatusAlert = true
			}
			.lineLimit(1)
			.autocorrectionDisabled()
		}
		.alert(importStatusMessage, isPresented: $showImportStatusAlert) {
			Button("OK", role: .cancel, action: {})
#if !os(tvOS)
				.keyboardShortcut(.defaultAction)
#endif
		}
	}
}
