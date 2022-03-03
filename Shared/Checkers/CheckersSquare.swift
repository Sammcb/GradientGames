//
//  CheckersSquare.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/27/22.
//

import Foundation

struct CheckersSquare: Equatable, Codable, Hashable {
	let column: Int
	let row: Int
	
	init(column: Int, row: Int) {
		self.column = column
		self.row = row
	}
	
	init?(_ square: CheckersSquare, deltaColumn: Int = 0, deltaRow: Int = 0) {
		guard CheckersSizeRange.contains(square.column + deltaColumn) && CheckersSizeRange.contains(square.row + deltaRow) else {
			return nil
		}
		
		self.init(column: square.column + deltaColumn, row: square.row + deltaRow)
	}
}
