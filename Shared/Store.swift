//
//  Store.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import CoreData

struct Store {
	static let shared = Store()
	
	let container = NSPersistentCloudKitContainer(name: "GradientGames")
	
	private init() {
		container.loadPersistentStores() { storeDescription, error in
			guard error == nil else {
				fatalError("\(error!)")
			}
		}
		
		container.viewContext.automaticallyMergesChangesFromParent = true
	}
	
	func save() {
		guard container.viewContext.hasChanges else {
			return
		}
		
		do {
			try container.viewContext.save()
		} catch {
			fatalError("\(error)")
		}
	}
}
