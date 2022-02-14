//
//  ReversiSquare.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

struct ReversiSquare: Equatable, Codable, Hashable {
	let column: Int
	let row: Int
	
	init(column: Int, row: Int) {
		self.column = column
		self.row = row
	}
	
	init?(_ square: ReversiSquare, deltaColumn: Int = 0, deltaRow: Int = 0) {
		guard ReversiSizeRange.contains(square.column + deltaColumn) && ReversiSizeRange.contains(square.row + deltaRow) else {
			return nil
		}
		
		self.init(column: square.column + deltaColumn, row: square.row + deltaRow)
	}
}
