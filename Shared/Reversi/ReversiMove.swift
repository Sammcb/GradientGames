//
//  ReversiMove.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

extension Reversi {
	struct Move: Codable, Equatable {
		let light: Bool
		let square: Square
		let skip: Bool
		
		init(light: Bool, at square: Square) {
			self.light = light
			self.square = square
			self.skip = false
		}
		
		init(skip: Bool) {
			self.light = true
			self.square = Square(column: 1, row: 1)
			self.skip = skip
		}
	}
}
