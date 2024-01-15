//
//  ChessSquare.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

extension Chess {
	struct Square: Equatable, Codable, Hashable {
		let file: Chess.File
		let rank: Int
		
		init(file: Chess.File, rank: Int) {
			self.file = file
			self.rank = rank
		}
		
		init?(_ square: Self, deltaFile: Int = 0, deltaRank: Int = 0) {
			guard square.file + deltaFile != .none && Chess.Ranks.contains(square.rank + deltaRank) else {
				return nil
			}
			
			self.init(file: square.file + deltaFile, rank: square.rank + deltaRank)
		}
	}
}
