//
//  ChessSquare.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

struct ChessSquare: Equatable, Codable, Hashable {
	let file: ChessFile
	let rank: Int
	
	init(file: ChessFile, rank: Int) {
		self.file = file
		self.rank = rank
	}
	
	init?(_ square: ChessSquare, deltaFile: Int = 0, deltaRank: Int = 0) {
		guard square.file + deltaFile != .none && ChessRanks.contains(square.rank + deltaRank) else {
			return nil
		}
		
		self.init(file: square.file + deltaFile, rank: square.rank + deltaRank)
	}
}
