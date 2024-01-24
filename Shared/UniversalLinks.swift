//
//  UniversalLinks.swift
//  GradientGames
//
//  Created by Sam McBroom on 9/15/22.
//

import SwiftUI

enum ThemeLink: String {
	case chess = "/ChessColors/"
	case reversi = "/ReversiColors/"
	case checkers = "/CheckersColors/"
}

enum UniversalLinkParseError: Error {
	case componentError
	case typeError
}

enum ThemeField {
	case chess(String, Color, Color, Color, Color)
	case reversi(String, Color, Color, Color, Color)
	case checkers(String, Color, Color, Color, Color)
}

protocol UniversalLinkReciever: ColorConverter {}

extension UniversalLinkReciever {
	private func themeColorKeys(for linkType: ThemeLink) -> [String] {
		switch linkType {
		case .chess, .checkers:
			return ["pieceLight", "pieceDark", "squareLight", "squareDark"]
		case .reversi:
			return ["pieceLight", "pieceDark", "square", "border"]
		}
	}
	
	private func parseThemeLink(with queryItems: [URLQueryItem], type linkType: ThemeLink) throws -> ThemeField {
		guard let symbol = queryItems.first(where: { $0.name == "symbol" })?.value else {
			throw UniversalLinkParseError.componentError
		}
		
		let colorKeys = themeColorKeys(for: linkType)
		var colors: [Color] = []
		for key in colorKeys {
			guard let colorString = queryItems.first(where: { $0.name == key })?.value else {
				throw UniversalLinkParseError.componentError
			}
			
			let color = colorFrom(colorString)
			
			colors.append(color)
		}
		
		switch linkType {
		case .chess:
			return .chess(symbol, colors[0], colors[1], colors[2], colors[3])
		case .reversi:
			return .reversi(symbol, colors[0], colors[1], colors[2], colors[3])
		case .checkers:
			return .checkers(symbol, colors[0], colors[1], colors[2], colors[3])
		}
	}
	
	func parseUniversalLink(_ url: URL) throws -> ThemeField {
		guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			throw UniversalLinkParseError.componentError
		}
		
		guard let linkType = ThemeLink(rawValue: components.path) else {
			throw UniversalLinkParseError.typeError
		}
		
		let expectedQueryItemsCount = switch linkType {
		case .chess, .reversi, .checkers: 5
		}
		
		guard let queryItems = components.queryItems, queryItems.count == expectedQueryItemsCount else {
			throw UniversalLinkParseError.componentError
		}
		
		switch linkType {
		case .chess, .reversi, .checkers:
			return try parseThemeLink(with: queryItems, type: linkType)
		}
	}
}
