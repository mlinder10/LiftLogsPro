//
//  WeightsApp.swift
//  Weights
//
//  Created by Matt Linder on 8/5/24.
//

import SwiftUI

@main
struct WeightsApp: App {
  init() {
    do {
      try connect()
      try createTables()
      Task { try await initExercises() }
    } catch {
      print("Fail")
      return
    }
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
