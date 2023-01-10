//
//  SettingsView.swift
//  GradientGames
//
//  Created by Sam McBroom on 2/13/22.
//
#if !os(tvOS)
import SwiftUI
import CoreData.NSManagedObject

struct SettingsView: View {
	private enum SheetId: String, Identifiable {
		case newChess
		case newReversi
		case newCheckers
		
		var id: String {
			rawValue
		}
	}
	
	@Environment(\.managedObjectContext) private var context
	@EnvironmentObject private var navigation: Navigation
	@FetchRequest(sortDescriptors: [SortDescriptor(\ChessTheme.index, order: .forward)]) private var chessThemes: FetchedResults<ChessTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\ReversiTheme.index, order: .forward)]) private var reversiThemes: FetchedResults<ReversiTheme>
	@FetchRequest(sortDescriptors: [SortDescriptor(\CheckersTheme.index, order: .forward)]) private var checkersThemes: FetchedResults<CheckersTheme>
	@AppStorage(Setting.chessTheme.rawValue) private var chessTheme = ""
	@AppStorage(Setting.chessEnableUndo.rawValue) private var chessEnableUndo = true
	@AppStorage(Setting.chessEnableTimer.rawValue) private var chessEnableTimer = true
	@AppStorage(Setting.reversiTheme.rawValue) private var reversiTheme = ""
	@AppStorage(Setting.reversiEnableUndo.rawValue) private var reversiEnableUndo = true
	@AppStorage(Setting.reversiEnableTimer.rawValue) private var reversiEnableTimer = true
	@AppStorage(Setting.checkersTheme.rawValue) private var checkersTheme = ""
	@AppStorage(Setting.checkersEnableUndo.rawValue) private var checkersEnableUndo = true
	@AppStorage(Setting.checkersEnableTimer.rawValue) private var checkersEnableTimer = true
#if !targetEnvironment(macCatalyst)
	@AppStorage(Setting.chessFlipUI.rawValue) private var chessFlipUI = false
	@AppStorage(Setting.reversiFlipUI.rawValue) private var reversiFlipUI = false
	@AppStorage(Setting.checkersFlipUI.rawValue) private var checkersFlipUI = false
