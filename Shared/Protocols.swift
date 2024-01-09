//
//  Protocols.swift
//  GradientGames
//
//  Created by Sam McBroom on 9/14/22.
//

import SwiftUI

protocol Game {
	func reset()
}

protocol ColorConverter {
	func colorFrom(_ colorString: String) -> Color
	func hexFrom(_ color: Color) -> String
}
