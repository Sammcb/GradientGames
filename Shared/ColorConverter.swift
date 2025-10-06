//
//  ColorConverter.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/21/24.
//

import SwiftUI

protocol ColorConverter {}

extension ColorConverter {
	func colorFrom(_ colorString: String) -> Color {
		guard let hex = UInt32(colorString, radix: 16) else {
			return Color.clear
		}

		let red = (hex & 0xff0000) >> 16
		let green = (hex & 0x00ff00) >> 8
		let blue = hex & 0x0000ff
		let resolvedColor = Color.Resolved(red: Float(red) / 255, green: Float(green) / 255, blue: Float(blue) / 255)
		return Color(resolvedColor)
	}

	func hexFrom(_ color: Color) -> String {
		let resolvedColor = color.resolve(in: EnvironmentValues())
		let redInt = UInt32(resolvedColor.red * 255)
		let greenInt = UInt32(resolvedColor.green * 255)
		let blueInt = UInt32(resolvedColor.blue * 255)
		let hexInt = (redInt << 16) | (greenInt << 8) | blueInt
		let shortHex = String(hexInt, radix: 16)
		return String(repeating: "0", count: 6 - shortHex.count) + shortHex
	}
}
