//
//  ChessBoard.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

enum ChessFile: Int, CaseIterable, Comparable, Codable, Identifiable {
	case none, a, b, c, d, e, f, g, h
	
	static var validFiles: [ChessFile] {
		Array(ChessFile.allCases.dropFirst())
	}
	
	static func +(lhs: ChessFile, rhs: Int) -> ChessFile {
		ChessFile(rawValue: lhs.rawValue + rhs) ?? .none
	}
	
	static func -(lhs: ChessFile, rhs: Int) -> ChessFile {
		ChessFile(rawValue: lhs.rawValue - rhs) ?? .none
	}
	
	static func <(lhs: ChessFile, rhs: ChessFile) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
	
	static func +=(lhs: inout ChessFile, rhs: Int) {
		lhs = lhs + rhs
	}
	
	var id: Int {
		rawValue
	}
}

let ChessRanks = 1...8

typealias ChessPieces = [ChessPiece?]
extension ChessPieces {
	subscript(file: ChessFile, rank: Int) -> Element {
		get {
			self[(file.rawValue - 1) * 8 + rank - 1]
		}
		
		set {
			self[(file.rawValue - 1) * 8 + rank - 1] = newValue
		}
	}
	
	subscript(square: ChessSquare) -> Element {
		get {
			self[square.file, square.rank]
		}
		
		set {
			self[square.file, square.rank] = newValue
		}
	}
	
	static func square(at index: Int) -> ChessSquare {
		ChessSquare(file: ChessFile(rawValue: index / 8 + 1)!, rank: index % 8 + 1)
	}
}

struct ChessBoard: Equatable {
	enum State {
		case ok
		case check
		case checkmate
		case stalemate
	}
	
	var history = ChessState.shared.history
	var pieces = ChessState.shared.pieces
	var lightTurn: Bool {
		ChessState.shared.history.count.isMultiple(of: 2)
	}
	
	private mutating func movePiece(_ piece: ChessPiece, to square: ChessSquare) {
		pieces[square] = piece
	}
	
	private mutating func movePiece(at oldSquare: ChessSquare, to square: ChessSquare) {
		pieces[square] = pieces[oldSquare]
		capture(at: oldSquare)
	}
	
	private mutating func capture(at square: ChessSquare) {
		pieces[square] = nil
	}
	
	private mutating func enPassant(from oldSquare: ChessSquare, to square: ChessSquare) {
		let offset = pieces[oldSquare]!.isLight ? -1 : 1
		capture(at: ChessSquare(square, deltaRank: offset)!)
		movePiece(at: oldSquare, to: square)
	}
	
	private mutating func castle(from oldSquare: ChessSquare, to square: ChessSquare) {
		let offset = oldSquare.file < square.file ? -1 : 1
		let rookSquare = oldSquare.file < square.file ? ChessSquare(file: .h, rank: square.rank) : ChessSquare(file: .a, rank: square.rank)
		movePiece(at: rookSquare, to: ChessSquare(file: square.file + offset, rank: square.rank))
		movePiece(at: oldSquare, to: square)
	}
	
	mutating func promote(at square: ChessSquare, to piece: ChessPiece) {
		capture(at: square)
		movePiece(piece, to: square)
		ChessState.shared.history = history
		ChessState.shared.pieces = pieces
	}
	
	private func attackedDiagonalsFrom(_ square: ChessSquare) -> [ChessSquare] {
		var attackedSquares: [ChessSquare] = []
		for delta in 1...7 {
			if let attackedSquare = ChessSquare(square, deltaFile: delta, deltaRank: delta) {
				attackedSquares.append(attackedSquare)
				guard pieces[attackedSquare] == nil else {
					break
				}
			}
		}
		
		for delta in 1...7 {
			if let attackedSquare = ChessSquare(square, deltaFile: delta, deltaRank: -delta) {
				attackedSquares.append(attackedSquare)
				guard pieces[attackedSquare] == nil else {
					break
				}
			}
		}
		
		for delta in 1...7 {
			if let attackedSquare = ChessSquare(square, deltaFile: -delta, deltaRank: delta) {
				attackedSquares.append(attackedSquare)
				guard pieces[attackedSquare] == nil else {
					break
				}
			}
		}
		
		for delta in 1...7 {
			if let attackedSquare = ChessSquare(square, deltaFile: -delta, deltaRank: -delta) {
				attackedSquares.append(attackedSquare)
				guard pieces[attackedSquare] == nil else {
					break
				}
			}
		}
		
		return attackedSquares
	}
	
