//
//  ReversiState.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

struct ReversiState {
	private init() {}
	
	static var shared = ReversiState()
	
	enum Key: String, CaseIterable {
		case pieces = "reversiPieces"
		case history = "reversiHistory"
		case times = "reversiTimes"
	}
	
	private let localStorage = UserDefaults.standard
	
	var pieces: ReversiPieces {
		get {
			get(forKey: .pieces) as! ReversiPieces
		}
		set {
			set(newValue, forKey: .pieces)
		}
	}
	var history: [ReversiMove] {
		get {
			get(forKey: .history) as! [ReversiMove]
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
			encodedData = try? JSONEncoder().encode(value as! ReversiPieces)
		case .history:
			encodedData = try? JSONEncoder().encode(value as! [ReversiMove])
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
				var pieces = ReversiPieces(repeating: nil, count: ReversiSizeRange.count * ReversiSizeRange.count)
				
				pieces[4, 4] = ReversiPiece(isLight: false)
				pieces[5, 4] = ReversiPiece(isLight: true)
				pieces[5, 5] = ReversiPiece(isLight: false)
				pieces[4, 5] = ReversiPiece(isLight: true)
				
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
			let state = try? JSONDecoder().decode(ReversiPieces.self, from: data)
			
			guard let state else {
				return error(key: key)
			}
			return state
		case .history:
			let data = localStorage.value(forKey: key.rawValue) as! Data
			let history = try? JSONDecoder().decode([ReversiMove].self, from: data)
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
