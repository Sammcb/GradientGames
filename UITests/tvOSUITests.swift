//
//  tvOSUITests.swift
//  GradientGames
//
//  Created by Sam McBroom on 7/30/25.
//

import XCTest

final class tvOSUITests: XCTestCase {
	override func setUpWithError() throws {
		continueAfterFailure = false
	}
	
	override func tearDownWithError() throws {}
	
	@MainActor
	private func takeScreenshot() {
		let screenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
		screenshot.name = UUID().uuidString
		add(screenshot)
	}
	
	@MainActor
	private func waitForFocusOn(element: XCUIElement) {
		XCTAssert(element.wait(for: \.hasFocus, toEqual: true, timeout: 2))
	}
	
	@MainActor
	private func pressRemote(_ button: XCUIRemote.Button, times: Int) {
		for _ in 0 ..< times {
			XCUIRemote.shared.press(button)
		}
	}
	
	@MainActor
	private func pressGameBoardButton(identifier: String, app: XCUIApplication) {
		waitForFocusOn(element: app.buttons[identifier])
		XCUIRemote.shared.press(.select)
		Thread.sleep(forTimeInterval: 1)
	}
	
	@MainActor
	private func pressChessSquareAt(file: String, rank: String, app: XCUIApplication) {
		pressGameBoardButton(identifier: "File\(file)Rank\(rank)ChessBoardSquareButton", app: app)
	}
	
	@MainActor
	private func pressReversiSquareAt(row: String, column: String, app: XCUIApplication) {
		pressGameBoardButton(identifier: "Row\(row)Column\(column)ReversiBoardSquareButton", app: app)
	}
	
	@MainActor
	private func pressCheckersSquareAt(row: String, column: String, app: XCUIApplication) {
		pressGameBoardButton(identifier: "Row\(row)Column\(column)CheckersBoardSquareButton", app: app)
	}
	
	@MainActor
	private func prepareToSwitchTheme(expectedFocusLabel: String, app: XCUIApplication) {
		waitForFocusOn(element: app.buttons["Themes"])
		XCUIRemote.shared.press(.select)
		waitForFocusOn(element: app.cells[expectedFocusLabel].firstMatch)
	}
	
	@MainActor
	private func switchTheme(expectedFocusLabel: String, downPresses: Int, app: XCUIApplication) {
		pressRemote(.down, times: downPresses)
		waitForFocusOn(element: app.cells[expectedFocusLabel].firstMatch)
		XCUIRemote.shared.press(.select)
	}
	
