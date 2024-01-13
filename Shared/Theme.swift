//
//  Theme.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/9/24.
//

import SwiftData
import SwiftUI

struct ThemeColor: Codable, Identifiable, ColorConverter {
	enum Target: String, Codable, Comparable {
		static func <(lhs: Target, rhs: Target) -> Bool {
			lhs.rawValue < rhs.rawValue
		}
		
		case pieceLight, pieceDark, squareLight, squareDark, squares, borders
		
		var displayName: String {
			switch self {
			case .pieceLight: "Light pieces"
			case .pieceDark: "Dark pieces"
			case .squareLight: "Light squares"
			case .squareDark: "Dark squares"
			case .squares: "Squares"
			case .borders: "Borders"
			}
		}
	}
	
	let target: Target
	var color: Color = .clear
	
	var id: Target {
		target
	}
	
	private enum CodingKeys: String, CodingKey {
		case target, color
	}
	
	init(target: Target) {
		self.target = target
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		target = try values.decode(Target.self, forKey: .target)
		let colorString = try values.decode(String.self, forKey: .color)
		color = colorFrom(colorString)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(target, forKey: .target)
		let colorString = hexFrom(color)
		try container.encode(colorString, forKey: .color)
	}
}

typealias ThemeColors = [ThemeColor]

extension ThemeColors {
	subscript(target: ThemeColor.Target) -> Color {
		get {
			self.first(where: { $0.target == target})?.color ?? .clear
		}
	}
}

@Model
class Theme: ColorConverter {
	enum Game: String, Codable {
		case chess, reversi, checkers
	}
	
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
}

