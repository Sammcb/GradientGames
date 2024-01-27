//
//  ThemeV1.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/27/24.
//

import SwiftData
import SwiftUI

enum ThemeSchemaV1: VersionedSchema {
	static var models: [any PersistentModel.Type] = [Theme.self]
	static var versionIdentifier = Schema.Version(0, 0, 1)
	
	@Model
	class Theme: ColorConverter {
		enum Game: String, Codable {
			case chess, reversi, checkers
		}
		
		// CloudKit currently does not support unique attribute
		//	@Attribute(.unique) let id = UUID()
		let id = UUID()
		var index = 0
		var symbol = ""
		var game = Game.chess
		
		var colors: ThemeColors = []
		
		init(game: Game) {
			self.game = game
			let colorTargets: [ThemeColor.Target] = switch game {
			case .chess: [.pieceLight, .pieceDark, .squareLight, .squareDark]
			case .reversi: [.pieceLight, .pieceDark, .squares, .borders]
			case .checkers: [.pieceLight, .pieceDark, .squareLight, .squareDark]
			}
			self.colors = colorTargets.map({ target in ThemeColor(target: target) })
		}
		
		static var defaultChessTheme: Theme {
			let theme = Theme.init(game: .chess)
			theme.symbol = "🌑"
			let pieceLight = ThemeColor(target: .pieceLight, color: .white)
			let pieceDark = ThemeColor(target: .pieceDark, color: .black)
			let squareLightColor = Color(red: 192 / 255, green: 192 / 255, blue: 192 / 255)
			let squareLight = ThemeColor(target: .squareLight, color: squareLightColor)
			let squareDarkColor = Color(red: 96 / 255, green: 96 / 255, blue: 96 / 255)
			let squareDark = ThemeColor(target: .squareDark, color: squareDarkColor)
			theme.colors = [pieceLight, pieceDark, squareLight, squareDark]
			return theme
		}
		
		static var defaultReversiTheme: Theme {
			let theme = Theme.init(game: .reversi)
			theme.symbol = "🥝"
			let pieceLight = ThemeColor(target: .pieceLight, color: .white)
			let pieceDark = ThemeColor(target: .pieceDark, color: .black)
			let squaresColor = Color(red: 32 / 255, green: 168 / 255, blue: 96 / 255)
			let squares = ThemeColor(target: .squares, color: squaresColor)
			let bordersColor = Color(red: 68 / 255, green: 220 / 255, blue: 138 / 255)
			let borders = ThemeColor(target: .borders, color: bordersColor)
			theme.colors = [pieceLight, pieceDark, squares, borders]
			return theme
		}
		
		static var defaultCheckersTheme: Theme {
			let theme = Theme.init(game: .checkers)
			theme.symbol = "☕️"
			let pieceLightColor = Color(red: 230 / 255, green: 212 / 255, blue: 162 / 255)
			let pieceLight = ThemeColor(target: .pieceLight, color: pieceLightColor)
			let pieceDarkColor = Color(red: 64 / 255, green: 57 / 255, blue: 52 / 255)
			let pieceDark = ThemeColor(target: .pieceDark, color: pieceDarkColor)
			let squareLightColor = Color(red: 196 / 255, green: 180 / 255, blue: 151 / 255)
			let squareLight = ThemeColor(target: .squareLight, color: squareLightColor)
			let squareDarkColor = Color(red: 168 / 255, green: 128 / 255, blue: 99 / 255)
			let squareDark = ThemeColor(target: .squareDark, color: squareDarkColor)
			theme.colors = [pieceLight, pieceDark, squareLight, squareDark]
			return theme
		}
	}
}
