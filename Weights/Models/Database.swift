//
//  Database.swift
//  Weights
//
//  Created by Matt Linder on 8/6/24.
//

import Foundation

enum DB {
  struct Plan: Queryable, Insertable {
    let id: String
    let name: String
    let description: String
    
    static func from(_ plan: Client.Plan) -> Self {
      return Plan(
        id: plan.id,
        name: plan.name,
        description: plan.description
      )
    }
    
    func toClient() -> Client.Plan {
      return Client.Plan(
        id: self.id,
        name: self.name,
        description: self.description,
        workouts: []
      )
    }
    
    static var table: String { "plan" }
    var inserts: [String: Arg] {[
      "id": .string(id),
      "name": .string(name),
      "description": .string(description),
    ]}
  }
  
  struct Workout: Queryable, Insertable {
    let id: String
    let name: String
    let description: String
    let index: Int
    let colorOne: String
    let colorTwo: String
    let start: Int64?
    let end: Int64?
    let planId: String?

    static func from(_ workout: Client.Workout, planId: String? = nil) -> Self {
      return Workout(
        id: workout.id,
        name: workout.name,
        description: workout.description,
        index: workout.index,
        colorOne: workout.colorOne,
        colorTwo: workout.colorTwo,
        start: workout.start,
        end: workout.end,
        planId: planId
      )
    }

    func toClient() -> (Client.Workout, String?) {
      return (
          Client.Workout(
          id: self.id,
          name: self.name,
          description: self.description,
          index: self.index,
          colorOne: self.colorOne,
          colorTwo: self.colorTwo,
          start: self.start,
          end: self.end,
          wrappers: []
        ),
        self.planId
      )
    }
    
    static var table: String { "workouts" }
    static var cols: [String: String] {[
      "sequence": "index",
      "color_one": "colorOne",
      "color_two": "colorTwo",
      "plan_id": "planId",
    ]}
    var inserts: [String: Arg] {[
      "id": .string(id),
      "name": .string(name),
      "description": .string(description),
      "sequence": .int(index),
      "color_one": .string(colorOne),
      "color_two": .string(colorTwo),
      "start": .int(start),
      "end": .int(end),
      "plan_id": .string(planId),
    ]}
  }
  
  struct Wrapper: Queryable, Insertable {
    let id: String
    let index: Int
    let stimulus: Int
    let fatigue: Int
    let workoutId: String

    static func from(_ wrapper: Client.Wrapper, workoutId: String) -> Self {
      return Wrapper(
        id: wrapper.id,
        index: wrapper.index,
        stimulus: wrapper.stimulus,
        fatigue: wrapper.fatigue,
        workoutId: workoutId
      )
    }

    func toClient() -> (Client.Wrapper, String) {
      return (
        Client.Wrapper(
          id: self.id,
          index: self.index,
          stimulus: self.stimulus,
          fatigue: self.fatigue,
          exercises: []
        ),
        self.workoutId
      )
    }
    
    static var table: String { "wrappers" }
    static var cols: [String : String] {[
      "sequence": "index",
      "workout_id": "workoutId",
    ]}
    var inserts: [String : Arg] {[
      "id": .string(id),
      "sequence": .int(index),
      "stimulus": .int(stimulus),
      "fatigue": .int(fatigue),
      "workout_id": .string(workoutId),
    ]}
  }
  
  struct Exercise: Queryable, Insertable {
    let id: String
    let listId: String
    let index: Int
    let wrapperId: String
    
    static func from(_ exercise: Client.Exercise, wrapperId: String) -> Self {
      return Exercise(
        id: exercise.id,
        listId: exercise.listId,
        index: exercise.index,
        wrapperId: wrapperId
      )
    }

    func toClient() -> (Client.Exercise, String) {
      return (
        Client.Exercise(
          listId: self.listId,
          index: self.index
        ),
        self.wrapperId
      )
    }

    static var table: String { "exercises" }
    static var cols: [String : String] {[
      "list_id": "listId",
      "sequence": "index",
      "wrapper_id": "wrapperId",
    ]}
    var inserts: [String : Arg] {[
      "id": .string(id),
      "list_id": .string(listId),
      "sequence": .int(index),
      "wrapper_id": .string(wrapperId),
    ]}
  }
  
  struct ExerciseSet: Queryable, Insertable {
    let id: String
    let index: Int
    let type: String
    let reps: Int
    let weight: Double
    let exerciseId: String

    static func from(_ set: Client.ExerciseSet, exerciseId: String) -> Self {
      return ExerciseSet(
        id: set.id,
        index: set.index,
        type: set.type.rawValue,
        reps: set.reps,
        weight: set.weight,
        exerciseId: exerciseId
      )
    }

    func toClient() -> (Client.ExerciseSet, String) {
      return (
        Client.ExerciseSet(
          id: self.id,
          index: self.index,
          type: Client.SetType(rawValue: self.type)!,
          reps: self.reps,
          weight: self.weight
        ),
        self.exerciseId
      )
    }
    
    static var table: String { "sets" }
    static var cols: [String : String] {[
      "sequence": "index",
      "exercise_id": "exerciseId",
    ]}
    var inserts: [String : Arg] {[
      "id": .string(id),
      "sequence": .int(index),
      "type": .string(type),
      "reps": .int(reps),
      "weight": .float(weight),
      "exercise_id": .string(exerciseId),
    ]}
  }
}
