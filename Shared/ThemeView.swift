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
	
	private var themeURL: URL {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "www.sammcb.com"
		components.path = UniversalLink.themePath
		var queryItems = [
			URLQueryItem(name: "symbol", value: theme.symbol),
			URLQueryItem(name: "game", value: theme.game.rawValue),
		]
		for themeColor in theme.colors {
			let colorHexString = hexFrom(themeColor.color)
			let colorQueryItem = URLQueryItem(name: themeColor.target.rawValue, value: colorHexString)
			queryItems.append(colorQueryItem)
		}
		components.queryItems = queryItems
		
		return components.url ?? URL(string: "https://www.sammcb.com")!
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
					ShareLink(item: themeURL)
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
