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
				ForEach(theme.colors.sorted(by: { $0.target < $1.target })) { themeColor in
					Image(systemName: "circle")
						.symbolVariant(.fill)
						.foregroundStyle(themeColor.color)
						.padding(5)
						.background(.ultraThinMaterial)
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
