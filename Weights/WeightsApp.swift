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
    // Connect to database
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/db.sqlite3"
    do {
      try Database.shared.connect(path: path)
    } catch {
      print("Failed to connect to database")
      return
    }
    // Init tables
    do {
      try createTables()
    } catch {
      print("Failed to create tables")
      return
    }
  }
  
  func createTables() throws {
    let _ = try Database.shared.execute(
      """
        CREATE TABLE IF NOT EXISTS plans (
          id TEXT PRIMARY KEY NOT NULL,
          name TEXT NOT NULL,
          description TEXT NOT NULL
        );

        CREATE TABLE IF NOT EXISTS workouts (
          id TEXT PRIMARY KEY NOT NULL,
          sequence INTEGER NOT NULL,
          name TEXT NOT NULL,
          description TEXT NOT NULL,
          color_one TEXT NOT NULL,
          color_two TEXT NOT NULL,
          plan_id TEXT,
          FOREIGN KEY (plan_id) REFERENCES plans(id) ON DELETE CASCADE
        );

        CREATE TABLE IF NOT EXISTS wrappers (
          id TEXT PRIMARY KEY NOT NULL,
          sequence INTEGER NOT NULL,
          stimulus INTEGER NOT NULL,
          fatigue INTEGER NOT NULL,
          workout_id TEXT NOT NULL,
          FOREIGN KEY (workout_id) REFERENCES completed_workouts(id) ON DELETE CASCADE
        );

        CREATE TABLE IF NOT EXISTS exercises (
          id TEXT PRIMARY KEY NOT NULL,
          list_id TEXT NOT NULL,
          sequence INT NOT NULL,
          wrapper_id TEXT NOT NULL,
          FOREIGN KEY (exercise_id) REFERENCES exercise_wrappers(id) ON DELETE CASCADE
        );

        CREATE TABLE IF NOT EXISTS sets (
          id TEXT PRIMARY KEY NOT NULL,
          sequence INTEGER NOT NULL,
          type TEXT NOT NULL,
          reps INTEGER NOT NULL,
          weight FLOAT NOT NULL,
          exercise_id TEXT NOT NULL,
          FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
        );
      """
    )
  }
  
  func dropTables() throws {
    let _ = try Database.shared.execute(
      """
        DROP TABLE IF EXISTS plans;
      
        DROP TABLE IF EXISTS workouts;
      
        DROP TABLE IF EXISTS wrappers;
      
        DROP TABLE IF EXISTS exercises;
      
        DROP TABLE IF EXISTS sets;
      """
    )
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
