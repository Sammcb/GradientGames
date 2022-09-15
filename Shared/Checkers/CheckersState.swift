//
//  CheckersState.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/27/22.
//

import Foundation

struct CheckersState: GameState {
	private init() {}
	
	static var shared = CheckersState()
	
	enum Key: String, CaseIterable {
		case pieces = "checkersPieces"
		case history = "checkersHistory"
		case times = "checkersTimes"
	}
	
	private let localStorage = UserDefaults.standard
	
	var pieces: CheckersPieces {
		get {
			get(forKey: .pieces) as! CheckersPieces
		}
		set {
			set(newValue, forKey: .pieces)
		}
	}
	var history: [CheckersMove] {
		get {
			get(forKey: .history) as! [CheckersMove]
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
		guard let object = value else {
			localStorage.setValue(nil, forKey: key.rawValue)
			return
		}
		
		let encodedData: Data?
		switch key {
		case .pieces:
			encodedData = try? JSONEncoder().encode(object as! CheckersPieces)
		case .history:
			encodedData = try? JSONEncoder().encode(object as! [CheckersMove])
		case .times:
			encodedData = try? JSONEncoder().encode(object as! Times)
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
				var pieces = CheckersPieces(repeating: nil, count: CheckersSizeRange.count * CheckersSizeRange.count)
				
				for row in 1...3 {
					for column in CheckersSizeRange.filter({ ($0 + row).isMultiple(of: 2) }) {
						pieces[column, row] = CheckersPiece(isLight: false)
					}
				}
				
				for row in 6...8 {
					for column in CheckersSizeRange.filter({ ($0 + row).isMultiple(of: 2) }) {
						pieces[column, row] = CheckersPiece(isLight: true)
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
			let state = try? JSONDecoder().decode(CheckersPieces.self, from: data)
			
			guard let state = state else {
				return error(key: key)
			}
			return state
		case .history:
			let data = localStorage.value(forKey: key.rawValue) as! Data
			let history = try? JSONDecoder().decode([CheckersMove].self, from: data)
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
