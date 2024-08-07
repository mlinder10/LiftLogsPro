//
//  Plan.swift
//  Weights
//
//  Created by Matt Linder on 8/5/24.
//

import Foundation

enum Client {
  final class Plan: Observable, Identifiable {
    let id: String
    var name: String
    var description: String
    var workouts: [Workout]
    
    // INIT
    init() {
      self.id = UUID().uuidString
      self.name = "New Plan"
      self.description = ""
      self.workouts = []
    }
    
    init(id: String, name: String, description: String, workouts: [Workout]) {
      self.id = id
      self.name = name
      self.description = description
      self.workouts = []
    }
  }
  
  final class Workout: Observable, Identifiable {
    let id: String
    var name: String
    var description: String
    var index: Int
    var colorOne: String
    var colorTwo: String
    var start: Int64?
    var end: Int64?
    var wrappers: [Wrapper]
    
    // INIT
    init(index: Int = 0) {
      self.id = UUID().uuidString
      self.name = "New Workout"
      self.description = ""
      self.index = index
      self.colorOne = "#000"
      self.colorTwo = "#000"
      self.start = nil
      self.end = nil
      self.wrappers = []
    }
    
    init(id: String, name: String, description: String, index: Int, colorOne: String, colorTwo: String, start: Int64?, end: Int64?, wrappers: [Wrapper]) {
      self.id = id
      self.name = name
      self.description = description
      self.index = index
      self.colorOne = colorOne
      self.colorTwo = colorTwo
      self.start = start
      self.end = end
      self.wrappers = wrappers
    }
  }
  
  final class Wrapper: Observable, Identifiable {
    let id: String
    var index: Int
    var stimulus: Int
    var fatigue: Int
    var exercises: [Exercise]
    
    // INIT
    init(index: Int) {
      self.id = UUID().uuidString
      self.index = index
      self.stimulus = 0
      self.fatigue = 0
      self.exercises = []
    }

    init(id: String, index: Int, stimulus: Int, fatigue: Int, exercises: [Exercise]) {
      self.id = id
      self.index = index
      self.stimulus = stimulus
      self.fatigue = fatigue
      self.exercises = exercises
    }
  }
  
  final class Exercise: Observable, Identifiable {
    let id: String
    let listId: String
    var index: Int
    var sets: [ExerciseSet]
    
    // INIT
    init(listId: String, index: Int) {
      self.id = UUID().uuidString
      self.listId = listId
      self.index = index
      self.sets = []
    }

    init(id: String, listId: String, index: Int, sets: [ExerciseSet]) {
      self.id = id
      self.listId = listId
      self.index = index
      self.sets = sets
    }
  }
  
  final class ExerciseSet: Observable, Identifiable {
    let id: String
    var index: Int
    var type: SetType
    var reps: Int
    var weight: Double
    
    // INIT
    init(index: Int) {
      self.id = UUID().uuidString
      self.index = index
      self.type = .normal
      self.reps = 0
      self.weight = 0.0
    }

    init(id: String, index: Int, type: SetType, reps: Int, weight: Double) {
      self.id = id
      self.index = index
      self.type = type
      self.reps = reps
      self.weight = weight
    }
  }
  
  enum SetType: String {
    case normal = "normal"
    case myo = "myo"
    case drop = "drop"
    case warmup = "warmup"
    case cooldown = "cooldown"
  }
}
