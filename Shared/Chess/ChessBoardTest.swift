//
//  ChessBoard.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/9/24.
//

import Foundation
import SwiftData

@Model
class ChessBoardTest {
	typealias KingStates = (light: State, dark: State)
	
	enum State {
		case ok, check, checkmate, stalemate
	}
	
	let id = UUID()
	
	@Transient private (set) var history: [ChessMove] = []
//	@Transient var selectedSquare: ChessSquare?
//	@Transient var pawnSquare: ChessSquare?
	
	@Transient private var startingPieces: ChessPieces = {
		var pieces = ChessPieces(repeating: nil, count: ChessFile.validFiles.count * ChessRanks.count)
		
		for rank in [1, 8] {
			pieces[.a, rank] = ChessPiece(isLight: rank == 1, group: .rook)
			pieces[.b, rank] = ChessPiece(isLight: rank == 1, group: .knight)
			pieces[.c, rank] = ChessPiece(isLight: rank == 1, group: .bishop)
			pieces[.d, rank] = ChessPiece(isLight: rank == 1, group: .queen)
			pieces[.e, rank] = ChessPiece(isLight: rank == 1, group: .king)
			pieces[.f, rank] = ChessPiece(isLight: rank == 1, group: .bishop)
			pieces[.g, rank] = ChessPiece(isLight: rank == 1, group: .knight)
			pieces[.h, rank] = ChessPiece(isLight: rank == 1, group: .rook)
		}
		
		for rank in [2, 7] {
			for file in ChessFile.validFiles {
				pieces[file, rank] = ChessPiece(isLight: rank == 2, group: .pawn)
			}
		}
		return pieces
	}()
	
	@Transient var cachedPieces: ChessPieces = []
	@Transient var cachedPiecesMoveIndex = -1
	
	private func computePieces(for moves: [ChessMove], from state: ChessPieces) -> ChessPieces {
		var pieces = state
		
		for move in moves {
			// Capture piece
			if let capturedSquare = move.capturedSquare {
				pieces[capturedSquare] = nil
			}
			
			// Move piece
			pieces[move.toSquare] = pieces[move.fromSquare]
			pieces[move.fromSquare] = nil
			
			// Move rook in a castle
			let deltaFile = move.fromSquare.file.delta(file: move.toSquare.file)
			if move.piece.group == .king && abs(deltaFile) == 2 {
				let rank = move.fromSquare.rank
				let rookFile: ChessFile = deltaFile > 0 ? .a : .h
				let newRookFile = move.fromSquare.file + deltaFile.signum()
				pieces[newRookFile, rank] = pieces[rookFile, rank]
				pieces[rookFile, rank] = nil
			}
			
			// Pawn promotion
			guard let promotedPiece = move.promotedPiece else {
				continue
			}
			
			pieces[move.toSquare] = promotedPiece
		}
		
		return pieces
	}
	
	@Transient var pieces: ChessPieces {
		if history.isEmpty {
			return startingPieces
		}
		
		if cachedPiecesMoveIndex == history.count - 1 {
			return cachedPieces
		}
		
		cachedPiecesMoveIndex = history.count - 1
		
		let futureMoves = Array(history.suffix(from: cachedPiecesMoveIndex))
		let state = cachedPieces.isEmpty ? startingPieces : cachedPieces
		let pieces = computePieces(for: futureMoves, from: state)
		
		cachedPieces = pieces
		
		return pieces
	}
	
	@Transient var lightTurn: Bool {
		let lightTurn = history.count.isMultiple(of: 2)
		if promoting {
			return !lightTurn
		}
		
		return lightTurn
	}
	
	@Transient var promoting: Bool {
		guard let move = history.last else {
			return false
		}
		return move.promoted && move.promotedPiece == nil
	}
	
	@Transient var kingStates: KingStates {
		(light: kingState(isLight: true), dark: kingState(isLight: false))
	}
	
	@Transient var undoEnabled: Bool {
		!history.isEmpty && !promoting
	}
	
