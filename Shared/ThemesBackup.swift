//
//  ThemesBackup.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/23/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ThemesDocument: FileDocument {
	static var readableContentTypes: [UTType] = [.json]
	var themes: [Theme] = []
	
	init(_ themes: [Theme] = []) {
		self.themes = themes
	}
	
	init(data: Data) throws {
		let backupThemes = try JSONDecoder().decode(BackupThemes.self, from: data)
		
		guard ThemesBackup.supportedThemeSchemaVersions.contains(backupThemes.schemaVersion) else {
			throw ThemesBackupError.versionUnsupported
		}
		
		self.themes = backupThemes.themes.map({ backupTheme in backupTheme.theme })
	}
	
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			self.init()
			return
		}
		
		try self.init(data: data)
	}
	
	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let backupThemes = BackupThemes(themes, schemaVersion: ThemesBackup.currentThemeSchemaVersion)
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let data = try encoder.encode(backupThemes)
		return FileWrapper(regularFileWithContents: data)
	}
}

private enum ThemesBackupError: Error {
	case versionUnsupported
}

struct ThemesBackup {
	private init() {}
	
	static let backupFileName = "themes.json"
	static let supportedThemeSchemaVersions = [1]
	static let currentThemeSchemaVersion = 1
}

private struct BackupThemes: Codable {
	struct BackupTheme: Codable {
		let index: Int
		let symbol: String
		let game: Theme.Game
		let colors: ThemeColors
		var theme: Theme {
			let themeFromBackup = Theme(game: game)
			themeFromBackup.symbol = symbol
			themeFromBackup.index = index
			themeFromBackup.colors = colors
			return themeFromBackup
		}
		
		init(_ theme: Theme) {
			self.index = theme.index
			self.symbol = theme.symbol
			self.game = theme.game
			self.colors = theme.colors
		}
	}
	
	let schemaVersion: Int
	let themes: [BackupTheme]
	
	init(_ themes: [Theme], schemaVersion: Int) {
		self.schemaVersion = schemaVersion
		self.themes = themes.map({ theme in BackupTheme(theme) })
	}
}
