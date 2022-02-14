//
//  ReversiPieceView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ReversiPieceView: View {
	@Environment(\.reversiTheme) private var theme
	let isLight: Bool
	
	var body: some View {
		Circle()
			.foregroundColor(isLight ? theme.pieceLight : theme.pieceDark)
	}
}
