//
//  NewChessThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

#if !os(tvOS)
import SwiftUI

struct NewChessThemeView: View {
	@Environment(\.managedObjectContext) private var context
	@Environment(\.dismiss) private var dismiss
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var themes: FetchedResults<ChessTheme>
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
					let theme = ChessTheme(context: context)
					theme.id = UUID()
					theme.symbol = symbol
					theme.squareLightRaw = UIColor(squareLight).hex
					theme.squareDarkRaw = UIColor(squareDark).hex
					theme.pieceLightRaw = UIColor(pieceLight).hex
					theme.pieceDarkRaw = UIColor(pieceDark).hex
					theme.index = Int64(themeCount + 1)
					Store.shared.save()
					dismiss()
				}
			}
			.navigationTitle("Add chess theme")
		}
	}
}
#endif
