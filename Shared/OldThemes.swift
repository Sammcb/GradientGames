//
//  OldThemes.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/27/24.
//

// TODO: Delete after most users have updated to 2.0.0

import SwiftUI
import SwiftData

@Model
final class ChessTheme {
	var id: UUID?
	var index: Int64 = 0
	var pieceDarkRaw: Int64 = 0
	var pieceLightRaw: Int64 = 0
	var squareDarkRaw: Int64 = 0
	var squareLightRaw: Int64 = 0
	var symbol: String = ""
	init() {}
}

@Model
final class CheckersTheme {
	var id: UUID?
	var index: Int64 = 0
	var pieceDarkRaw: Int64 = 0
	var pieceLightRaw: Int64 = 0
	var squareDarkRaw: Int64 = 0
	var squareLightRaw: Int64 = 0
	var symbol: String = ""
	init() {}
}

@Model
final class ReversiTheme {
	var borderRaw: Int64 = 0
	var id: UUID?
	var index: Int64 = 0
	var pieceDarkRaw: Int64 = 0
	var pieceLightRaw: Int64 = 0
	var squareRaw: Int64 = 0
	var symbol: String = ""
	init() {}
}

@MainActor
struct MigrateOldThemes {
	private init() {}
	
	static private var migratedIds: [UUID] = []
	
	static private func getColor(from hex: Int64) -> Color {
		let uhex = UInt32(hex)
		let red = (uhex & 0xff0000) >> 16
		let green = (uhex & 0x00ff00) >> 8
		let blue = uhex & 0x0000ff
		return Color.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, opacity: 1)
	}
	
	static func migrate(_ context: ModelContext) {
		let chessThemes = try? context.fetch(FetchDescriptor<ChessTheme>())
		let reversiThemes = try? context.fetch(FetchDescriptor<ReversiTheme>())
		let checkersThemes = try? context.fetch(FetchDescriptor<CheckersTheme>())
		
		for chessTheme in chessThemes ?? [] {
			guard let chessId = chessTheme.id, !migratedIds.contains(chessId) else {
				continue
			}
			let theme = Theme(game: .chess)
			theme.symbol = chessTheme.symbol
			theme.index = Int(chessTheme.index)
			let pieceLightColor = getColor(from: chessTheme.pieceLightRaw)
			let pieceDarkColor = getColor(from: chessTheme.pieceDarkRaw)
			let squareLightColor = getColor(from: chessTheme.squareLightRaw)
			let squareDarkColor = getColor(from: chessTheme.squareDarkRaw)
			theme.colors = [ThemeColor(target: .pieceLight, color: pieceLightColor), ThemeColor(target: .pieceDark, color: pieceDarkColor), ThemeColor(target: .squareLight, color: squareLightColor), ThemeColor(target: .squareDark, color: squareDarkColor)]
			context.insert(theme)
			context.delete(chessTheme)
			migratedIds.append(chessId)
		}
		
		for reversiTheme in reversiThemes ?? [] {
			guard let reversiId = reversiTheme.id, !migratedIds.contains(reversiId) else {
				continue
			}
			let theme = Theme(game: .reversi)
			theme.symbol = reversiTheme.symbol
			theme.index = Int(reversiTheme.index)
			let pieceLightColor = getColor(from: reversiTheme.pieceLightRaw)
			let pieceDarkColor = getColor(from: reversiTheme.pieceDarkRaw)
			let squareColor = getColor(from: reversiTheme.squareRaw)
			let borderColor = getColor(from: reversiTheme.borderRaw)
			theme.colors = [ThemeColor(target: .pieceLight, color: pieceLightColor), ThemeColor(target: .pieceDark, color: pieceDarkColor), ThemeColor(target: .squares, color: squareColor), ThemeColor(target: .borders, color: borderColor)]
			context.insert(theme)
			context.delete(reversiTheme)
			migratedIds.append(reversiId)
		}
		
		for checkersTheme in checkersThemes ?? [] {
			guard let checkersId = checkersTheme.id, !migratedIds.contains(checkersId) else {
				continue
			}
			let theme = Theme(game: .checkers)
			theme.symbol = checkersTheme.symbol
			theme.index = Int(checkersTheme.index)
			let pieceLightColor = getColor(from: checkersTheme.pieceLightRaw)
			let pieceDarkColor = getColor(from: checkersTheme.pieceDarkRaw)
			let squareLightColor = getColor(from: checkersTheme.squareLightRaw)
			let squareDarkColor = getColor(from: checkersTheme.squareDarkRaw)
			theme.colors = [ThemeColor(target: .pieceLight, color: pieceLightColor), ThemeColor(target: .pieceDark, color: pieceDarkColor), ThemeColor(target: .squareLight, color: squareLightColor), ThemeColor(target: .squareDark, color: squareDarkColor)]
			context.insert(theme)
			context.delete(checkersTheme)
			migratedIds.append(checkersId)
		}
		
		try? context.save()
	}
}
