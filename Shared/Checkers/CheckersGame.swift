//
//  CheckersGame.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/27/22.
//

import Foundation

class CheckersGame: ObservableObject {
	@Published var board = CheckersBoard()
	@Published var selectedSquare: CheckersSquare?
	var pieces: [CheckersPiece] {
		board.pieces.filter({ $0 != nil}) as! [CheckersPiece]
	}
	
	func reset() {
		CheckersState.reset()
		board = CheckersBoard()
	}
}
