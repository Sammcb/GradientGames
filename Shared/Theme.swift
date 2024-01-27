//
//  Theme.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/9/24.
//

import SwiftData

typealias Theme = ThemeSchemaV1.Theme

enum ThemesMigrationPlan: SchemaMigrationPlan {
	static var schemas: [VersionedSchema.Type] = [ThemeSchemaV1.self]
	
	static var stages: [MigrationStage] = []
}