#endif
	
	@State private var sheet: SheetId? = nil
	@State private var selectedTheme: UUID? = nil
	
	private func deleteTheme(for themeObjects: [NSManagedObject], at indexSet: IndexSet) {
		for index in indexSet {
			context.delete(themeObjects[index])
		}
		
		var deleted = 0
		let themes = themeObjects as! [Theme]
		for (index, theme) in themes.enumerated() {
			guard !indexSet.contains(index) else {
				deleted += 1
				continue
			}
			if theme.index != index - deleted {
				theme.index = Int64(index - deleted)
			}
		}
		Store.shared.save()
	}
	
	private func moveThemeRow(for themes: [any Theme], from offsets: IndexSet, to offset: Int) {
		var themes = themes
		themes.move(fromOffsets: offsets, toOffset: offset)
		for (index, themeRow) in themes.enumerated() {
			if themeRow.index != index {
				themeRow.index = Int64(index)
			}
		}
		Store.shared.save()
	}
	
	var body: some View {
		Form {
			Section("Chess") {
				Toggle(isOn: $chessEnableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
						.symbolVariant(.circle.fill)
				}
				Toggle(isOn: $chessEnableTimer) {
					Label("Timers", systemImage: "clock")
						.symbolVariant(.fill)
				}
#if !targetEnvironment(macCatalyst)
				Toggle(isOn: $chessFlipUI) {
					Label("Flip UI each turn", systemImage: "arrow.up.arrow.down")
						.symbolVariant(.circle.fill)
				}
#endif
			}
			.headerProminence(.increased)
			
			Section("Theme") {
				List(selection: $selectedTheme) {
					ForEach(chessThemes) { theme in
						let themeSelected = chessTheme == theme.id!.uuidString
						NavigationLink(value: theme.id) {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: themeSelected ? "checkmark.circle.fill" : "circle")
									.foregroundColor(themeSelected ? .green : .gray)
							}
						}
						.swipeActions(edge: .leading) {
							Button {
								chessTheme = themeSelected ? "" : theme.id!.uuidString
							} label: {
								if themeSelected {
									Label("Deselect", systemImage: "xmark")
								} else {
									Label("Select", systemImage: "checkmark")
								}
							}
						}
						.tint(chessTheme == theme.id!.uuidString ? .gray : .green)
					}
					.onDelete { indexSet in
						deleteTheme(for: Array(chessThemes), at: indexSet)
					}
					.onMove { indexSet, index in
						moveThemeRow(for: Array(chessThemes), from: indexSet, to: index)
					}
				}
				
				Button {
					sheet = .newChess
				} label: {
					Label("Create theme", systemImage: "plus")
				}
			}
			
			Section("Reversi") {
				Toggle(isOn: $reversiEnableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
						.symbolVariant(.circle.fill)
				}
				Toggle(isOn: $reversiEnableTimer) {
					Label("Timers", systemImage: "clock")
						.symbolVariant(.fill)
				}
#if !targetEnvironment(macCatalyst)
				Toggle(isOn: $reversiFlipUI) {
					Label("Flip UI each turn", systemImage: "arrow.up.arrow.down")
						.symbolVariant(.circle.fill)
				}
#endif
			}
			.headerProminence(.increased)
			
			Section("Theme") {
				List(selection: $selectedTheme) {
					ForEach(reversiThemes) { theme in
						let themeSelected = reversiTheme == theme.id!.uuidString
						NavigationLink(value: theme.id) {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: themeSelected ? "checkmark.circle.fill" : "circle")
									.foregroundColor(themeSelected ? .green : .gray)
							}
						}
						.swipeActions(edge: .leading) {
							Button {
								reversiTheme = themeSelected ? "" : theme.id!.uuidString
							} label: {
								Label(themeSelected ? "Deselect": "Select", systemImage: themeSelected ? "xmark" : "checkmark")
							}
						}
						.tint(reversiTheme == theme.id!.uuidString ? .gray : .green)
					}
					.onDelete { indexSet in
						deleteTheme(for: Array(reversiThemes), at: indexSet)
					}
					.onMove { indexSet, index in
						moveThemeRow(for: Array(reversiThemes), from: indexSet, to: index)
					}
					
					Button {
						sheet = .newReversi
					} label: {
						Label("Create theme", systemImage: "plus")
					}
				}
			}
			
			Section("Checkers") {
				Toggle(isOn: $checkersEnableUndo) {
					Label("Undos", systemImage: "arrow.uturn.backward")
						.symbolVariant(.circle.fill)
				}
				Toggle(isOn: $checkersEnableTimer) {
					Label("Timers", systemImage: "clock")
						.symbolVariant(.fill)
				}
#if !targetEnvironment(macCatalyst)
				Toggle(isOn: $checkersFlipUI) {
					Label("Flip UI each turn", systemImage: "arrow.up.arrow.down")
						.symbolVariant(.circle.fill)
				}
#endif
			}
			.headerProminence(.increased)
			
			Section("Theme") {
				List(selection: $selectedTheme) {
					ForEach(checkersThemes) { theme in
						let themeSelected = checkersTheme == theme.id!.uuidString
						NavigationLink(value: theme.id) {
							Label {
								Text(theme.symbol!)
							} icon: {
								Image(systemName: themeSelected ? "checkmark.circle.fill" : "circle")
									.foregroundColor(themeSelected ? .green : .gray)
							}
						}
						.swipeActions(edge: .leading) {
							Button {
								checkersTheme = themeSelected ? "" : theme.id!.uuidString
							} label: {
								if themeSelected {
									Label("Deselect", systemImage: "xmark")
								} else {
									Label("Select", systemImage: "checkmark")
								}
							}
						}
						.tint(themeSelected ? .gray : .green)
					}
					.onDelete { indexSet in
						deleteTheme(for: Array(checkersThemes), at: indexSet)
					}
					.onMove { indexSet, index in
						moveThemeRow(for: Array(checkersThemes), from: indexSet, to: index)
					}
					
					Button {
						sheet = .newCheckers
					} label: {
						Label("Create theme", systemImage: "plus")
					}
				}
			}
		}
		.navigationDestination(for: UUID.self) { themeId in
			if let theme = chessThemes.first(where: { $0.id == themeId}) {
				EditChessThemeView(theme)
			} else if let theme = reversiThemes.first(where: { $0.id == themeId}) {
				EditReversiThemeView(theme)
			} else if let theme = checkersThemes.first(where: { $0.id == themeId}) {
				EditCheckersThemeView(theme)
			}
		}
		.sheet(item: $sheet) { sheet in
			switch sheet {
			case .newChess:
				NewChessThemeView()
			case .newReversi:
				NewReversiThemeView()
			case .newCheckers:
				NewCheckersThemeView()
			}
		}
		.onReceive(navigation.$themeLinkOpened) { themeLinkOpened in
			guard themeLinkOpened else {
				return
			}
			
			sheet = nil
			navigation.themeLinkOpened = false
		}
		.navigationTitle("Settings")
	}
}
#endif
