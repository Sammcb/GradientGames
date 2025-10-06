//
//  ThemeListEntryView.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/22/24.
//

import SwiftUI

struct ThemeListEntryView: View {
	let theme: Theme
	let selected: Bool

	var body: some View {
		HStack {
			Text(theme.symbol)
			HStack {
				let rainbow: [Color] = [.red, .yellow, .green, .blue, .purple, .red]
				ForEach(theme.colors.sorted(by: { $0.target < $1.target })) { themeColor in
					Image(systemName: "circle")
						.symbolVariant(.fill)
						.foregroundStyle(themeColor.color)
						.padding(2)
						.background(.angularGradient(colors: rainbow, center: .center, startAngle: .zero, endAngle: .radians(2 * .pi)))
						.clipShape(Circle())
				}
			}
			.frame(maxWidth: .infinity, alignment: .trailing)
			Label("Selected", systemImage: "checkmark")
				.symbolVariant(.circle.fill)
				.labelStyle(.iconOnly)
				.opacity(selected ? 1 : 0)
				.foregroundStyle(.green)
				.animation(.easeInOut(duration: 0.2), value: selected)
		}
	}
}
