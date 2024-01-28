//
//  SchemaVersioning.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/27/24.
//

import SwiftData

typealias Theme = SchemaV1_0_0.Theme
typealias ChessBoard = SchemaV1_0_0.ChessBoard
typealias ReversiBoard = SchemaV1_0_0.ReversiBoard
typealias CheckersBoard = SchemaV1_0_0.CheckersBoard

enum MigrationPlan: SchemaMigrationPlan {
	static var schemas: [VersionedSchema.Type] = [SchemaV1_0_0.self]
	
	static var stages: [MigrationStage] = []
}

enum SchemaV1_0_0: VersionedSchema {
	static var models: [any PersistentModel.Type] = [Theme.self, ChessBoard.self, ReversiBoard.self, CheckersBoard.self]
	static var versionIdentifier = Schema.Version(1, 0, 0)
}
