//
//  TestData.swift
//  GradientGames
//
//  Created by Sam McBroom on 7/30/25.
//

struct TestData {
	private init() {}
	
	static let themeData = """
	{
		"themes": [
			{
				"game": "chess",
				"symbol": "🌊",
				"index": 0,
				"colors": [
					{"target": "pieceLight", "color": "00c1ce"},
					{"target": "pieceDark", "color": "0100a7"},
					{"target": "squareLight", "color": "b2ecee"},
					{"target": "squareDark", "color": "0375fb"}
				]
			},
			{
				"game": "chess",
				"symbol": "🌲",
				"index": 1,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "cce8b5"},
					{"target": "squareDark", "color": "38571a"}
				]
			},
			{
				"game": "chess",
				"symbol": "🌑",
				"index": 2,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "c0c0c0"},
					{"target": "squareDark", "color": "606060"}
				]
			},
			{
				"game": "chess",
				"symbol": "🍁",
				"index": 3,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "ffad3a"},
					{"target": "squareDark", "color": "b22a00"}
				]
			},
			{
				"game": "chess",
				"symbol": "❄️",
				"index": 4,
				"colors": [
					{"target": "pieceLight", "color": "444444"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "caf0fe"},
					{"target": "squareDark", "color": "76aac7"}
				]
			},
			{
				"game": "chess",
				"symbol": "🌸",
				"index": 5,
				"colors": [
					{"target": "pieceLight", "color": "606060"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "fff76b"},
					{"target": "squareDark", "color": "b1dd8c"}
				]
			},
			{
				"game": "chess",
				"symbol": "☀️",
				"index": 6,
				"colors": [
					{"target": "pieceLight", "color": "606060"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "fff995"},
					{"target": "squareDark", "color": "ffaa00"}
				]
			},
			{
				"game": "reversi",
				"symbol": "🌊",
				"index": 0,
				"colors": [
					{"target": "pieceLight", "color": "00c1ce"},
					{"target": "pieceDark", "color": "0100a7"},
					{"target": "borders", "color": "b2ecee"},
					{"target": "squares", "color": "0375fb"}
				]
			},
			{
				"game": "reversi",
				"symbol": "🌲",
				"index": 1,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "borders", "color": "cce8b5"},
					{"target": "squares", "color": "38571a"}
				]
			},
			{
				"game": "reversi",
				"symbol": "🌑",
				"index": 2,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "borders", "color": "c0c0c0"},
					{"target": "squares", "color": "606060"}
				]
			},
			{
				"game": "reversi",
				"symbol": "🍁",
				"index": 3,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "borders", "color": "ffad3a"},
					{"target": "squares", "color": "b22a00"}
				]
			},
			{
				"game": "reversi",
				"symbol": "❄️",
				"index": 4,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "borders", "color": "caf0fe"},
					{"target": "squares", "color": "76aac7"}
				]
			},
			{
				"game": "reversi",
				"symbol": "🌸",
				"index": 5,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "borders", "color": "fff76b"},
					{"target": "squares", "color": "b1dd8c"}
				]
			},
			{
				"game": "reversi",
				"symbol": "☀️",
				"index": 6,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "borders", "color": "fff995"},
					{"target": "squares", "color": "ffaa00"}
				]
			},
			{
				"game": "checkers",
				"symbol": "🌊",
				"index": 0,
				"colors": [
					{"target": "pieceLight", "color": "00c1ce"},
					{"target": "pieceDark", "color": "0100a7"},
					{"target": "squareLight", "color": "b2ecee"},
					{"target": "squareDark", "color": "0375fb"}
				]
			},
			{
				"game": "checkers",
				"symbol": "🌲",
				"index": 1,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "cce8b5"},
					{"target": "squareDark", "color": "38571a"}
				]
			},
			{
				"game": "checkers",
				"symbol": "🌑",
				"index": 2,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "c0c0c0"},
					{"target": "squareDark", "color": "606060"}
				]
			},
			{
				"game": "checkers",
				"symbol": "🍁",
				"index": 3,
				"colors": [
					{"target": "pieceLight", "color": "ffffff"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "ffad3a"},
					{"target": "squareDark", "color": "b22a00"}
				]
			},
			{
				"game": "checkers",
				"symbol": "❄️",
				"index": 4,
				"colors": [
					{"target": "pieceLight", "color": "444444"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "caf0fe"},
					{"target": "squareDark", "color": "76aac7"}
				]
			},
			{
				"game": "checkers",
				"symbol": "🌸",
				"index": 5,
				"colors": [
					{"target": "pieceLight", "color": "606060"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "fff76b"},
					{"target": "squareDark", "color": "b1dd8c"}
				]
			},
			{
				"game": "checkers",
				"symbol": "☀️",
				"index": 6,
				"colors": [
					{"target": "pieceLight", "color": "606060"},
					{"target": "pieceDark", "color": "000000"},
					{"target": "squareLight", "color": "fff995"},
					{"target": "squareDark", "color": "ffaa00"}
				]
			}
	 ],
	 "schemaVersion": {"major": 1, "minor": 0, "patch": 0}
	}
	""".filter({character in !["\n", "\t"].contains(character)})
}
