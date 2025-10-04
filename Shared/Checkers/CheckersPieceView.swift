//
//  CheckersPieceView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct CheckersPieceView: View {
	@Environment(\.checkersTheme) private var theme
	let isLight: Bool
	let kinged: Bool

	var body: some View {
		Image(systemName: "circle")
			.resizable()
			.symbolVariant(kinged ? .circle.fill : .fill)
			.foregroundStyle(isLight ? theme.colors[.pieceLight] : theme.colors[.pieceDark])
			.scaledToFit()
			.scaleEffect(0.75)
	}
}
