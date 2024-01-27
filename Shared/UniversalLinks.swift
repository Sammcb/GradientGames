//
//  UniversalLinks.swift
//  GradientGames
//
//  Created by Sam McBroom on 9/15/22.
//

import SwiftUI

enum UniversalLinkParseError: Error {
	case pathError, componentsError, gameError, symbolError, countError, colorError
}

protocol UniversalLinkReciever: ColorConverter {}

extension UniversalLinkReciever {	
	func parseUniversalLink(_ url: URL) throws -> Theme {
		guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
			throw UniversalLinkParseError.componentsError
		}
		
		let themePath = "/GradientGamesTheme"
		guard components.path == themePath else {
			throw UniversalLinkParseError.pathError
		}
		
		guard let queryItems = components.queryItems else {
			throw UniversalLinkParseError.componentsError
		}
		
		let gameQueryName = "game"
		guard let queryGame = queryItems.first(where: { queryItem in queryItem.name == gameQueryName })?.value else {
			throw UniversalLinkParseError.gameError
		}
		
		guard let game = Theme.Game(rawValue: queryGame) else {
			throw UniversalLinkParseError.gameError
		}
		
		let expectedQueryItemsCount = switch game {
		case .chess, .reversi, .checkers: 6
		}
		
		guard queryItems.count == expectedQueryItemsCount else {
			throw UniversalLinkParseError.countError
		}
		
		let symbolQueryName = "symbol"
		guard let symbol = queryItems.first(where: { queryItem in queryItem.name == symbolQueryName })?.value else {
			throw UniversalLinkParseError.symbolError
		}
		
		let theme = Theme(game: game)
		theme.symbol = symbol
		
		var themeColors: ThemeColors = []
		for themeColor in theme.colors {
			guard let colorHex = queryItems.first(where: { queryItem in queryItem.name == themeColor.target.rawValue })?.value else {
				throw UniversalLinkParseError.colorError
			}
			
			let color = colorFrom(colorHex)
			let parsedThemeColor = ThemeColor(target: themeColor.target, color: color)
			themeColors.append(parsedThemeColor)
		}
		
		theme.colors = themeColors
		
		return theme
	}
}
