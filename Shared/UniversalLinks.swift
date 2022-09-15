//
//  UniversalLinks.swift
//  GradientGames
//
//  Created by Sam McBroom on 9/15/22.
//

import Foundation

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
	case chess(String, Int64, Int64, Int64, Int64)
	case reversi(String, Int64, Int64, Int64, Int64)
	case checkers(String, Int64, Int64, Int64, Int64)
}
