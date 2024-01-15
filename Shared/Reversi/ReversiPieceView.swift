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
		Circle()
			.foregroundStyle(isLight ? theme.pieceLight : theme.pieceDark)
	}
}
