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
				let hueColors = stride(from: 0, to: 1, by: 0.01).map { hue in Color(hue: hue, saturation: 1, brightness: 1) }
				ForEach(theme.colors.sorted(by: { $0.target < $1.target })) { themeColor in
					Image(systemName: "circle")
						.symbolVariant(.fill)
						.foregroundStyle(themeColor.color)
						.padding(1)
						.background(.angularGradient(colors: hueColors, center: .center, startAngle: .zero, endAngle: .radians(2 * .pi)))
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
