//
//  ImportReversiThemeView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//

import SwiftUI

struct ImportReversiThemeView: View {
	@Environment(\.managedObjectContext) private var context
	@Environment(\.presentationMode) private var mode
	@EnvironmentObject private var navigation: Navigation
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var themes: FetchedResults<ReversiTheme>
	
	var body: some View {
		NavigationView {
			List {
				Section("Symbol") {
					Text(navigation.reversiSymbol)
				}
				
				Section("Colors") {
					Label {
						Text("Squares")
					} icon: {
						ColorDisplay(color: navigation.reversiSquare)
					}
					
					Label {
						Text("Border")
					} icon: {
						ColorDisplay(color: navigation.reversiBorder)
					}
					
					Label {
						Text("Light pieces")
					} icon: {
						ColorDisplay(color: navigation.reversiPieceLight)
					}
					
					Label {
						Text("Dark pieces")
					} icon: {
						ColorDisplay(color: navigation.reversiPieceDark)
					}
				}
			}
			.toolbar {
				Button("Done") {
					let themeCount = Int(themes.last?.index ?? -1)
					let theme = ReversiTheme(context: context)
					theme.id = UUID()
					theme.symbol = navigation.reversiSymbol
					theme.squareRaw = UIColor(navigation.reversiSquare).hex
					theme.borderRaw = UIColor(navigation.reversiBorder).hex
					theme.pieceLightRaw = UIColor(navigation.reversiPieceLight).hex
					theme.pieceDarkRaw = UIColor(navigation.reversiPieceDark).hex
					theme.index = Int64(themeCount + 1)
					Store.shared.save()
					mode.wrappedValue.dismiss()
				}
			}
			.navigationTitle("Import reversi theme")
		}
	}
}
