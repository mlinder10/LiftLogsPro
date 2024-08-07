import Foundation

struct ListExercise: Insertable {
    private static let exercises: [Self]? = nil

    let id: String
    let name: String
    let bodyPart: String
    let primaryGroup: String
    let exerciseType: String
    let equipmentType: String
    let description: String?
    let directions: [String]?
    let cues: [String]?
    let imgContracted: String?
    let imgExtended: String?
    let videoId: String?
    let secondaryGroups: [String]?
    let repsLow: Int?
    let repsHigh: Int?

    static var table: String { "list_exercises" }
    var inserts: [String: Arg] {
        let directions = try? JSONEncoder().encode(self.directions)
        let cues = try? JSONEncoder().encode(self.cues)
        let secondaryGroups = try? JSONEncoder().encode(self.secondaryGroups)
        [
        "id": .string(id),
        "name": .string(name),
        "primary_muscle_group": .string(primaryGroup),
        "body_part": .string(bodyPart),
        "exercise_type": .string(exerciseType),
        "equipment_type": .string(equipmentType),
        "description": .string(description),
        "directions": .blob(directions),
        "cues": .blob(cues),
        "img_contracted": .string(imgContracted),
        "img_extended": .string(imgExtended),
        "video_id": .string(videoId),
        "secondary_muscle_groups": .blob(secondaryGroups),
        "reps_low": .int(repsLow),
        "reps_high": .int(repsHigh),
        ]
    }


    // SHARING =================================================================
    func compress() -> String {
        return "\(self.name)\t\(self.bodyPart)\t\(self.primaryGroup)\t\(self.secondaryGroups.joined(separator: "-"))\t\(self.exerciseType)\t\(self.equipmentType)\t"
    }

    static func decompress(_ str: String) -> Self {
        let parts = str.split(separator: "\t")
        return Self(
            id: UUID().uuidString,
            name: String(parts[0]),
            description: nil,
            directions: nil,
            cues: nil,
            imgContracted: nil,
            imgExtended: nil,
            videoId: nil,
            bodyPart: String(parts[1]),
            primaryGroup: String(parts[2]),
            secondaryGroups: String(parts[3]).components(separatedBy: "-"),
            exerciseType: String(parts[4]),
            equipmentType: String(parts[5]),
            repsLow: nil,
            repsHigh: nil
        )
    }

    // DATABASE ================================================================
    private static func fromRow(_ row: [String: Any?]) -> ListExercise {
        let secondaryGroups = if let secondaryGroups = row["secondary_muscle_groups"] as? Data { try? JSONDecoder().decode([String].self, from: secondaryGroups) } else { nil }
        let directions = if let directions = row["directions"] as? Data { try? JSONDecoder().decode([String].self, from: directions) } else { nil }
        let cues = if let cues = row["cues"] as? Data { try? JSONDecoder().decode([String].self, from: cues) } else { nil }

        return ListExercise(
            id: row["id"] as! String,
            name: row["name"] as! String,
            bodyPart: row["body_part"] as! String,
            primaryGroup: row["primary_muscle_group"] as! String,
            exerciseType: row["exercise_type"] as! String,
            equipmentType: row["equipment_type"] as! String,
            secondaryGroups: secondaryGroups,
            description: row["description"] as? String,
            directions: directions,
            cues: cues,
            image_contracted: row["image_contracted"] as? String,
            image_extended: row["image_extended"] as? String,
            videoId: row["video_id"] as? String,
            repsLow: row["reps_low"] as? Int,
            repsHigh: row["reps_high"] as? Int
        )
    }

    // CLIENT FUNCTIONS ========================================================
    static func all() -> [ListExercise] {
        if let exercises = Self.exercises { return exercises }
        let rows = try! Connection.client.query("SELECT * FROM list_exercises")
        self.exercises = rows.map { ListExercise.fromRow($0) }
        return self.exercises!
    }

    static func get(id: String) -> ListExercise? {
        if let exercises = Self.exercises { return exercises.first(where: { $0.id == id }) }
        let rows = Connection.client.query("SELECT * FROM list_exercises WHERE id = ?", [.string(id)])
        return fromRow(rows).first
    }

    static func create(name: String, bodyPart: String, primaryGroup: String, exerciseType: String, equipmentType: String) -> String {
        let id = UUID().uuidString

        let _ = try? Connection.client.execute(
            """
                INSERT INTO list_exercises
                  (id, name, body_part, primary_muscle_group, exercise_type, equipment_type)
                VALUES
                  (?, ?, ?, ?, ?, ?)
            """
        )

        return id
    }
}
