//
//  EditChessThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct EditChessThemeView: View {
	@EnvironmentObject private var navigation: Navigation
	@State var theme: ChessTheme
	@State private var symbol: String
	@State private var squareLight: Color
	@State private var squareDark: Color
	@State private var pieceLight: Color
	@State private var pieceDark: Color
	
	init(_ theme: ChessTheme) {
		symbol = theme.symbol!
		squareLight = Color(theme.squareLight)
		squareDark = Color(theme.squareDark)
		pieceLight = Color(theme.pieceLight)
		pieceDark = Color(theme.pieceDark)
		self.theme = theme
	}
	
	private func themeURL() -> URL {
		let pieceLightShortHex = String(UIColor(pieceLight).hex, radix: 16)
		let pieceLightHex = "#" + String(repeating: "0", count: 6 - pieceLightShortHex.count) + pieceLightShortHex
		let pieceDarkShortHex = String(UIColor(pieceDark).hex, radix: 16)
		let pieceDarkHex = "#" + String(repeating: "0", count: 6 - pieceDarkShortHex.count) + pieceDarkShortHex
		let squareLightShortHex = String(UIColor(squareLight).hex, radix: 16)
		let squareLightHex = "#" + String(repeating: "0", count: 6 - squareLightShortHex.count) + squareLightShortHex
		let squareDarkShortHex = String(UIColor(squareDark).hex, radix: 16)
		let squareDarkHex = "#" + String(repeating: "0", count: 6 - squareDarkShortHex.count) + squareDarkShortHex
		
		var components = URLComponents()
		components.scheme = "https"
		components.host = "www.sammcb.com"
		components.path = "/ChessColors"
		components.queryItems = [
			URLQueryItem(name: "symbol", value: symbol),
			URLQueryItem(name: "pieceLight", value: pieceLightHex),
			URLQueryItem(name: "pieceDark", value: pieceDarkHex),
			URLQueryItem(name: "squareLight", value: squareLightHex),
			URLQueryItem(name: "squareDark", value: squareDarkHex)
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
				ColorPicker("Light squares", selection: $squareLight, supportsOpacity: false)
					.onChange(of: squareLight) { _ in
						theme.squareLightRaw = UIColor(squareLight).hex
						Store.shared.save()
					}
				ColorPicker("Dark squares", selection: $squareDark, supportsOpacity: false)
					.onChange(of: squareDark) { _ in
						theme.squareDarkRaw = UIColor(squareDark).hex
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
				navigation.sheet = .share
			} label: {
				Label("Share", systemImage: "square.and.arrow.up")
			}
		}
		.sheet(item: $navigation.sheet) { sheet in
			if sheet == .share {
				ShareSheet(activityItems: [themeURL()])
			}
		}
		.navigationTitle(symbol)
	}
}
