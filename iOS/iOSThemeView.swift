//
//  iOSThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 12/8/23.
//

#if os(iOS)
import SwiftUI
import SwiftData

struct ThemeView: View {
	@Environment(\.dismiss) private var dismiss
	@Bindable var theme: Theme
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Symbol") {
					TextField("Symbol", text: $theme.symbol)
				}
				
				Section("Colors") {
					ForEach($theme.colors.sorted(by: { $0.wrappedValue.target < $1.wrappedValue.target })) { $color in
						ColorPicker(color.target.displayName, selection: $color.color, supportsOpacity: false)
					}
				}
			}
			.toolbar {
				ToolbarItem {
					Button {
						dismiss()
					} label: {
						Label("Done", systemImage: "checkmark")
							.symbolVariant(.circle)
							.labelStyle(.titleOnly)
					}
				}
			}
			.navigationTitle("Theme")
		}
	}
}
#endif
