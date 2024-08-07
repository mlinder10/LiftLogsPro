import Foundation

enum Share {
    struct Plan: Codable {
    let n: String
    let d: String
    let w: [Workout]

    static func from(plan: Client.Plan) -> Self {
        return Self(
            n: plan.name,
            d: plan.description,
            w: plan.workouts.map(Workout.from)
            )
        }
    }

    struct Workout: Codable {
        let n: String
        let d: String
        let w: String

        static func from(workout: Client.Workout) -> Self {
            var wrappers = ""

            for wrapper in workout.wrappers {
                for exercise in wrapper.exercises {
                    wrappers += exercise.listId + " "
                    for set in exercise.sets {
                        let type = switch set.type {
                            case .normal: "n"
                            case .warmup: "w"
                            case .cooldown: "c"
                            case .myo: "m"
                            case .drop: "d"
                        }
                        wrappers += "\(type)\(set.reps)-\(set.weight)"
                        wrappers += "~"
                    }
                    wrappers += ";"
                }
                wrappers += "@"
            }

            let _ = wrappers.removeLast()

            return Self(n: workout.name, d: workout.description, w: wrappers)
        }
    }

    struct SharePayload: Codable {
        let e: String
        let p: PlanShare?
        let w: PlanShare.Workout?
    }

    func parseShareString(_ str: String) -> (Client.Plan?, Client.Workout?, [ListExercise]) {
        let data = Data(base64Encoded: str)!
        let payload = try! JSONDecoder().decode(SharePayload.self, from: data)

        let plan = payload.p == nil ? nil : ClientPlan.from(share: payload.p!)
        let workout = payload.w == nil ? nil : ClientPlan.Workout.from(share: payload.w!)
        let exercises = payload.e.split(separator: "\n").map { ListExercise.decompress(String($0)) }

        return (plan, workout, exercises)
    }
}