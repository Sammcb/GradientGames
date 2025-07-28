//
//  ThemesManagementView.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/24/24.
//

#if !os(tvOS)
import SwiftUI
import SwiftData

struct ThemesManagementView: View {
	@Environment(\.modelContext) private var context
	@Query(sort: \Theme.index) private var themes: [Theme]
	@State private var exportThemes = false
	@State private var importThemes = false
	@State private var showImportStatusAlert = false
	@State private var importStatusMessage = ""
	@State private var showDeleteConfirmation = false
	
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
			
			for (index, themeData) in document.themes.enumerated() {
				let importIndex = themesCount + index
				let theme = Theme(index: importIndex, symbol: themeData.symbol, game: themeData.game, colors: themeData.colors)
				context.insert(theme)
			}
			return true
		case .failure(_):
			return false
		}
	}
	
	var body: some View {
		Group {
			Button {
				exportThemes.toggle()
				print("OKDEBUG \(exportThemes)")
			} label: {
				Label("Export All Themes", systemImage: "arrow.up.doc")
			}
			Button {
				importThemes.toggle()
			} label: {
				Label("Import Themes", systemImage: "square.and.arrow.down")
			}
			Button(role: .destructive) {
				showDeleteConfirmation.toggle()
			} label: {
				Label("Delete All Themes", systemImage: "trash")
					.foregroundStyle(.red)
			}
		}
		.fileExporter(isPresented: $exportThemes, document: ThemesDocument(themes), contentType: .json, defaultFilename: ThemesBackup.fileName) { _ in }
		.fileImporter(isPresented: $importThemes, allowedContentTypes: [.json]) { result in
			let importSucceeded = importThemes(for: result, context: context, themesCount: themes.count)
			importStatusMessage = importSucceeded ? "Import succeeded" : "Import failed"
			showImportStatusAlert = true
		}
		.alert(importStatusMessage, isPresented: $showImportStatusAlert) {
			Button("OK", role: .cancel, action: {})
				.keyboardShortcut(.defaultAction)
		}
		.confirmationDialog("Are you sure you want to delete all your themes?", isPresented: $showDeleteConfirmation) {
			Button(role: .destructive) {
				themes.forEach({ theme in context.delete(theme) })
			} label: {
				Label("Delete All Themes", systemImage: "trash")
			}
		}
	}
}
#endif
