//
//  ReversiGame.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

class ReversiGame: ObservableObject {
	@Published var board = ReversiBoard()
	var pieces: [ReversiPiece] {
		board.pieces.filter({ $0 != nil}) as! [ReversiPiece]
	}
	
	func reset() {
		ReversiState.shared.reset()
		board = ReversiBoard()
	}
}
