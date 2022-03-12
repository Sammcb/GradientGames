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
		case chessFlipPieces
		case reversiEnableUndo
		case reversiEnableTimer
		case checkersEnableUndo
		case checkersEnableTimer
	}
	
	private enum InternalKey: String {
		case chessTheme
		case reversiTheme
		case checkersTheme
	}
	
	@Published var chessThemeId: UUID?
	@Published var reversiThemeId: UUID?
	@Published var checkersThemeId: UUID?
	private var chessThemeIdSubscriber: AnyCancellable?
	private var reversiThemeIdSubscriber: AnyCancellable?
	private var checkersThemeIdSubscriber: AnyCancellable?
	private let localStorage = UserDefaults.standard
	
	init() {
		if let chessIdString = localStorage.string(forKey: InternalKey.chessTheme.rawValue), let chessThemeId = UUID(uuidString: chessIdString) {
			self.chessThemeId = chessThemeId
		}
		
		if let reversiIdString = localStorage.string(forKey: InternalKey.reversiTheme.rawValue), let reversiThemeId = UUID(uuidString: reversiIdString) {
			self.reversiThemeId = reversiThemeId
		}
		
		if let checkersIdString = localStorage.string(forKey: InternalKey.checkersTheme.rawValue), let checkersThemeId = UUID(uuidString: checkersIdString) {
			self.checkersThemeId = checkersThemeId
		}
		
		chessThemeIdSubscriber = $chessThemeId.sink { value in
			self.set(value, forKey: .chessTheme)
		}
		
		reversiThemeIdSubscriber = $reversiThemeId.sink { value in
			self.set(value, forKey: .reversiTheme)
		}
		
		checkersThemeIdSubscriber = $checkersThemeId.sink { value in
			self.set(value, forKey: .checkersTheme)
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
		case .checkersTheme:
			guard let checkersThemeId = value as? UUID else  {
				localStorage.set(nil, forKey: key.rawValue)
				return
			}
			localStorage.set(checkersThemeId.uuidString, forKey: key.rawValue)
		}
	}
}