	private func attackedLinesFrom(_ square: ChessSquare) -> [ChessSquare] {
		var attackedSquares: [ChessSquare] = []
		
		for delta in 1...7 {
			if let attackedSquare = ChessSquare(square, deltaFile: delta) {
				attackedSquares.append(attackedSquare)
				guard pieces[attackedSquare] == nil else {
					break
				}
			}
		}
		
		for delta in 1...7 {
			if let attackedSquare = ChessSquare(square, deltaFile: -delta) {
				attackedSquares.append(attackedSquare)
				guard pieces[attackedSquare] == nil else {
					break
				}
			}
		}
		
		for delta in 1...7 {
			if let attackedSquare = ChessSquare(square, deltaRank: delta) {
				attackedSquares.append(attackedSquare)
				guard pieces[attackedSquare] == nil else {
					break
				}
			}
		}
		
		for delta in 1...7 {
			if let attackedSquare = ChessSquare(square, deltaRank: -delta) {
				attackedSquares.append(attackedSquare)
				guard pieces[attackedSquare] == nil else {
					break
				}
			}
		}
		
		return attackedSquares
	}
	
	private func attackedFrom(_ square: ChessSquare) -> [ChessSquare] {
		// No piece at square
		guard let piece = pieces[square] else {
			return []
		}
		
		var attackedSquares: [ChessSquare] = []
		switch piece.group {
		case .pawn:
			let offset = piece.isLight ? 1 : -1
			
			if let attackedSquare = ChessSquare(square, deltaFile: -1, deltaRank: offset) {
				attackedSquares.append(attackedSquare)
			}
			
			if let attackedSquare = ChessSquare(square, deltaFile: 1, deltaRank: offset) {
				attackedSquares.append(attackedSquare)
			}
			
			return attackedSquares
		case .knight:
			for delta in [(-1, -2), (-1, 2), (1, -2), (1, 2), (-2, -1), (-2, 1), (2, -1), (2, 1)] {
				if let attackedSquare = ChessSquare(square, deltaFile: delta.0, deltaRank: delta.1) {
					attackedSquares.append(attackedSquare)
				}
			}
			
			return attackedSquares
		case .bishop:
			attackedSquares.append(contentsOf: attackedDiagonalsFrom(square))
			
			return attackedSquares
		case .rook:
			attackedSquares.append(contentsOf: attackedLinesFrom(square))
			
			return attackedSquares
		case .queen:
			attackedSquares.append(contentsOf: attackedDiagonalsFrom(square))
			attackedSquares.append(contentsOf: attackedLinesFrom(square))
			
			return attackedSquares
		case .king:
			for deltaFile in -1...1 {
				for deltaRank in -1...1 {
					guard deltaFile != 0 || deltaRank != 0 else {
						continue
					}
					
					if let attackedSquare = ChessSquare(square, deltaFile: deltaFile, deltaRank: deltaRank) {
						attackedSquares.append(attackedSquare)
					}
				}
			}
			return attackedSquares
		}
	}
	
	private func canEnPassant(to square: ChessSquare, with offset: Int) -> Bool {
		guard let move = history.last else {
			return false
		}
		
		let fromSquare = ChessSquare(square, deltaRank: offset)
		let toSquare = ChessSquare(square, deltaRank: -offset)
		
		// Make sure opponent pawn moved two squares last turn
		return move.piece.group == .pawn && move.fromSquare == fromSquare && move.toSquare == toSquare
	}
	
