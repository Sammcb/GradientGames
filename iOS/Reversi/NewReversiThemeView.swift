//
//  NewReversiThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct NewReversiThemeView: View {
	@Environment(\.managedObjectContext) private var context
	@Environment(\.dismiss) private var dismiss
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var themes: FetchedResults<ReversiTheme>
	@State private var symbol: String = ""
	@State private var square: Color = .clear
	@State private var border: Color = .clear
	@State private var pieceLight: Color = .clear
	@State private var pieceDark: Color = .clear
	
	var body: some View {
		NavigationView {
			Form {
				Section("Symbol") {
					TextField("Symbol", text: $symbol)
				}
				
				Section("Colors") {
					ColorPicker("Squares", selection: $square, supportsOpacity: false)
					ColorPicker("Border", selection: $border, supportsOpacity: false)
					ColorPicker("Light pieces", selection: $pieceLight, supportsOpacity: false)
					ColorPicker("Dark pieces", selection: $pieceDark, supportsOpacity: false)
				}
			}
			.toolbar {
				Button("Done") {
					let themeCount = Int(themes.last?.index ?? -1)
					let theme = ReversiTheme(context: context)
					theme.id = UUID()
					theme.symbol = symbol
					theme.squareRaw = UIColor(square).hex
					theme.borderRaw = UIColor(border).hex
					theme.pieceLightRaw = UIColor(pieceLight).hex
					theme.pieceDarkRaw = UIColor(pieceDark).hex
					theme.index = Int64(themeCount + 1)
					Store.shared.save()
					dismiss()
				}
			}
			.navigationTitle("Add reversi theme")
		}
	}
}