	@Transient var gameOver: Bool {
		let kingState = lightTurn ? kingStates.light : kingStates.dark
		return kingState == .checkmate || kingState == .stalemate
	}
	
//	@Transient var lastCheckedMove: ChessMove?
	@Transient var cachedKingStates: KingStates = (light: .ok, dark: .ok)
	@Transient var cachedKingStatesMoveIndex = -1
	
	init() {
		var pieces = ChessPieces(repeating: nil, count: ChessFile.validFiles.count * ChessRanks.count)
		
		for rank in [1, 8] {
			pieces[.a, rank] = ChessPiece(isLight: rank == 1, group: .rook)
			pieces[.b, rank] = ChessPiece(isLight: rank == 1, group: .knight)
			pieces[.c, rank] = ChessPiece(isLight: rank == 1, group: .bishop)
			pieces[.d, rank] = ChessPiece(isLight: rank == 1, group: .queen)
			pieces[.e, rank] = ChessPiece(isLight: rank == 1, group: .king)
			pieces[.f, rank] = ChessPiece(isLight: rank == 1, group: .bishop)
			pieces[.g, rank] = ChessPiece(isLight: rank == 1, group: .knight)
			pieces[.h, rank] = ChessPiece(isLight: rank == 1, group: .rook)
		}
		
		for rank in [2, 7] {
			for file in ChessFile.validFiles {
				pieces[file, rank] = ChessPiece(isLight: rank == 2, group: .pawn)
			}
		}
		
//		self.startingPieces = pieces
		
//		print("INIT START \(startingPieces.count) \(id)")
	}
	
	private func attackedLineFrom(_ square: ChessSquare, with fileStep: Int, _ rankStep: Int) -> [ChessSquare] {
		var attackedSquares: [ChessSquare] = []
		for delta in 1...7 {
			guard let attackedSquare = ChessSquare(square, deltaFile: delta * fileStep, deltaRank: delta * rankStep) else {
				return attackedSquares
			}
			attackedSquares.append(attackedSquare)
			if pieces[attackedSquare] != nil {
				return attackedSquares
			}
		}
		return attackedSquares
	}
	
