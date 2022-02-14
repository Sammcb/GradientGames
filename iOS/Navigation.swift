//
//  Navigation.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

//struct Sheet: Identifiable {
//	let id: Id
//
//	enum Id {
//		case share
//		case newChess
//		case importChess
//		case newReversi
//		case importReversi
//	}
//}

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
		case share
		case newChess
		case importChess
		case newReversi
		case importReversi
		
		var id: String {
			self.rawValue
		}
	}
	
	@Published var view: ViewId?
	@Published var editingId: UUID?
	@Published var showAlert = false
	@Published var sheet: SheetId?
	
	@Published var chessSymbol = ""
	@Published var chessSquareLight: Color = .clear
	@Published var chessSquareDark: Color = .clear
	@Published var chessPieceLight: Color = .clear
	@Published var chessPieceDark: Color = .clear
	
	@Published var reversiSymbol = ""
	@Published var reversiSquare: Color = .clear
	@Published var reversiBorder: Color = .clear
	@Published var reversiPieceLight: Color = .clear
	@Published var reversiPieceDark: Color = .clear
}
