//
//  ThemeDeleteAllView.swift
//  GradientGames
//
//  Created by Sam McBroom on 8/1/25.
//

import SwiftUI
import SwiftData

struct ThemeDeleteAllView: View {
	@Environment(\.modelContext) private var context
	@Query(sort: \Theme.index) private var themes: [Theme]
	@State private var showDeleteConfirmation = false
	
	var body: some View {
		Button(role: .destructive) {
			showDeleteConfirmation.toggle()
		} label: {
			Label("Delete All Themes", systemImage: "trash")
				.foregroundStyle(.red)
		}
		.confirmationDialog("Are you sure you want to delete all your themes?", isPresented: $showDeleteConfirmation) {
			Button(role: .destructive) {
				themes.forEach({ theme in context.delete(theme) })
			} label: {
				Label("Delete All Themes", systemImage: "trash")
			}
		}
	}
}