	private func attackedFrom(_ square: ChessSquare) -> [ChessSquare] {
		guard let piece = pieces[square] else {
			return []
		}
		
		let diagonalSteps = [(1, 1), (1, -1), (-1, 1), (-1, -1)]
		let straightSteps = [(1, 0), (-1, 0), (0, 1), (0, -1)]
		let steps = diagonalSteps + straightSteps
		switch piece.group {
		case .pawn:
			let rankDelta = piece.isLight ? 1 : -1
			let deltas = [(-1, rankDelta), (1, rankDelta)]
			let squares = deltas.map({ file, rank in ChessSquare(square, deltaFile: file, deltaRank: rank) })
			return squares.compactMap({ $0 })
		case .knight:
			let files = -2...2
			let ranks = -2...2
			let deltas = files.flatMap({ file in ranks.map({ rank in (file, rank) }) }).filter({ file, rank in file != 0 && rank != 0 && abs(file) != abs(rank) })
			let squares = deltas.map({ file, rank in ChessSquare(square, deltaFile: file, deltaRank: rank) })
			return squares.compactMap({ $0 })
		case .bishop:
			return diagonalSteps.flatMap({ fileStep, rankStep in attackedLineFrom(square, with: fileStep, rankStep) })
		case .rook:
			return straightSteps.flatMap({ fileStep, rankStep in attackedLineFrom(square, with: fileStep, rankStep) })
		case .queen:
			return steps.flatMap({ fileStep, rankStep in attackedLineFrom(square, with: fileStep, rankStep) })
		case .king:
			let files = -1...1
			let ranks = -1...1
			let deltas = files.flatMap({ file in ranks.map({ rank in (file, rank) }) }).filter({ delta in delta != (0, 0) })
			let squares = deltas.map({ file, rank in ChessSquare(square, deltaFile: file, deltaRank: rank) })
			return squares.compactMap({ $0 })
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
	
	private func kingSafeAt(_ square: ChessSquare, isLight: Bool, with pieces: ChessPieces) -> Bool {
		// Make sure no opponent piece is able to attack the king square
		for (index, piece) in pieces.enumerated() {
			let checkSquare = ChessPieces.square(at: index)
			guard let piece, piece.isLight != isLight, attackedFrom(checkSquare).contains(square) else {
				continue
			}
			return false
		}
		return true
	}
	
	private func canCastle(to square: ChessSquare) -> Bool {
		let kingSquare = ChessSquare(file: .e, rank: square.rank)
		let offset = kingSquare.file < square.file ? 1 : -1
		let rookFile: ChessFile = kingSquare.file < square.file ? .h : .a
		let rookSquare = ChessSquare(file: rookFile, rank: square.rank)
		
		guard let king = pieces[kingSquare] else {
			return false
		}
		
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
		
		// Check that that rook has never been captured
		guard let rook = pieces[rookSquare], rook.group == .rook, rook.isLight == king.isLight else {
			return false
		}
		
		// Check that king and rook have never been moved
		guard history.filter({ move in move.fromSquare == kingSquare || move.fromSquare == rookSquare }).isEmpty else {
			return false
		}
		
		// King cannot pass through attacked square when castling
		guard let passingSquare = ChessSquare(square, deltaFile: offset) else {
			return false
		}
		
		// King cannot castle when in check
		let kingState = king.isLight ? kingStates.light : kingStates.dark
		guard kingState == .ok else {
			return false
		}
		
		return kingSafeAt(passingSquare, isLight: king.isLight, with: pieces)
	}
	
	private func validSquaresFrom(_ square: ChessSquare) -> [ChessSquare] {
		guard let piece = pieces[square] else {
			return []
		}
		
		let attackedSquares = attackedFrom(square)
		
		switch piece.group {
		case .pawn:
			let rankOffset = piece.isLight ? 1 : -1
			let startRank = piece.isLight ? 2 : 7
			
			// Check if attack squares are valid
			var validSquares = attackedSquares.filter({ pieces[$0] != nil || canEnPassant(to: $0, with: rankOffset) })
			
			// Check if forward one square is valid
			guard let oneForward = ChessSquare(square, deltaRank: rankOffset), pieces[oneForward] == nil else {
				return validSquares
			}
		
			validSquares.append(oneForward)
			
			// Check if forward two squares is valid
			guard square.rank == startRank, let twoForward = ChessSquare(square, deltaRank: rankOffset * 2), pieces[twoForward] == nil else {
				return validSquares
			}

			validSquares.append(twoForward)
			return validSquares
		case .knight, .bishop, .rook, .queen: return attackedSquares
		case .king:
			let startRank = piece.isLight ? 1 : 8
			// Check if castle squares are valid
			let castleFiles: [ChessFile] = [.g, .c]
			let castleSquares = castleFiles.map({ file in ChessSquare(file: file, rank: startRank) })
			let validCastleSquares = castleSquares.filter({ castleSquare in canCastle(to: castleSquare) })
			return attackedSquares + validCastleSquares
		}
	}
	
	private func moveChecksKing(from oldSquare: ChessSquare, to square: ChessSquare) -> Bool {
		guard let piece = pieces[oldSquare] else {
			return false
		}
		
		// Check if move will put own king in check
		guard let futureMove = computeMove(from: oldSquare, to: square) else {
			return false
		}
		let futurePieces = computePieces(for: [futureMove], from: pieces)
		
		guard let kingIndex = futurePieces.firstIndex(where: { $0?.group == .king && $0?.isLight == piece.isLight }) else {
			return false
		}
		return kingSafeAt(ChessPieces.square(at: kingIndex), isLight: piece.isLight, with: futurePieces)
	}
	
	func canMove(from oldSquare: ChessSquare, to square: ChessSquare, validityUnknown: Bool = true) -> Bool {
		// Moving piece must exist
		guard let piece = pieces[oldSquare] else {
			return false
		}
		
		// Piece cannot move to square occupied by piece of same color
		if pieces[square]?.isLight == piece.isLight {
			return false
		}
		
		guard validityUnknown else {
			return moveChecksKing(from: oldSquare, to: square)
		}
		
		let validSquares = validSquaresFrom(oldSquare)
//		print(validSquares)
		
		guard validSquares.contains(square) else {
			return false
		}
		
		return moveChecksKing(from: oldSquare, to: square)
	}
	
	private func computeMove(from oldSquare: ChessSquare, to square: ChessSquare) -> ChessMove? {
		guard let piece = pieces[oldSquare] else {
			return nil
		}
		
		let enPassant = piece.group == .pawn && square.file != oldSquare.file && pieces[square] == nil
		let enPassantOffset = piece.isLight ? -1 : 1
		let enPassantSquare = ChessSquare(square, deltaRank: enPassantOffset) ?? square
		let capturedSquare = enPassant ? enPassantSquare : square
		
		let rank = piece.isLight ? 8 : 1
		let promoted = piece.group == .pawn && square.rank == rank
		
		let capturedPiece = pieces[capturedSquare]
		return ChessMove(piece: piece, from: oldSquare, to: square, captured: capturedPiece, at: capturedSquare, promoted: promoted)
	}

	func move(from oldSquare: ChessSquare, to square: ChessSquare) {
		guard let move = computeMove(from: oldSquare, to: square) else {
			return
		}

		history.append(move)
	}
	
	func promote(to group: ChessPiece.Group) {
		guard let move = history.popLast(), promoting else {
			return
		}
		
		move.promotedPiece = ChessPiece(isLight: lightTurn, group: group, id: move.piece.id)
		history.append(move)
	}
	
	func undo() {
		guard undoEnabled else {
			return
		}
//		selectedSquare = nil
		let _ = history.popLast()
	}
	
	private func canMoveSomePiece(isLight: Bool) -> Bool {
		for (index, piece) in pieces.enumerated() {
			guard let piece, piece.isLight == isLight else {
				continue
			}
			
			let oldSquare = ChessPieces.square(at: index)
			let validSquares = validSquaresFrom(oldSquare)
			for square in validSquares {
				guard canMove(from: oldSquare, to: square, validityUnknown: false) else {
					continue
				}
				return true
			}
		}
		return false
	}
	
	private func computeKingState(isLight: Bool) -> State {
		guard let kingSquareIndex = pieces.firstIndex(where: { piece in piece?.group == .king && piece?.isLight == isLight }) else {
			return .ok
		}
		let kingSquare = ChessPieces.square(at: kingSquareIndex)
		
		// Check checkmate
		let canMoveSomePiece = canMoveSomePiece(isLight: isLight)
		guard kingSafeAt(kingSquare, isLight: isLight, with: pieces) else {
			return canMoveSomePiece ? .check : .checkmate
		}
		
		// Check stalemate
		return canMoveSomePiece ? .ok : .stalemate
	}
	
	private func kingState(isLight: Bool) -> State {
		return computeKingState(isLight: isLight)
//		guard cachedKingStatesMoveIndex >= 0 else {
//			return .ok
//		}
//		
//		if cachedKingStatesMoveIndex == history.count - 1 {
//			return isLight ? cachedKingStates.light : cachedKingStates.dark
//		}
//		
//		guard let move = history.last else {
//			return .ok
//		}
//		
//		if move == lastCheckedMove && move.piece.isLight == isLight {
//			return isLight ? cachedKingStates.light : cachedKingStates.dark
//		}
//		
//		lastCheckedMove = move
//		let newKingState = computeKingState(isLight: isLight)
//		if isLight {
//			cachedKingStates.light = newKingState
//		} else {
//			cachedKingStates.dark = newKingState
//		}
//		return newKingState
	}
}
