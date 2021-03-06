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
		GeometryReader { geometry in
			Circle()
				.foregroundColor(isLight ? theme.pieceLight : theme.pieceDark)
				.overlay {
					Circle()
						.scale(0.5)
						.stroke(isLight ? theme.pieceDark : theme.pieceLight, style: StrokeStyle(lineWidth: geometry.size.width / 16))
						.opacity(kinged ? 1 : 0)
				}
		}
	}
}
