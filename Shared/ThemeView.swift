//
//  ThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 12/8/23.
//

import SwiftUI
import SwiftData

#if !os(tvOS)
struct ThemeView: View, ColorConverter {
	@Environment(\.dismiss) private var dismiss
	@Bindable var theme: Theme

	private var themeData: String {
		return ThemesDocument([theme]).toString()
	}

	var body: some View {
		NavigationStack {
			Form {
				Section("Symbol") {
					TextField("Symbol", text: $theme.symbol)
						.lineLimit(1)
				}

				Section("Colors") {
					ForEach($theme.colors.sorted(by: { $0.wrappedValue.target < $1.wrappedValue.target })) { $color in
						ColorPicker(color.target.displayName, selection: $color.color, supportsOpacity: false)
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button {
						dismiss()
					} label: {
						Label("Done", systemImage: "checkmark")
					}
				}
				ToolbarItem {
					ShareLink(item: themeData)
				}
			}
#if os(macOS)
			.formStyle(.grouped)
			.fixedSize()
#endif
			.navigationTitle("Theme")
		}
	}
}
#endif
