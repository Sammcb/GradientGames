//
//  macOSThemesView.swift
//  GradientGames
//
//  Created by Sam McBroom on 1/21/24.
//

#if os(macOS)
import SwiftUI
import SwiftData

struct ThemesView: View {
	@Environment(\.modelContext) private var context
	@Environment(\.dismiss) private var dismiss
	@Query(sort: \Theme.index) private var themes: [Theme]
	@AppStorage(Setting.chessTheme.rawValue) private var chessTheme = ""
	@AppStorage(Setting.reversiTheme.rawValue) private var reversiTheme = ""
	@AppStorage(Setting.checkersTheme.rawValue) private var checkersTheme = ""
	@State private var sheetTheme: Theme?
	let game: Theme.Game
	
	private func deleteTheme(at indexSet: IndexSet) {
		let gameThemes = themes.filter({ $0.game == game })
		for gameThemeIndex in indexSet {
			let id = gameThemes[gameThemeIndex].id
			guard let theme = themes.first(where: { $0.id == id }) else {
				continue
			}
			
			context.delete(theme)
		}
		for (index, theme) in themes.filter({ $0.game == game }).enumerated() {
			theme.index = index
		}
	}
	
	private func moveTheme(from offsets: IndexSet, to offset: Int) {
		var ids = themes.filter({ $0.game == game }).map({ $0.id })
		ids.move(fromOffsets: offsets, toOffset: offset)
		for (index, id) in ids.enumerated() {
			guard let theme = themes.first(where: { $0.id == id }) else {
				continue
			}
			
			theme.index = index
		}
	}
	
	var body: some View {
		NavigationStack {
			Form {
				let gameThemes = themes.filter({ $0.game == game })
				List {
					ForEach(gameThemes) { theme in
						let themeSelected = switch game {
						case .chess: chessTheme == theme.id.uuidString
						case .reversi: reversiTheme == theme.id.uuidString
						case .checkers: checkersTheme == theme.id.uuidString
						}
						Button {
							switch game {
							case .chess: chessTheme = themeSelected ? "" : theme.id.uuidString
							case .reversi: reversiTheme = themeSelected ? "" : theme.id.uuidString
							case .checkers: checkersTheme = themeSelected ? "" : theme.id.uuidString
							}
						} label: {
							Text(theme.symbol)
							Spacer()
							Label("Selected", systemImage: "checkmark")
								.symbolVariant(.circle.fill)
								.labelStyle(.iconOnly)
								.opacity(themeSelected ? 1 : 0)
								.foregroundStyle(.green)
						}
						.buttonStyle(.borderless)
						.swipeActions(edge: .leading) {
							Button {
								sheetTheme = theme
							} label: {
								Label("Edit", systemImage: "pencil")
									.tint(.blue)
							}
						}
						.contextMenu {
							Button {
								sheetTheme = theme
							} label: {
								Label("Edit", systemImage: "pencil")
							}
							
							Button(role: .destructive) {
								guard let index = gameThemes.firstIndex(of: theme) else {
									return
								}
								deleteTheme(at: [index])
							} label: {
								Label("Delete", systemImage: "trash")
							}
						}
					}
					.onDelete(perform: deleteTheme)
					.onMove(perform: moveTheme)
					
					Button {
						let theme = Theme(game: game)
						if let lastThemeIndex = gameThemes.last?.index {
							theme.index = lastThemeIndex + 1
						}
						context.insert(theme)
						sheetTheme = theme
					} label: {
						Label("Create theme", systemImage: "plus")
					}
				}
			}
			.navigationTitle("Themes")
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
			.sheet(item: $sheetTheme) { selectedTheme in
				ThemeView(theme: selectedTheme)
			}
		}
		.padding()
		.frame(idealWidth: 500, idealHeight: 500)
		.fixedSize()
	}
}
#endif
