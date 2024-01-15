//
//  Chess.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/14/24.
//

import Foundation

struct Chess {
	private init() {}
	
	enum KingState {
		case ok, check, checkmate, stalemate
	}
	
	typealias KingStates = (light: KingState, dark: KingState)
	
	enum File: Int, CaseIterable, Comparable, Codable, Identifiable {
		case none, a, b, c, d, e, f, g, h
		
		static var validFiles: [Self] {
			Array(Self.allCases.dropFirst())
		}
		
		static func +(lhs: Self, rhs: Int) -> Self {
			Self(rawValue: lhs.rawValue + rhs) ?? .none
		}
		
		static func -(lhs: Self, rhs: Int) -> Self {
			Self(rawValue: lhs.rawValue - rhs) ?? .none
		}
		
		static func <(lhs: Self, rhs: Self) -> Bool {
			lhs.rawValue < rhs.rawValue
		}
		
		static func +=(lhs: inout Self, rhs: Int) {
			lhs = lhs + rhs
		}
		
		var id: Int {
			rawValue
		}
		
		func delta(file: Self) -> Int {
			rawValue - file.rawValue
		}
	}
	
	static let Ranks = 1...8
	
	typealias Pieces = [Chess.Piece?]
}

extension Chess.Pieces {
	subscript(file: Chess.File, rank: Int) -> Element {
		get {
			self[(file.rawValue - 1) * 8 + rank - 1]
		}
		
		set {
			self[(file.rawValue - 1) * 8 + rank - 1] = newValue
		}
	}
	
	subscript(square: Chess.Square) -> Element {
		get {
			self[square.file, square.rank]
		}
		
		set {
			self[square.file, square.rank] = newValue
		}
	}
	
	static func square(at index: Int) -> Chess.Square {
		Chess.Square(file: Chess.File(rawValue: index / 8 + 1) ?? .none, rank: index % 8 + 1)
	}
}
