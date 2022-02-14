//
//  ImportChessThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ColorDisplay: View {
	let color: Color
	
	var body: some View {
		Image(systemName: "circle")
			.symbolVariant(.fill)
			.foregroundColor(color)
			.padding(1)
			.background(Circle().foregroundColor(.primary))
	}
}

struct ImportChessThemeView: View {
	@Environment(\.managedObjectContext) private var context
	@Environment(\.presentationMode) private var mode
	@EnvironmentObject private var navigation: Navigation
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var themes: FetchedResults<ChessTheme>
	
	var body: some View {
		NavigationView {
			List {
				Section("Symbol") {
					Text(navigation.chessSymbol)
				}
				
				Section("Colors") {
					Label {
						Text("Light squares")
					} icon: {
						ColorDisplay(color: navigation.chessSquareLight)
					}
					
					Label {
						Text("Dark squares")
					} icon: {
						ColorDisplay(color: navigation.chessSquareDark)
					}
					
					Label {
						Text("Light pieces")
					} icon: {
						ColorDisplay(color: navigation.chessPieceLight)
					}
					
					Label {
						Text("Dark pieces")
					} icon: {
						ColorDisplay(color: navigation.chessPieceDark)
					}
				}
			}
			.toolbar {
				Button("Done") {
					let themeCount = Int(themes.last?.index ?? -1)
					let theme = ChessTheme(context: context)
					theme.id = UUID()
					theme.symbol = navigation.chessSymbol
					theme.squareLightRaw = UIColor(navigation.chessSquareLight).hex
					theme.squareDarkRaw = UIColor(navigation.chessSquareDark).hex
					theme.pieceLightRaw = UIColor(navigation.chessPieceLight).hex
					theme.pieceDarkRaw = UIColor(navigation.chessPieceDark).hex
					theme.index = Int64(themeCount + 1)
					Store.shared.save()
					mode.wrappedValue.dismiss()
				}
			}
			.navigationTitle("Import chess theme")
		}
	}
}
