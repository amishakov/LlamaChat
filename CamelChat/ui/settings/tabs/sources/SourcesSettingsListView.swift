//
//  SourcesSettingsListView.swift
//  CamelChat
//
//  Created by Alex Rozanski on 01/04/2023.
//

import SwiftUI

struct SourcesSettingsSourceItemView: View {
  @ObservedObject var viewModel: SourcesSettingsSourceItemViewModel

  var body: some View {
    Text(viewModel.title)
  }
}

struct SourcesSettingsListView: View {
  @ObservedObject var viewModel: SourcesSettingsViewModel

  @ViewBuilder var heading: some View {
    VStack(spacing: 0) {
      HStack {
        Text("Source")
          .font(.system(size: 11))
          .padding(.vertical, 8)
      }
      .frame(maxWidth: .infinity)
      Divider()
        .foregroundColor(Color(NSColor.separatorColor.cgColor))
    }
  }

  @ViewBuilder var actionButtons: some View {
    HStack(spacing: 0) {
      Button(action: { viewModel.showAddSourceSheet() }, label: {
        Image(systemName: "plus")
          .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 6))
      })
      .buttonStyle(BorderlessButtonStyle())
      Button(action: {
        guard let selectedSource = viewModel.sources.first(where: { $0 == viewModel.selectedSource }) else { return }
        viewModel.showConfirmDeleteSourceSheet(for: selectedSource)
      }, label: {
        Image(systemName: "minus")
          .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 8))
      })
      .disabled(viewModel.selectedSource == nil)
      .buttonStyle(BorderlessButtonStyle())
      Spacer()
    }
  }

  var body: some View {
    let selectionBinding = Binding<String?>(
      get: { viewModel.selectedSource?.id },
      set: { selectedId in viewModel.selectedSource = viewModel.sources.first(where: { $0.id == selectedId }) }
    )
    ZStack {
      List(selection: selectionBinding) {
        Section(header: Text("Sources").frame(maxWidth: .infinity), content: {
          ForEach(viewModel.sources, id: \.id) { source in
            SourcesSettingsSourceItemView(viewModel: source)
          }
        })
      }
      .listStyle(PlainListStyle())
      VStack {
        Spacer()
        actionButtons
      }
    }
    .border(.separator)
    .onAppear {
      viewModel.selectedSource = viewModel.sources.first
    }
  }
}
