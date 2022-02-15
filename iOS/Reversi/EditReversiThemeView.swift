//
//  EditReversiThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct EditReversiThemeView: View {
	@EnvironmentObject private var navigation: Navigation
	@State var theme: ReversiTheme
	@State private var symbol: String
	@State private var square: Color
	@State private var border: Color
	@State private var pieceLight: Color
	@State private var pieceDark: Color
	@State private var showShare = false
	
	init(_ theme: ReversiTheme) {
		symbol = theme.symbol!
		square = Color(theme.square)
		border = Color(theme.border)
		pieceLight = Color(theme.pieceLight)
		pieceDark = Color(theme.pieceDark)
		self.theme = theme
	}
	
	private func themeURL() -> URL {
		let pieceLightShortHex = String(UIColor(pieceLight).hex, radix: 16)
		let pieceLightHex = "#" + String(repeating: "0", count: 6 - pieceLightShortHex.count) + pieceLightShortHex
		let pieceDarkShortHex = String(UIColor(pieceDark).hex, radix: 16)
		let pieceDarkHex = "#" + String(repeating: "0", count: 6 - pieceDarkShortHex.count) + pieceDarkShortHex
		let squareShortHex = String(UIColor(square).hex, radix: 16)
		let squareHex = "#" + String(repeating: "0", count: 6 - squareShortHex.count) + squareShortHex
		let borderShortHex = String(UIColor(border).hex, radix: 16)
		let borderHex = "#" + String(repeating: "0", count: 6 - borderShortHex.count) + borderShortHex
		
		var components = URLComponents()
		components.scheme = "https"
		components.host = "www.sammcb.com"
		components.path = ThemeLink.reversi.rawValue
		components.queryItems = [
			URLQueryItem(name: "symbol", value: symbol),
			URLQueryItem(name: "pieceLight", value: pieceLightHex),
			URLQueryItem(name: "pieceDark", value: pieceDarkHex),
			URLQueryItem(name: "square", value: squareHex),
			URLQueryItem(name: "border", value: borderHex)
		]
		
		guard let url = components.url else {
			return URL(string: "https://www.sammcb.com")!
		}
		
		return url
	}
	
	var body: some View {
		Form {
			Section("Symbol") {
				TextField("Symbol", text: $symbol)
					.onChange(of: symbol) { _ in
						theme.symbol = symbol
						Store.shared.save()
					}
			}
			
			Section("Colors") {
				ColorPicker("Squares", selection: $square, supportsOpacity: false)
					.onChange(of: square) { _ in
						theme.squareRaw = UIColor(square).hex
						Store.shared.save()
					}
				ColorPicker("Border", selection: $border, supportsOpacity: false)
					.onChange(of: border) { _ in
						theme.borderRaw = UIColor(border).hex
						Store.shared.save()
					}
				ColorPicker("Light pieces", selection: $pieceLight, supportsOpacity: false)
					.onChange(of: pieceLight) { _ in
						theme.pieceLightRaw = UIColor(pieceLight).hex
						Store.shared.save()
					}
				ColorPicker("Dark pieces", selection: $pieceDark, supportsOpacity: false)
					.onChange(of: pieceDark) { _ in
						theme.pieceDarkRaw = UIColor(pieceDark).hex
						Store.shared.save()
					}
			}
		}
		.toolbar {
			Button {
				showShare = true
			} label: {
				Label("Share", systemImage: "square.and.arrow.up")
			}
		}
		.onChange(of: navigation.editing) { _ in
			showShare = false
		 }
		 .sheet(isPresented: $showShare) {
			 ShareSheet(activityItems: [themeURL()])
		 }
		.navigationTitle(symbol)
	}
}
