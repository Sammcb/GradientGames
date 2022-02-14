//
//  ChessState.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

struct ChessState {
	enum Key: String, CaseIterable {
		case pieces = "chessPieces"
		case history = "chessHistory"
		case times = "chessTimes"
	}
	
	private static let localStorage = UserDefaults.standard
	
	static var pieces: ChessPieces {
		get {
			get(forKey: .pieces) as! ChessPieces
		}
		set {
			set(newValue, forKey: .pieces)
		}
	}
	static var history: [ChessMove] {
		get {
			get(forKey: .history) as! [ChessMove]
		}
		set {
			set(newValue, forKey: .history)
		}
	}
	static var times: Times {
		get {
			get(forKey: .times) as! Times
		}
		set {
			set(newValue, forKey: .times)
		}
	}
	
	static func reset() {
		for key in Key.allCases {
			set(nil, forKey: key)
		}
	}
	
	private static func set(_ value: Any?, forKey key: Key) {
		guard let object = value else {
			localStorage.setValue(nil, forKey: key.rawValue)
			return
		}
		
		let encodedData: Data?
		switch key {
		case .pieces:
			encodedData = try? JSONEncoder().encode(object as! ChessPieces)
		case .history:
			encodedData = try? JSONEncoder().encode(object as! [ChessMove])
		case .times:
			encodedData = try? JSONEncoder().encode(object as! Times)
		}
		localStorage.setValue(encodedData, forKey: key.rawValue)
	}
	
	private static func error(key: Key) -> Any {
		reset()
		return get(forKey: key)
	}
	
	private static func get(forKey key: Key) -> Any {
		if localStorage.value(forKey: key.rawValue) == nil {
			switch key {
			case .pieces:
				var pieces = ChessPieces(repeating: nil, count: ChessFile.validFiles.count * ChessRanks.count)
				
				for rank in [1, 8] {
					pieces[.a, rank] = ChessPiece(isLight: rank == 1, group: .rook)
					pieces[.b, rank] = ChessPiece(isLight: rank == 1, group: .knight)
					pieces[.c, rank] = ChessPiece(isLight: rank == 1, group: .bishop)
					pieces[.d, rank] = ChessPiece(isLight: rank == 1, group: .queen)
					pieces[.e, rank] = ChessPiece(isLight: rank == 1, group: .king)
					pieces[.f, rank] = ChessPiece(isLight: rank == 1, group: .bishop)
					pieces[.g, rank] = ChessPiece(isLight: rank == 1, group: .knight)
					pieces[.h, rank] = ChessPiece(isLight: rank == 1, group: .rook)
				}
				
				for rank in [2, 7] {
					for file in ChessFile.validFiles {
						pieces[file, rank] = ChessPiece(isLight: rank == 2, group: .pawn)
					}
				}
				
				return pieces
			case .history:
				return []
			case .times:
				return Times(light: 0, dark: 0, lastUpdate: .now)
			}
		}
		
		switch key {
		case .pieces:
			let data = localStorage.value(forKey: key.rawValue) as! Data
			let state = try? JSONDecoder().decode(ChessPieces.self, from: data)
			
			guard let state = state else {
				return error(key: key)
			}
			return state
		case .history:
			let data = localStorage.value(forKey: key.rawValue) as! Data
			let history = try? JSONDecoder().decode([ChessMove].self, from: data)
			guard let history = history else {
				return error(key: key)
			}
			return history
		case .times:
			let data = localStorage.value(forKey: key.rawValue) as! Data
			let times = try? JSONDecoder().decode(Times.self, from: data)
			guard let times = times else {
				return error(key: key)
			}
			return times
		}
	}
}
