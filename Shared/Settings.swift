//
//  Settings.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation
import Combine

class Settings: ObservableObject {
	enum Key: String {
		case chessEnableUndo
		case chessEnableTimer
		case reversiEnableUndo
		case reversiEnableTimer
	}
	
	private enum InternalKey: String {
		case chessTheme
		case reversiTheme
	}
	
	@Published var chessThemeId: UUID?
	@Published var reversiThemeId: UUID?
	private var chessThemeIdSubscriber: AnyCancellable?
	private var reversiThemeIdSubscriber: AnyCancellable?
	private let localStorage = UserDefaults.standard
	
	init() {
		if let chessIdString = localStorage.string(forKey: InternalKey.chessTheme.rawValue), let chessThemeId = UUID(uuidString: chessIdString) {
			self.chessThemeId = chessThemeId
		}
		
		if let reversiIdString = localStorage.string(forKey: InternalKey.reversiTheme.rawValue), let reversiThemeId = UUID(uuidString: reversiIdString) {
			self.reversiThemeId = reversiThemeId
		}
		
		
		chessThemeIdSubscriber = $chessThemeId.sink { value in
			self.set(value, forKey: .chessTheme)
		}
		
		reversiThemeIdSubscriber = $reversiThemeId.sink { value in
			self.set(value, forKey: .reversiTheme)
		}
	}
	
	private func set(_ value: Any?, forKey key: InternalKey) {
		switch key {
		case .chessTheme:
			guard let chessThemeId = value as? UUID else {
				localStorage.set(nil, forKey: key.rawValue)
				return
			}
			localStorage.set(chessThemeId.uuidString, forKey: key.rawValue)
		case .reversiTheme:
			guard let reversiThemeId = value as? UUID else {
				localStorage.set(nil, forKey: key.rawValue)
				return
			}
			localStorage.set(reversiThemeId.uuidString, forKey: key.rawValue)
		}
	}
}
