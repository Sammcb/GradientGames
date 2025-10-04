//
//  Times.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import Foundation

struct Times: Codable {
	var light: TimeInterval
	var dark: TimeInterval
	var lastUpdate: Date

	func stringFor(lightTime: Bool) -> String {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.minute, .second]
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		guard let formattedString = formatter.string(from: lightTime ? light : dark) else {
			return "--:--"
		}
		return formattedString
	}
}
