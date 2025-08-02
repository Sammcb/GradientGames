//
//  ReversiTests.swift
//  GradientGames
//
//  Created by Sam McBroom on 7/31/25.
//

import Testing
import Foundation
@testable import GradientGames

extension Reversi.Pieces {
	var withoutIds: Self {
		let nullUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
		return self.map({ piece in piece == nil ? nil : Reversi.Piece(isLight: piece!.isLight, id: nullUUID)})
	}
}

struct ReversiTests {
	@Test func initialBoardStateIsCorrect() async throws {
		let reversiBoard = ReversiBoard()
		#expect(reversiBoard.pieces.withoutIds == Reversi.startingPieces.withoutIds)
	}
}
