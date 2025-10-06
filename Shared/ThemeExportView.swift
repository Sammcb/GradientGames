//
//  ThemeExportView.swift
//  GradientGames
//
//  Created by Sam McBroom on 8/1/25.
//

#if !os(tvOS)
import SwiftUI
import SwiftData

struct ThemeExportView: View {
	@Environment(\.modelContext) private var context
	@Query(sort: \Theme.index) private var themes: [Theme]
	@State private var exportThemes = false

	var body: some View {
		Button {
			exportThemes.toggle()
		} label: {
			Label("Export All Themes", systemImage: "arrow.up.doc")
		}
		.fileExporter(isPresented: $exportThemes, document: ThemesDocument(themes), contentType: .json, defaultFilename: ThemesBackup.fileName) { _ in }
	}
}
#endif
