//
//  CheckersSquare.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/27/22.
//

import Foundation

extension Checkers {
	struct Square: Equatable, Codable, Hashable {
		let column: Int
		let row: Int
		
		init(column: Int, row: Int) {
			self.column = column
			self.row = row
		}
		
		init?(_ square: Self, deltaColumn: Int = 0, deltaRow: Int = 0) {
			guard SizeRange.contains(square.column + deltaColumn) && SizeRange.contains(square.row + deltaRow) else {
				return nil
			}
			
			self.init(column: square.column + deltaColumn, row: square.row + deltaRow)
		}
		
		func delta(to square: Self) -> SquareDelta {
			(column: square.column - column, row: square.row - row)
		}
		
		func rowDistance(to square: Self) -> Int {
			abs(square.row - row)
		}
	}
}
