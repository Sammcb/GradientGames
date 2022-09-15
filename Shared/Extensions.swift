//
//  Extensions.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import UIKit.UIColor

extension UIColor {
	convenience init(hex: Int64) {
		let uhex = UInt32(hex)
		let red = (uhex & 0xff0000) >> 16
		let green = (uhex & 0x00ff00) >> 8
		let blue = uhex & 0x0000ff
		self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
	}
	
	public var hex: Int64 {
		let components = cgColor.components!
		let red = UInt32(components[0] * 255)
		let greeen = UInt32(components[1] * 255)
		let blue = UInt32(components[2] * 255)
		return Int64((red << 16) | (greeen << 8) | blue)
	}
}

extension ChessTheme: Theme {
	static func ==(lhs: ChessTheme, rhs: ChessTheme) -> Bool {
		lhs.id == rhs.id
	}

	var squareLight: UIColor {
		UIColor(hex: squareLightRaw)
	}
	var squareDark: UIColor {
		UIColor(hex: squareDarkRaw)
	}
	var pieceLight: UIColor {
		UIColor(hex: pieceLightRaw)
	}
	var pieceDark: UIColor {
		UIColor(hex: pieceDarkRaw)
	}
}

extension ReversiTheme: Theme {
	static func ==(lhs: ReversiTheme, rhs: ReversiTheme) -> Bool {
		lhs.id == rhs.id
	}
	
	var square: UIColor {
		UIColor(hex: squareRaw)
	}
	var border: UIColor {
		UIColor(hex: borderRaw)
	}
	var pieceLight: UIColor {
		UIColor(hex: pieceLightRaw)
	}
	var pieceDark: UIColor {
		UIColor(hex: pieceDarkRaw)
	}
}

extension CheckersTheme: Theme {
	static func ==(lhs: CheckersTheme, rhs: CheckersTheme) -> Bool {
		lhs.id == rhs.id
	}

	var squareLight: UIColor {
		UIColor(hex: squareLightRaw)
	}
	var squareDark: UIColor {
		UIColor(hex: squareDarkRaw)
	}
	var pieceLight: UIColor {
		UIColor(hex: pieceLightRaw)
	}
	var pieceDark: UIColor {
		UIColor(hex: pieceDarkRaw)
	}
}