	private func canCastle(to square: ChessSquare) -> Bool {
		let kingSquare = ChessSquare(file: .e, rank: square.rank)
		let offset = kingSquare.file < square.file ? 1 : -1
		let rookFile: ChessFile = kingSquare.file < square.file ? .h : .a
		let rookSquare = ChessSquare(file: rookFile, rank: square.rank)
		
		// Check square next to king is empty
		guard pieces[kingSquare.file + offset, square.rank] == nil else {
			return false
		}
		
		// Check square two away from king is empty
		guard pieces[kingSquare.file + offset * 2, square.rank] == nil else {
			return false
		}
		
		// If queenside castle, make sure square three away from king is empy
		if kingSquare.file > square.file && pieces[kingSquare.file + offset * 3, square.rank] != nil {
			return false
		}
		
		// King cannot pass through attacked square when castling
		if let king = pieces[kingSquare], inCheckAt(ChessSquare(square, deltaFile: offset)!, isLight: king.isLight) {
			return false
		}
		
		// King cannot castle when in check
		if let king = pieces[kingSquare], inCheckAt(kingSquare, isLight: king.isLight) {
			return false
		}
		
		// Check that king has never been moved, and that rook has never been moved or captured
		for move in history {
			if move.fromSquare == kingSquare || move.fromSquare == rookSquare || move.toSquare == rookSquare {
				return false
			}
		}
		
		return true
	}
	
	private func inCheckAt(_ square: ChessSquare, isLight: Bool) -> Bool {
		for (index, piece) in pieces.enumerated() {
			let checkSquare = ChessPieces.square(at: index)
			if let piece, piece.isLight != isLight, attackedFrom(checkSquare).contains(square) {
				return true
			}
		}
		return false
	}
	
	mutating func canMove(from oldSquare: ChessSquare, to square: ChessSquare) -> Bool {
		// Make sure piece at oldSquare exists
		guard let piece = pieces[oldSquare] else {
			return false
		}
		
		// Ignore move if square occupied by piece of same color
		if let attackedPiece = pieces[square], attackedPiece.isLight == piece.isLight {
			return false
		}
		
		let attackedSquares = attackedFrom(oldSquare)
		var validSquares: [ChessSquare] = []
		
		switch piece.group {
		case .pawn:
			// Pawns should always move forward at least one square
			if (piece.isLight && square.rank <= oldSquare.rank) || (!piece.isLight && square.rank >= oldSquare.rank) {
				return false
			}
			
			let offset = piece.isLight ? 1 : -1
			let startRank = piece.isLight ? 2 : 7
			
			// Check if attack squares are valid
			validSquares.append(contentsOf: attackedSquares.filter({ pieces[$0] != nil || canEnPassant(to: square, with: offset) }))
			
			// Check if forward or two square forward moves are valid
			if pieces[oldSquare.file, oldSquare.rank + offset] == nil {
				validSquares.append(ChessSquare(file: oldSquare.file, rank: oldSquare.rank + offset))
				if oldSquare.rank == startRank && pieces[oldSquare.file, oldSquare.rank + offset * 2] == nil {
					validSquares.append(ChessSquare(file: oldSquare.file, rank: oldSquare.rank + offset * 2))
				}
			}
		case .knight:
			validSquares.append(contentsOf: attackedSquares)
		case .bishop:
			validSquares.append(contentsOf: attackedSquares)
		case .rook:
			validSquares.append(contentsOf: attackedSquares)
		case .queen:
			validSquares.append(contentsOf: attackedSquares)
		case .king:
			let rank = piece.isLight ? 1 : 8
			// Check if in check at attack squares
			validSquares.append(contentsOf: attackedSquares.filter({ !inCheckAt($0, isLight: piece.isLight) }))
			// Check if castle squares are valid
			let castleSquares = [ChessSquare(file: .g, rank: rank), ChessSquare(file: .c, rank: rank)]
			validSquares.append(contentsOf: castleSquares.filter({ canCastle(to: $0) }))
		}
		
		guard validSquares.contains(square) else {
			return false
		}
		
		move(from: oldSquare, to: square, checkTest: true)
		
		let kingIndex = pieces.firstIndex(where: { $0?.group == .king && $0?.isLight == piece.isLight })!
		let inCheck = inCheckAt(ChessPieces.square(at: kingIndex), isLight: piece.isLight)
		
		undo(checkTest: true)
		
		return !inCheck
	}
	
