//
//  Protocols.swift
//  GradientGames
//
//  Created by Sam McBroom on 9/14/22.
//

import CoreData.NSFetchRequest

protocol Theme: NSFetchRequestResult {
	var id: UUID? { get set }
	var index: Int64 { get set }
}

protocol GameState {
	func reset()
}

protocol UniversalLinkReciever {
	func parseUniversalLink(_ url: URL) throws -> ThemeField
}
