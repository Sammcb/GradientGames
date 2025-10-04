//
//  macOSUITests.swift
//  GradientGames
//
//  Created by Sam McBroom on 7/28/25.
//

import XCTest

final class macOSUITests: XCTestCase {
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
	private func switchTheme(to themeSymbol: String, for game: String, app: XCUIApplication) {
		app.windows[game.capitalized].toolbars.element.buttons["Themes"].firstMatch.click()
		app.buttons[themeSymbol].click()
		app.sheets.buttons["Done"].firstMatch.click()
	}

	@MainActor
	private func clickGameBoardButton(identifier: String, app: XCUIApplication) {
		app.buttons[identifier].click()
		Thread.sleep(forTimeInterval: 1)
	}

	@MainActor
	private func clickChessSquareAt(file: String, rank: String, app: XCUIApplication) {
		clickGameBoardButton(identifier: "File\(file)Rank\(rank)ChessBoardSquareButton", app: app)
	}

	@MainActor
	private func clickReversiSquareAt(row: String, column: String, app: XCUIApplication) {
		clickGameBoardButton(identifier: "Row\(row)Column\(column)ReversiBoardSquareButton", app: app)
	}

	@MainActor
	private func clickCheckersSquareAt(row: String, column: String, app: XCUIApplication) {
		clickGameBoardButton(identifier: "Row\(row)Column\(column)CheckersBoardSquareButton", app: app)
	}

	@MainActor
	func testPlayAllGamesAndChangeThemes() throws {
		let app = XCUIApplication()
		app.launch()

		// Reset themes
		app.typeKey(",", modifierFlags: .command)
		app.typeKey(.pageDown, modifierFlags: .function)
		Thread.sleep(forTimeInterval: 1)
		app.buttons["Delete All Themes"].click()
		app.sheets.buttons["Delete All Themes"].click()
		app.typeKey(.pageUp, modifierFlags: .function)
		Thread.sleep(forTimeInterval: 1)
		let jsonThemeDataField = app.textFields["Theme Data JSON"]
		jsonThemeDataField.click()
		jsonThemeDataField.typeText("\(TestData.themeData)\r")
		app.windows["Settings"].sheets.buttons["OK"].click()
		app.windows["Settings"].buttons.matching(identifier: XCUIIdentifierCloseWindow).firstMatch.click()

		let chessButton = app.buttons["Chess"]
		let reversiButton = app.buttons["Reversi"]
		let checkersButton = app.buttons["Checkers"]

		// Reset games
		chessButton.rightClick()
		app.menuItems["New game"].click()
		reversiButton.rightClick()
		app.menuItems["New game"].click()
		checkersButton.rightClick()
		app.menuItems["New game"].click()

		// Open chess
		chessButton.click()

		// Play chess
		clickChessSquareAt(file: "c", rank: "2", app: app)
		takeScreenshot()
		clickChessSquareAt(file: "c", rank: "4", app: app)
		switchTheme(to: "🍁", for: "chess", app: app)
		clickChessSquareAt(file: "d", rank: "7", app: app)
		clickChessSquareAt(file: "d", rank: "5", app: app)
		switchTheme(to: "🌸", for: "chess", app: app)
		clickChessSquareAt(file: "c", rank: "4", app: app)
		clickChessSquareAt(file: "d", rank: "5", app: app)
		switchTheme(to: "🌲", for: "chess", app: app)
		clickChessSquareAt(file: "d", rank: "8", app: app)
		takeScreenshot()
		clickChessSquareAt(file: "d", rank: "5", app: app)

		// Open reversi
		reversiButton.click()

		// Play reversi
		takeScreenshot()
		clickReversiSquareAt(row: "6", column: "4", app: app)
		switchTheme(to: "🌊", for: "reversi", app: app)
		clickReversiSquareAt(row: "6", column: "3", app: app)
		switchTheme(to: "☀️", for: "reversi", app: app)
		takeScreenshot()
		clickReversiSquareAt(row: "5", column: "3", app: app)
		switchTheme(to: "🌑", for: "reversi", app: app)
		clickReversiSquareAt(row: "6", column: "5", app: app)

		// Open checkers
		checkersButton.click()

		// Play checkers
		clickCheckersSquareAt(row: "3", column: "3", app: app)
		takeScreenshot()
		clickCheckersSquareAt(row: "4", column: "4", app: app)
		switchTheme(to: "🌸", for: "checkers", app: app)
		clickCheckersSquareAt(row: "6", column: "6", app: app)
		clickCheckersSquareAt(row: "5", column: "5", app: app)
		switchTheme(to: "❄️", for: "checkers", app: app)
		clickCheckersSquareAt(row: "4", column: "4", app: app)
		takeScreenshot()
		clickCheckersSquareAt(row: "6", column: "6", app: app)
		switchTheme(to: "🍁", for: "checkers", app: app)
		clickCheckersSquareAt(row: "7", column: "7", app: app)
		clickCheckersSquareAt(row: "5", column: "5", app: app)
	}
}
