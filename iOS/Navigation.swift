//
//  Navigation.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

class Navigation: ObservableObject {
	enum ViewId: String, Identifiable {
		case settings
		case chess
		case reversi
		
		var id: String {
			self.rawValue
		}
	}
	
	enum SheetId: String, Identifiable {
		case newChess
		case newReversi
		
		var id: String {
			self.rawValue
		}
	}
	
	@Published var view: ViewId?
	@Published var editing: UUID?
	@Published var sheet: SheetId?
}
