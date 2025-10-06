//
//  ReversiPieceView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiPieceView: View {
	@Environment(\.reversiTheme) private var theme
	var isLight: Bool

	var body: some View {
		Image(systemName: "circle")
			.resizable()
			.symbolVariant(.fill)
			.foregroundStyle(isLight ? theme.colors[.pieceLight] : theme.colors[.pieceDark])
			.scaledToFit()
			.scaleEffect(0.75)
	}
}
