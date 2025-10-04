//
//  ChessPiece.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

extension Chess {
	struct Piece: Codable, Equatable, Identifiable, Hashable {
		enum Group: String, Codable, Identifiable {
			case pawn, knight, bishop, rook, queen, king

			var id: String {
				rawValue
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
}