	@MainActor
	func testPlayAllGamesAndChangeThemes() throws {
		let app = XCUIApplication()
		app.launch()
		
		let remote = XCUIRemote.shared
		
		// Reset themes
		pressRemote(.down, times: 3)
		waitForFocusOn(element: app.cells.containing(.button, identifier: "Settings").firstMatch)
		remote.press(.select)
		waitForFocusOn(element: app.cells["Undos"])
		pressRemote(.down, times: 4)
		waitForFocusOn(element: app.cells["Delete All Themes"])
		remote.press(.select)
		Thread.sleep(forTimeInterval: 1)
		remote.press(.up)
		remote.press(.select)
		waitForFocusOn(element: app.cells["Delete All Themes"])
		remote.press(.up)
		waitForFocusOn(element: app.textFields["Theme Data JSON"])
		remote.press(.select)
		app.textViews.element.typeText("\(TestData.themeData)\r")
		waitForFocusOn(element: app.alerts.buttons["OK"].firstMatch)
		remote.press(.select)
		waitForFocusOn(element: app.textFields["Theme Data JSON"])
		
		// Reset games
		remote.press(.menu)
		waitForFocusOn(element: app.cells.containing(.button, identifier: "Chess").firstMatch)
		remote.press(.select, forDuration: 1)
		waitForFocusOn(element: app.cells.containing(.button, identifier: "New game").firstMatch)
		pressRemote(.select, times: 2)
		waitForFocusOn(element: app.cells["Undos"])
		remote.press(.menu)
		remote.press(.down)
		waitForFocusOn(element: app.cells.containing(.button, identifier: "Reversi").firstMatch)
		remote.press(.select, forDuration: 1)
		waitForFocusOn(element: app.cells.containing(.button, identifier: "New game").firstMatch)
		pressRemote(.select, times: 2)
		waitForFocusOn(element: app.cells["Undos"])
		remote.press(.menu)
		pressRemote(.down, times: 2)
		waitForFocusOn(element: app.cells.containing(.button, identifier: "Checkers").firstMatch)
		remote.press(.select, forDuration: 1)
		waitForFocusOn(element: app.cells.containing(.button, identifier: "New game").firstMatch)
		pressRemote(.select, times: 2)
		waitForFocusOn(element: app.cells["Undos"])
		remote.press(.menu)
		
		// Open chess
		waitForFocusOn(element: app.cells.containing(.button, identifier: "Chess").firstMatch)
		remote.press(.select)
		waitForFocusOn(element: app.buttons["FileaRank8ChessBoardSquareButton"])
		
		// Play chess
		pressRemote(.down, times: 6)
		pressRemote(.right, times: 2)
		pressChessSquareAt(file: "c", rank: "2", app: app)
		takeScreenshot()
		pressRemote(.up, times: 2)
		pressChessSquareAt(file: "c", rank: "4", app: app)
		
		pressRemote(.up, times: 4)
		pressRemote(.right, times: 6)
		prepareToSwitchTheme(expectedFocusLabel: "🌑, Selected", app: app)
		switchTheme(expectedFocusLabel: "🍁", downPresses: 4, app: app)
		remote.press(.menu)
		waitForFocusOn(element: app.buttons["Themes"])
		
		pressRemote(.left, times: 5)
		remote.press(.down)
		pressChessSquareAt(file: "d", rank: "7", app: app)
		pressRemote(.down, times: 2)
		pressChessSquareAt(file: "d", rank: "5", app: app)
		
		pressRemote(.up, times: 3)
		pressRemote(.right, times: 5)
		prepareToSwitchTheme(expectedFocusLabel: "🌑", app: app)
		switchTheme(expectedFocusLabel: "🌸", downPresses: 6, app: app)
		remote.press(.menu)
		waitForFocusOn(element: app.buttons["Themes"])
		
		pressRemote(.left, times: 6)
		pressRemote(.down, times: 4)
		pressChessSquareAt(file: "c", rank: "4", app: app)
		remote.press(.right)
		remote.press(.up)
		pressChessSquareAt(file: "d", rank: "5", app: app)
		
		pressRemote(.up, times: 3)
		pressRemote(.right, times: 5)
		prepareToSwitchTheme(expectedFocusLabel: "🌑", app: app)
		switchTheme(expectedFocusLabel: "🌲", downPresses: 2, app: app)
		remote.press(.menu)
		waitForFocusOn(element: app.buttons["Themes"])
		
		pressRemote(.left, times: 5)
		pressChessSquareAt(file: "d", rank: "8", app: app)
		takeScreenshot()
		pressRemote(.down, times: 3)
		pressChessSquareAt(file: "d", rank: "5", app: app)
		remote.press(.menu)
		
		// Open reversi
		waitForFocusOn(element: app.cells.containing(.button, identifier: "Chess").firstMatch)
		remote.press(.down)
		waitForFocusOn(element: app.cells.containing(.button, identifier: "Reversi").firstMatch)
		remote.press(.select)
		waitForFocusOn(element: app.buttons["Row8Column1ReversiBoardSquareButton"])
		
		// Play reversi
		pressRemote(.down, times: 2)
		pressRemote(.right, times: 3)
		takeScreenshot()
		pressReversiSquareAt(row: "6", column: "4", app: app)
		
		pressRemote(.up, times: 2)
		pressRemote(.right, times: 5)
		prepareToSwitchTheme(expectedFocusLabel: "🥝, Selected", app: app)
		switchTheme(expectedFocusLabel: "🌊", downPresses: 1, app: app)
		remote.press(.menu)
		waitForFocusOn(element: app.buttons["Themes"])
		
		pressRemote(.left, times: 6)
		pressRemote(.down, times: 2)
		pressReversiSquareAt(row: "6", column: "3", app: app)
		
		pressRemote(.up, times: 2)
		pressRemote(.right, times: 6)
		prepareToSwitchTheme(expectedFocusLabel: "🥝", app: app)
		switchTheme(expectedFocusLabel: "☀️", downPresses: 7, app: app)
		remote.press(.menu)
		waitForFocusOn(element: app.buttons["Themes"])
		
		pressRemote(.left, times: 6)
		pressRemote(.down, times: 3)
		takeScreenshot()
		pressReversiSquareAt(row: "5", column: "3", app: app)
		
		pressRemote(.up, times: 3)
		pressRemote(.right, times: 6)
		prepareToSwitchTheme(expectedFocusLabel: "🥝", app: app)
		switchTheme(expectedFocusLabel: "🌑", downPresses: 3, app: app)
		remote.press(.menu)
		waitForFocusOn(element: app.buttons["Themes"])
		
		pressRemote(.left, times: 4)
		pressRemote(.down, times: 2)
		pressReversiSquareAt(row: "6", column: "5", app: app)
		remote.press(.menu)
		
		// Open checkers
		waitForFocusOn(element: app.cells.containing(.button, identifier: "Chess").firstMatch)
		pressRemote(.down, times: 2)
		waitForFocusOn(element: app.cells.containing(.button, identifier: "Checkers").firstMatch)
		remote.press(.select)
		waitForFocusOn(element: app.buttons["Row8Column1CheckersBoardSquareButton"])
		
		// Play checkers
		pressRemote(.down, times: 5)
		pressRemote(.right, times: 2)
		pressCheckersSquareAt(row: "3", column: "3", app: app)
		takeScreenshot()
		remote.press(.right)
		remote.press(.up)
		pressCheckersSquareAt(row: "4", column: "4", app: app)
		
		pressRemote(.up, times: 4)
		pressRemote(.right, times: 5)
		prepareToSwitchTheme(expectedFocusLabel: "☕️, Selected", app: app)
		switchTheme(expectedFocusLabel: "🌸", downPresses: 6, app: app)
		remote.press(.menu)
		waitForFocusOn(element: app.buttons["Themes"])
		
		pressRemote(.left, times: 3)
		pressRemote(.down, times: 2)
		pressCheckersSquareAt(row: "6", column: "6", app: app)
		remote.press(.left)
		remote.press(.down)
		pressCheckersSquareAt(row: "5", column: "5", app: app)
		
		pressRemote(.up, times: 3)
		pressRemote(.right, times: 4)
		prepareToSwitchTheme(expectedFocusLabel: "☕️", app: app)
		switchTheme(expectedFocusLabel: "❄️", downPresses: 5, app: app)
		remote.press(.menu)
		waitForFocusOn(element: app.buttons["Themes"])
		
		pressRemote(.left, times: 5)
		pressRemote(.down, times: 4)
		pressCheckersSquareAt(row: "4", column: "4", app: app)
		takeScreenshot()
		pressRemote(.right, times: 2)
		pressRemote(.up, times: 2)
		pressCheckersSquareAt(row: "6", column: "6", app: app)
		
		pressRemote(.up, times: 2)
		pressRemote(.right, times: 3)
		prepareToSwitchTheme(expectedFocusLabel: "☕️", app: app)
		switchTheme(expectedFocusLabel: "🍁", downPresses: 4, app: app)
		remote.press(.menu)
		waitForFocusOn(element: app.buttons["Themes"])
		
		pressRemote(.left, times: 2)
		remote.press(.down)
		pressCheckersSquareAt(row: "7", column: "7", app: app)
		pressRemote(.left, times: 2)
		pressRemote(.down, times: 2)
		pressCheckersSquareAt(row: "5", column: "5", app: app)
	}
}
