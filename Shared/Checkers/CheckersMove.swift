//
//  CheckersMove.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/27/22.
//

import Foundation

extension Checkers {
	struct Move: Codable, Equatable {
		let fromSquare: Square
		let toSquare: Square
		var continued: Bool = false
		
		init(from oldSquare: Square, to square: Square) {
			self.fromSquare = oldSquare
			self.toSquare = square
		}
	}
}
