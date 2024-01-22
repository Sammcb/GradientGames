//
//  macOSThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/20/24.
//

#if os(macOS)
import SwiftUI
import SwiftData

struct ThemeView: View {
	@Environment(\.dismiss) private var dismiss
	@Bindable var theme: Theme
	
	var body: some View {
		NavigationStack {
			Form {
				TextField("Symbol", text: $theme.symbol)
				
				ForEach($theme.colors.sorted(by: { $0.wrappedValue.target < $1.wrappedValue.target })) { $color in
					ColorPicker(color.target.displayName, selection: $color.color, supportsOpacity: false)
				}
			}
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					
					Button {
						dismiss()
					} label: {
						Label("Done", systemImage: "checkmark")
							.symbolVariant(.circle)
							.labelStyle(.titleOnly)
					}
				}
			}
			.navigationTitle("Details")
		}
		.padding()
		.frame(idealWidth: 250, idealHeight: 250, alignment: .top)
		.fixedSize()
	}
}
#endif
