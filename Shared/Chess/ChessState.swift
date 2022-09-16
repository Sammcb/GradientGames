//
//  ChessState.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

struct ChessState: GameState {
	private init() {}
	
	static var shared = ChessState()
	
	enum Key: String, CaseIterable {
		case pieces = "chessPieces"
		case history = "chessHistory"
		case times = "chessTimes"
	}
	
	private let localStorage = UserDefaults.standard
	
	var pieces: ChessPieces {
		get {
			get(forKey: .pieces) as! ChessPieces
		}
		set {
			set(newValue, forKey: .pieces)
		}
	}
	var history: [ChessMove] {
		get {
			get(forKey: .history) as! [ChessMove]
		}
		set {
			set(newValue, forKey: .history)
		}
	}
	var times: Times {
		get {
			get(forKey: .times) as! Times
		}
		set {
			set(newValue, forKey: .times)
		}
	}
	
	func reset() {
		for key in Key.allCases {
			set(nil, forKey: key)
		}
	}
	
	private func set(_ value: Any?, forKey key: Key) {
		guard let value else {
			localStorage.setValue(nil, forKey: key.rawValue)
			return
		}
		
		let encodedData: Data?
		switch key {
		case .pieces:
			encodedData = try? JSONEncoder().encode(value as! ChessPieces)
		case .history:
			encodedData = try? JSONEncoder().encode(value as! [ChessMove])
		case .times:
			encodedData = try? JSONEncoder().encode(value as! Times)
		}
		localStorage.setValue(encodedData, forKey: key.rawValue)
	}
	
	private func error(key: Key) -> Any {
		reset()
		return get(forKey: key)
	}
	
	private func get(forKey key: Key) -> Any {
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
			
			guard let state else {
				return error(key: key)
			}
			return state
		case .history:
			let data = localStorage.value(forKey: key.rawValue) as! Data
			let history = try? JSONDecoder().decode([ChessMove].self, from: data)
			guard let history else {
				return error(key: key)
			}
			return history
		case .times:
			let data = localStorage.value(forKey: key.rawValue) as! Data
			let times = try? JSONDecoder().decode(Times.self, from: data)
			guard let times else {
				return error(key: key)
			}
			return times
		}
	}
}
