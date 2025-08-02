//
//  iOSUITests.swift
//  GradientGames
//
//  Created by Sam McBroom on 7/31/25.
//

import XCTest

final class iOSUITests: XCTestCase {
	override func setUpWithError() throws {
		continueAfterFailure = false
	}
	
	override func tearDownWithError() throws {}
	
	private func takeScreenshot() {
		let screenshot = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
		screenshot.name = UUID().uuidString
		add(screenshot)
	}
	
	private func switchTheme(to themeSymbol: String, for game: String, app: XCUIApplication) {
		app.buttons["Themes"].tap()
		app.buttons[themeSymbol].tap()
		app.buttons["Done"].tap()
	}
	
	private func tapGameBoardButton(identifier: String, app: XCUIApplication) {
		app.buttons[identifier].tap()
		Thread.sleep(forTimeInterval: 1)
	}
	
	private func tapChessSquareAt(file: String, rank: String, app: XCUIApplication) {
		tapGameBoardButton(identifier: "File\(file)Rank\(rank)ChessBoardSquareButton", app: app)
	}
	
	private func tapReversiSquareAt(row: String, column: String, app: XCUIApplication) {
		tapGameBoardButton(identifier: "Row\(row)Column\(column)ReversiBoardSquareButton", app: app)
	}
	
	private func tapCheckersSquareAt(row: String, column: String, app: XCUIApplication) {
		tapGameBoardButton(identifier: "Row\(row)Column\(column)CheckersBoardSquareButton", app: app)
	}
	
	@MainActor
	func testPlayAllGamesAndChangeThemes() throws {
		let app = XCUIApplication()
		app.launch()
		
		// Reset themes
		app.buttons["Settings"].tap()
		app.buttons["Delete All Themes"].tap()
		app.sheets.buttons["Delete All Themes"].tap()
		let jsonThemeDataField = app.textFields["Theme Data JSON"]
		jsonThemeDataField.tap()
		jsonThemeDataField.typeText("\(TestData.themeData)\r")
		app.alerts.buttons["OK"].tap()
		if UIDevice.current.userInterfaceIdiom == .phone {
			app.buttons["Games"].tap()
		}
		
		let toggleSidebar = app.buttons["ToggleSidebar"]
		let chessButton = app.buttons["Chess"]
		let reversiButton = app.buttons["Reversi"]
		let checkersButton = app.buttons["Checkers"]
		
		// Reset games
		chessButton.press(forDuration: 1)
		app.buttons["New game"].tap()
		reversiButton.press(forDuration: 1)
		app.buttons["New game"].tap()
		checkersButton.press(forDuration: 1)
		app.buttons["New game"].tap()
		
		// Open chess
		chessButton.tap()
		if UIDevice.current.userInterfaceIdiom == .pad {
			toggleSidebar.tap()
		}
		
		// Play chess
		tapChessSquareAt(file: "c", rank: "2", app: app)
		takeScreenshot()
		tapChessSquareAt(file: "c", rank: "4", app: app)
		switchTheme(to: "🍁", for: "chess", app: app)
		tapChessSquareAt(file: "d", rank: "7", app: app)
		tapChessSquareAt(file: "d", rank: "5", app: app)
		switchTheme(to: "🌸", for: "chess", app: app)
		tapChessSquareAt(file: "c", rank: "4", app: app)
		tapChessSquareAt(file: "d", rank: "5", app: app)
		switchTheme(to: "🌲", for: "chess", app: app)
		tapChessSquareAt(file: "d", rank: "8", app: app)
		takeScreenshot()
		tapChessSquareAt(file: "d", rank: "5", app: app)
		
		if UIDevice.current.userInterfaceIdiom == .pad {
			toggleSidebar.tap()
		} else {
			app.buttons["Games"].tap()
		}
		
		// Open reversi
		reversiButton.tap()
		if UIDevice.current.userInterfaceIdiom == .pad {
			toggleSidebar.tap()
		}
		
		// Play reversi
		takeScreenshot()
		tapReversiSquareAt(row: "6", column: "4", app: app)
		switchTheme(to: "🌊", for: "reversi", app: app)
		tapReversiSquareAt(row: "6", column: "3", app: app)
		switchTheme(to: "☀️", for: "reversi", app: app)
		takeScreenshot()
		tapReversiSquareAt(row: "5", column: "3", app: app)
		switchTheme(to: "🌑", for: "reversi", app: app)
		tapReversiSquareAt(row: "6", column: "5", app: app)
		
		if UIDevice.current.userInterfaceIdiom == .pad {
			toggleSidebar.tap()
		} else {
			app.buttons["Games"].tap()
		}
		
		// Open checkers
		checkersButton.tap()
		if UIDevice.current.userInterfaceIdiom == .pad {
			toggleSidebar.tap()
		}
		
		// Play checkers
		tapCheckersSquareAt(row: "3", column: "3", app: app)
		takeScreenshot()
		tapCheckersSquareAt(row: "4", column: "4", app: app)
		switchTheme(to: "🌸", for: "checkers", app: app)
		tapCheckersSquareAt(row: "6", column: "6", app: app)
		tapCheckersSquareAt(row: "5", column: "5", app: app)
		switchTheme(to: "❄️", for: "checkers", app: app)
		tapCheckersSquareAt(row: "4", column: "4", app: app)
		takeScreenshot()
		tapCheckersSquareAt(row: "6", column: "6", app: app)
		switchTheme(to: "🍁", for: "checkers", app: app)
		tapCheckersSquareAt(row: "7", column: "7", app: app)
		tapCheckersSquareAt(row: "5", column: "5", app: app)
	}
}
