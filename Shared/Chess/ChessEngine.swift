//
//  ChessEngine.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/13/24.
//

import Foundation

protocol ChessEngine {}

extension ChessEngine {
	func computeState(for moves: [Chess.Move], from state: Chess.Pieces) -> Chess.Pieces {
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
				let rookFile: Chess.File = deltaFile > 0 ? .a : .h
				let newRookFile = move.toSquare.file + deltaFile.signum()
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
	
	private func attackedLineFrom(_ square: Chess.Square, with fileStep: Int, _ rankStep: Int, for state: Chess.Pieces) -> [Chess.Square] {
		var attackedSquares: [Chess.Square] = []
		let upperBound = max(Chess.File.validFiles.count, Chess.Ranks.upperBound)
		for delta in 1..<upperBound {
			guard let attackedSquare = Chess.Square(square, deltaFile: delta * fileStep, deltaRank: delta * rankStep) else {
				return attackedSquares
			}
			
			attackedSquares.append(attackedSquare)
			
			if state[attackedSquare] == nil {
				continue
			}
			
			return attackedSquares
		}
		return attackedSquares
	}
	
	private func attackingFrom(_ square: Chess.Square, for state: Chess.Pieces) -> [Chess.Square] {
		guard let piece = state[square] else {
			return []
		}
		
		let diagonalSteps = [(1, 1), (1, -1), (-1, 1), (-1, -1)]
		let straightSteps = [(1, 0), (-1, 0), (0, 1), (0, -1)]
		let steps = diagonalSteps + straightSteps
		let squares: [Chess.Square]
		switch piece.group {
		case .pawn:
			let rankDelta = piece.isLight ? 1 : -1
			let deltas = [(-1, rankDelta), (1, rankDelta)]
			squares = deltas.compactMap({ file, rank in Chess.Square(square, deltaFile: file, deltaRank: rank) })
		case .knight:
			let range = -2...2
			let noLines = range.filter({ delta in delta != 0 })
			let deltas = noLines.flatMap({ file in noLines.map({ rank in (file, rank) }) }).filter({ file, rank in abs(file) != abs(rank) })
			squares = deltas.compactMap({ file, rank in Chess.Square(square, deltaFile: file, deltaRank: rank) })
		case .bishop:
			squares = diagonalSteps.flatMap({ fileStep, rankStep in attackedLineFrom(square, with: fileStep, rankStep, for: state) })
		case .rook:
			squares = straightSteps.flatMap({ fileStep, rankStep in attackedLineFrom(square, with: fileStep, rankStep, for: state) })
		case .queen:
			squares = steps.flatMap({ fileStep, rankStep in attackedLineFrom(square, with: fileStep, rankStep, for: state) })
		case .king:
			let range = -1...1
			let deltas = range.flatMap({ file in range.map({ rank in (file, rank) }) }).filter({ delta in delta != (0, 0) })
			squares = deltas.compactMap({ file, rank in Chess.Square(square, deltaFile: file, deltaRank: rank) })
		}
		return squares.filter({ square in state[square]?.isLight != piece.isLight })
	}
	
	private func canEnPassant(to square: Chess.Square, with offset: Int, for moves: [Chess.Move]) -> Bool {
		guard let move = moves.last else {
			return false
		}
		
		let fromSquare = Chess.Square(square, deltaRank: offset)
		let toSquare = Chess.Square(square, deltaRank: -offset)
		
		// Make sure opponent pawn moved two squares last turn
		return move.piece.group == .pawn && move.fromSquare == fromSquare && move.toSquare == toSquare
	}
	
	private func attackedSquares(from state: Chess.Pieces, for lightTurn: Bool) -> Set<Chess.Square> {
		let darkTurn = !lightTurn
		var opponentAttackedSquares: Set<Chess.Square> = []
		for (index, piece) in state.enumerated() {
			guard let piece, piece.isLight == darkTurn else {
				continue
			}
			let square = Chess.Pieces.square(at: index)
			let attackedSquares = attackingFrom(square, for: state)
			opponentAttackedSquares.formUnion(attackedSquares)
		}
		return opponentAttackedSquares
	}
	
	private func canCastle(to square: Chess.Square, for lightTurn: Bool, _ state: Chess.Pieces, _ moves: [Chess.Move]) -> Bool {
		let kingSquare = Chess.Square(file: .e, rank: square.rank)
		let offset = square.file.delta(file: kingSquare.file).signum()
		let rookFile: Chess.File = offset > 0 ? .h : .a
		let rookSquare = Chess.Square(file: rookFile, rank: square.rank)
		
		guard let king = state[kingSquare] else {
			return false
		}
		
		// Check square next to king is empty
		guard state[kingSquare.file + offset, square.rank] == nil else {
			return false
		}
		
		// Check square two away from king is empty
		guard state[kingSquare.file + offset * 2, square.rank] == nil else {
			return false
		}
		
		// If queenside castle, make sure square three away from king is empy
		if kingSquare.file > square.file && state[kingSquare.file + offset * 3, square.rank] != nil {
			return false
		}
		
		// Check that that rook has never been captured
		guard let rook = state[rookSquare], rook.group == .rook, rook.isLight == king.isLight else {
			return false
		}
		
		// Check that king and rook have never been moved
		guard moves.filter({ move in move.fromSquare == kingSquare || move.fromSquare == rookSquare }).isEmpty else {
			return false
		}
		
		guard let passingSquare = Chess.Square(kingSquare, deltaFile: offset) else {
			return false
		}
		
		// King cannot castle when in check or the square being passed through is targeted by an opponent piece
		let requiredSafeSquares: Set = [kingSquare, passingSquare]
		let opponentAttackedSquares = attackedSquares(from: state, for: lightTurn)
		return opponentAttackedSquares.intersection(requiredSafeSquares).isEmpty
	}
	
	private func possibleMoveSquares(from square: Chess.Square, for lightTurn: Bool, _ state: Chess.Pieces, _ moves: [Chess.Move]) -> [Chess.Square] {
		guard let piece = state[square] else {
			return []
		}
		
		let attackedSquares = attackingFrom(square, for: state)
		
		switch piece.group {
		case .pawn:
			let rankOffset = piece.isLight ? 1 : -1
			let baseRank = piece.isLight ? Chess.Ranks.lowerBound : Chess.Ranks.upperBound
			let startRank = baseRank + rankOffset
			
			// Check if attack squares are valid
			var validSquares = attackedSquares.filter({ state[$0] != nil || canEnPassant(to: $0, with: rankOffset, for: moves) })
			
			// Check if forward one square is valid
			guard let oneForward = Chess.Square(square, deltaRank: rankOffset), state[oneForward] == nil else {
				return validSquares
			}
		
			validSquares.append(oneForward)
			
			// Check if forward two squares is valid
			guard square.rank == startRank, let twoForward = Chess.Square(square, deltaRank: rankOffset * 2), state[twoForward] == nil else {
				return validSquares
			}

			validSquares.append(twoForward)
			return validSquares
		case .knight, .bishop, .rook, .queen: return attackedSquares
		case .king:
			let startRank = piece.isLight ? Chess.Ranks.lowerBound : Chess.Ranks.upperBound
			// Check if castle squares are valid
			let castleFiles: [Chess.File] = [.g, .c]
			let castleSquares = castleFiles.map({ file in Chess.Square(file: file, rank: startRank) })
			let validCastleSquares = castleSquares.filter({ castleSquare in canCastle(to: castleSquare, for: lightTurn, state, moves) })
			return attackedSquares + validCastleSquares
		}
	}
	
	private func validMoveSquare(from oldSquare: Chess.Square, to newSquare: Chess.Square, for lightTurn: Bool, _ state: Chess.Pieces) -> Bool {
		guard let futureMove = computeMove(from: oldSquare, to: newSquare, for: state) else {
			return false
		}
		
		let futurePieces = computeState(for: [futureMove], from: state)
		
		guard let kingIndex = futurePieces.firstIndex(where: { piece in piece?.group == .king && piece?.isLight == lightTurn }) else {
			return false
		}
		
		let kingSquare = Chess.Pieces.square(at: kingIndex)
		
		let opponentAttackedSquares = attackedSquares(from: futurePieces, for: lightTurn)
		return !opponentAttackedSquares.contains(kingSquare)
	}
	
	func validMoveSquares(from square: Chess.Square, for lightTurn: Bool, _ state: Chess.Pieces, _ moves: [Chess.Move]) -> [Chess.Square] {
		let possibleMoveSquares = possibleMoveSquares(from: square, for: lightTurn, state, moves)
		return possibleMoveSquares.filter({ toSquare in validMoveSquare(from: square, to: toSquare, for: lightTurn, state) })
	}
	
	private func allValidSquares(for lightTurn: Bool, _ state: Chess.Pieces, _ moves: [Chess.Move]) -> [Chess.Piece: [Chess.Square]] {
		var validSquares: [Chess.Piece: [Chess.Square]] = [:]
		for (index, piece) in state.enumerated() {
			guard let piece, piece.isLight == lightTurn else {
				continue
			}
			let square = Chess.Pieces.square(at: index)
			validSquares[piece] = validMoveSquares(from: square, for: lightTurn, state, moves)
		}
		return validSquares
	}
	
	func computeMove(from oldSquare: Chess.Square, to square: Chess.Square, for state: Chess.Pieces) -> Chess.Move? {
		guard let piece = state[oldSquare] else {
			return nil
		}
		
		let enPassant = piece.group == .pawn && square.file != oldSquare.file && state[square] == nil
		let enPassantOffset = piece.isLight ? -1 : 1
		let enPassantSquare = Chess.Square(square, deltaRank: enPassantOffset) ?? square
		let potentialCapturedSquare = enPassant ? enPassantSquare : square
		
		let rank = piece.isLight ? Chess.Ranks.upperBound : Chess.Ranks.lowerBound
		let promoted = piece.group == .pawn && square.rank == rank
		
		let capturedSquare = state[potentialCapturedSquare] == nil ? nil : potentialCapturedSquare
		return Chess.Move(piece: piece, from: oldSquare, to: square, capturedAt: capturedSquare, promoted: promoted)
	}
	
	func canMove(from oldSquare: Chess.Square, to newSquare: Chess.Square, for lightTurn: Bool, _ state: Chess.Pieces, _ moves: [Chess.Move]) -> Bool {
		guard let piece = state[oldSquare], piece.isLight == lightTurn else {
			return false
		}
		
		let allValidSquares = allValidSquares(for: lightTurn, state, moves)
		guard let validSquares = allValidSquares[piece] else {
			return false
		}
		
		return validSquares.contains(newSquare)
	}
	
	private func computeKingState(for lightTurn: Bool, _ state: Chess.Pieces, _ moves: [Chess.Move]) -> Chess.KingState {
		guard state.compactMap({ piece in piece }).count > 2 else {
			return .stalemate
		}
		
		guard let kingSquareIndex = state.firstIndex(where: { piece in piece?.group == .king && piece?.isLight == lightTurn }) else {
			return .checkmate
		}
		let kingSquare = Chess.Pieces.square(at: kingSquareIndex)
		
		// Check checkmate
		let allPieceMoves = allValidSquares(for: lightTurn, state, moves)
		let allMovesCount = allPieceMoves.values.reduce(0, { movesCount, moves in movesCount + moves.count })
		let canMoveSomePiece = allMovesCount > 0
		let opponentAttackedSquares = attackedSquares(from: state, for: lightTurn)
		let kingSafe = !opponentAttackedSquares.contains(kingSquare)
		guard kingSafe else {
			return canMoveSomePiece ? .check : .checkmate
		}
		
		// Check stalemate
		return canMoveSomePiece ? .ok : .stalemate
	}
	
	func computeKingStates(for lightTurn: Bool, _ state: Chess.Pieces, _ moves: [Chess.Move]) -> Chess.KingStates {
		let kingState = computeKingState(for: lightTurn, state, moves)
		guard lightTurn else {
			return Chess.KingStates(light: .ok, dark: kingState)
		}
		return Chess.KingStates(light: kingState, dark: .ok)
	}
}
