//
//  CheckersTests.swift
//  GradientGames
//
//  Created by Sam McBroom on 7/31/25.
//

import Testing
import Foundation
@testable import Gradient_Games

extension Checkers.Pieces {
	var withoutIds: Self {
		let nullUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
		return self.map({ piece in piece == nil ? nil : Checkers.Piece(isLight: piece!.isLight, id: nullUUID)})
	}
}

struct CheckersTests {
	@Test func initialBoardStateIsCorrect() async throws {
		let checkersBoard = CheckersBoard()
		#expect(checkersBoard.pieces.withoutIds == Checkers.startingPieces.withoutIds)
	}
}
