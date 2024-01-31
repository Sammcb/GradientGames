//
//  ThemesDocument.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/23/24.
//

#if !os(tvOS)
import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ThemesDocument: FileDocument {
	static var readableContentTypes: [UTType] = [.json]
	var themes: [Theme] = []
	
	init(_ themes: [Theme] = []) {
		self.themes = themes
	}
	
	init(data: Data) throws {
		let backupThemes = try JSONDecoder().decode(BackupThemes.self, from: data)
		
		guard ThemesBackup.supportedSchemaVersions.contains(backupThemes.schemaVersion) else {
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
		let backupThemes = BackupThemes(themes, schemaVersion: ThemesBackup.currentSchemaVersion)
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
	static let supportedSchemaVersions = [Schema.Version(1, 0, 0)]
	static let currentSchemaVersion = Schema.Version(1, 0, 0)
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
	
	let schemaVersion: Schema.Version
	let themes: [BackupTheme]
	
	init(_ themes: [Theme], schemaVersion: Schema.Version) {
		self.schemaVersion = schemaVersion
		self.themes = themes.map({ theme in BackupTheme(theme) })
	}
}
#endif
