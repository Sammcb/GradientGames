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

private enum ThemesBackupError: Error {
	case versionUnsupported
}

struct ThemesBackup {
	private init() {}
	
	static let fileName = "themes.json"
	static var supportedSchemaVersions: [Schema.Version] {
		[.init(1, 0, 0)]
	}
//	static let currentSchemaVersion = SemanticVersion(1, 0, 0)
	static var currentSchemaVersion: Schema.Version {
		.init(1, 0, 0)
	}
}

struct ThemeData: Codable {
	let index: Int
	let symbol: String
	let game: Theme.Game
	let colors: ThemeColors
	
	init(_ theme: Theme) {
		self.index = theme.index
		self.symbol = theme.symbol
		self.game = theme.game
		self.colors = theme.colors
	}
}

struct ThemeBackupData: Codable {
	let schemaVersion: Schema.Version
	let themes: [ThemeData]
	
	init(schemaVersion: Schema.Version, themes: [ThemeData]) {
		self.schemaVersion = schemaVersion
		self.themes = themes
	}
}

struct ThemesDocument: FileDocument {
	static var readableContentTypes: [UTType] {
		[.json]
	}
	
	var themes: [ThemeData] = []
	
	init(_ themes: [Theme] = []) {
		self.themes = themes.map({ theme in ThemeData(theme) })
	}
	
	init(data: Data) throws {
		let backup = try JSONDecoder().decode(ThemeBackupData.self, from: data)
		
		guard ThemesBackup.supportedSchemaVersions.contains(backup.schemaVersion) else {
			throw ThemesBackupError.versionUnsupported
		}
		
		self.themes = backup.themes
	}
	
	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			self.init()
			return
		}
		
		try self.init(data: data)
	}
	
	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let backup = ThemeBackupData(schemaVersion: ThemesBackup.currentSchemaVersion, themes: themes)
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let data = try encoder.encode(backup)
		return FileWrapper(regularFileWithContents: data)
	}
}
#endif
