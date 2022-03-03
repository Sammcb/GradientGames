//
//  NewCheckersThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 3/3/22.
//

import SwiftUI

struct NewCheckersThemeView: View {
	@Environment(\.managedObjectContext) private var context
	@Environment(\.presentationMode) private var mode
	@FetchRequest(sortDescriptors: [SortDescriptor(\CheckersTheme.index, order: .forward)]) private var themes: FetchedResults<CheckersTheme>
	@State private var symbol: String = ""
	@State private var squareLight: Color = .clear
	@State private var squareDark: Color = .clear
	@State private var pieceLight: Color = .clear
	@State private var pieceDark: Color = .clear
	
	var body: some View {
		NavigationView {
			Form {
				Section("Symbol") {
					TextField("Symbol", text: $symbol)
				}
				
				Section("Colors") {
					ColorPicker("Light squares", selection: $squareLight, supportsOpacity: false)
					ColorPicker("Dark squares", selection: $squareDark, supportsOpacity: false)
					ColorPicker("Light pieces", selection: $pieceLight, supportsOpacity: false)
					ColorPicker("Dark pieces", selection: $pieceDark, supportsOpacity: false)
				}
			}
			.toolbar {
				Button("Done") {
					let themeCount = Int(themes.last?.index ?? -1)
					let theme = CheckersTheme(context: context)
					theme.id = UUID()
					theme.symbol = symbol
					theme.squareLightRaw = UIColor(squareLight).hex
					theme.squareDarkRaw = UIColor(squareDark).hex
					theme.pieceLightRaw = UIColor(pieceLight).hex
					theme.pieceDarkRaw = UIColor(pieceDark).hex
					theme.index = Int64(themeCount + 1)
					Store.shared.save()
					mode.wrappedValue.dismiss()
				}
			}
			.navigationTitle("Add checkers theme")
		}
	}
}
