//
//  ContentView.swift
//  Weights
//
//  Created by Matt Linder on 8/5/24.
//

import SwiftUI

struct ContentView: View {
  let db = Database.shared
  
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

#Preview {
    ContentView()
}
