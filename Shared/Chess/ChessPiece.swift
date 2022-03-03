//
//  ChessPiece.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

struct ChessPiece: Codable, Equatable, Identifiable {
	enum Group: String, Codable, Identifiable {
		case pawn
		case knight
		case bishop
		case rook
		case queen
		case king
		
		var id: String {
			self.rawValue
		}
	}
	
	let isLight: Bool
	let group: Group
	let id: UUID
	
	init(isLight: Bool, group: Group, id: UUID = UUID()) {
		self.isLight = isLight
		self.group = group
		self.id = id
	}
}
