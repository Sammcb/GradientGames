//
//  NoneButtonStyle.swift
//  GradientGames
//
//  Created by Sam McBroom on 11/3/22.
//

import SwiftUI

struct NoneButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.background(.clear)
	}
}