	mutating func move(from oldSquare: ChessSquare, to square: ChessSquare, checkTest: Bool = false) {
		let piece = pieces[oldSquare]!
		let move: ChessMove
		var promoted = false
		
		if piece.group == .pawn && square.file != oldSquare.file && pieces[square] == nil {
			// En passant
			let offset = piece.isLight ? 1 : -1
			let enPassantSquare = ChessSquare(square, deltaRank: -offset)!
			move = ChessMove(piece: piece, from: oldSquare, to: square, captured: pieces[enPassantSquare]!, at: enPassantSquare)
			enPassant(from: oldSquare, to: square)
		} else if piece.group == .king && (square.file == oldSquare.file + 2 || square.file == oldSquare.file - 2) {
			// Castle
			move = ChessMove(piece: piece, from: oldSquare, to: square)
			castle(from: oldSquare, to: square)
		} else {
			// Promoted
			let rank = piece.isLight ? 8 : 1
			if piece.group == .pawn && square.rank == rank {
				promoted = true
			}
			
			if let oldPiece = pieces[square] {
				move = ChessMove(piece: piece, from: oldSquare, to: square, captured: oldPiece, at: square, promoted: promoted)
				capture(at: square)
			} else {
				move = ChessMove(piece: piece, from: oldSquare, to: square, promoted: promoted)
			}
			movePiece(at: oldSquare, to: square)
			
			// Don't need to handle if pawn upgraded because only position of piece matters for blocking check, not type
		}
		
		history.append(move)
		
		// Wait to save if promoted until promoted piece is chosen
		if !checkTest && !promoted {
			ChessState.shared.history = history
			ChessState.shared.pieces = pieces
		}
	}
	
	mutating func kingState(isLight: Bool) -> State {
		var findSquare: ChessSquare?
		for (index, piece) in pieces.enumerated() {
			if let king = piece, king.group == .king, king.isLight == isLight {
				findSquare = ChessPieces.square(at: index)
				break
			}
		}
		
		guard let kingSquare = findSquare else {
			return .ok
		}
		
		if inCheckAt(kingSquare, isLight: isLight) {
			// Check checkmate
			for (index, piece) in pieces.enumerated() {
				guard piece != nil && piece?.isLight == isLight else {
					continue
				}
				
				// If player can move any piece somewhere, then it is possible to get king out of check
				for checkIndex in 0..<pieces.count {
					if canMove(from: ChessPieces.square(at: index), to: ChessPieces.square(at: checkIndex)) {
						return .check
					}
				}
			}
			return .checkmate
		}
		
		// Check stalemate
		for (index, piece) in pieces.enumerated() {
			guard piece != nil && piece?.isLight == isLight else {
				continue
			}
			
			// If player can move any piece and they are not in check, then it is a stalemate
			for checkIndex in 0..<pieces.count {
				if canMove(from: ChessPieces.square(at: index), to: ChessPieces.square(at: checkIndex)) {
					return .ok
				}
			}
		}
		return .stalemate
	}
	
	mutating func undo(checkTest: Bool = false) {
		if history.isEmpty {
			return
		}
		
		let move = history.removeLast()
		
		if move.promoted {
			capture(at: move.toSquare)
			movePiece(move.piece, to: move.toSquare)
		}
		
		movePiece(at: move.toSquare, to: move.fromSquare)
		// Undo castle
		if move.piece.group == .king {
			if move.toSquare.file == move.fromSquare.file - 2 {
				movePiece(at: ChessSquare(move.toSquare, deltaFile: 1)!, to: ChessSquare(file: .a, rank: move.toSquare.rank))
			} else if move.toSquare.file == move.fromSquare.file + 2 {
				movePiece(at: ChessSquare(move.toSquare, deltaFile: -1)!, to: ChessSquare(file: .h, rank: move.toSquare.rank))
			}
		}
		
		if let capturedPiece = move.capturedPiece {
			movePiece(capturedPiece, to: move.capturedSquare!)
		}
		
		if !checkTest {
			ChessState.shared.history = history
			ChessState.shared.pieces = pieces
		}
	}
}
