//
//  ChessTests.swift
//  GradientGames
//
//  Created by Sam McBroom on 7/30/25.
//

import Testing
import Foundation
@testable import Gradient_Games

extension Chess.Pieces {
	var withoutIds: Self {
		let nullUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
		return self.map({ piece in piece == nil ? nil : Chess.Piece(isLight: piece!.isLight, group: piece!.group, id: nullUUID)})
	}
}

struct ChessTests {
	@Test func initialBoardStateIsCorrect() async throws {
		let chessBoard = ChessBoard()
		#expect(chessBoard.pieces.withoutIds == Chess.startingPieces.withoutIds)
	}
}
