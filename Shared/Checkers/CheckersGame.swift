//
//  CheckersGame.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/27/22.
//

import Foundation

@Observable
class CheckersGame: Game {
	var board = CheckersBoard()
	var selectedSquare: CheckersSquare?
	var pieces: [CheckersPiece] {
		board.pieces.filter({ $0 != nil}) as! [CheckersPiece]
	}
	
	func reset() {
		CheckersState.shared.reset()
		board = CheckersBoard()
	}
}
