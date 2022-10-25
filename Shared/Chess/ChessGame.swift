//
//  ChessGame.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation
class ChessGame: ObservableObject, Game {
	@Published var board = ChessBoard()
	@Published var selectedSquare: ChessSquare?
	@Published var pawnSquare: ChessSquare?
	var pieces: [ChessPiece] {
		board.pieces.filter({ $0 != nil}) as! [ChessPiece]
	}
	private var lastCheckedMove: ChessMove?
	private var lastCheckedLight = true
	private var kingState: ChessBoard.State = .ok
	
	func kingState(isLight: Bool) -> ChessBoard.State {
		if board.history.last == lastCheckedMove && lastCheckedLight == isLight {
			return kingState
		}
		lastCheckedMove = board.history.last
		lastCheckedLight = isLight
		var checkingBoard = board
		kingState = checkingBoard.kingState(isLight: isLight)
		return kingState
	}
	
	func reset() {
		ChessState.shared.reset()
		board = ChessBoard()
		selectedSquare = nil
		pawnSquare = nil
	}
}
