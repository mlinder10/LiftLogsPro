import Foundation

private let EXERCISE_LIST_URL = "https://liftlogs.vercel.app/exercises.json"

enum NetworkError {
    case invalidUrl
}

enum Connection {
    static let client = Database()

    static func connect() throws {
        // Connect to client database
        let clientPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/db.sqlite3"
        do {
            try Connection.client.connect(path: clientPath)
        } catch {
            print("Failed to connect to database")
            return
        }

        // Connect to list database
        let listPath = "exercises.sqlite3"
        do {
            try Connection.list.connect(path: listPath)
        } catch {
            print("Failed to connect to list database")
            return
        }
    }

    static func createTables() throws {
        let _ = try Connection.client.execute(
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

            CREATE TABLE IF NOT EXISTS settings (
                id TEXT PRIMARY KEY NOT NULL,
                plan_id TEXT,
                FOREIGN KEY (plan_id) REFERENCES plans(id) ON DELETE SET NULL
            );

            CREATE TABLE IF NOT EXISTS list_exercises (
                id TEXT PRIMARY KEY NOT NULL,
                name TEXT NOT NULL,
                body_part TEXT NOT NULL,
                primary_muscle_group TEXT NOT NULL,
                exercise_type TEXT NOT NULL,
                equipment_type TEXT NOT NULL,
                description TEXT,
                directions BLOB,
                cues BLOB,
                image_contracted TEXT,
                image_extended TEXT,
                video_id TEXT,
                secondary_muscle_groups BLOB,
                reps_low INTEGER,
                reps_high INTEGER
            );
        """
        )
    }

    static func dropTables() throws {
        let _ = try Connection.client.execute(
        """
            DROP TABLE IF EXISTS plans;
        
            DROP TABLE IF EXISTS workouts;
        
            DROP TABLE IF EXISTS wrappers;
        
            DROP TABLE IF EXISTS exercises;
        
            DROP TABLE IF EXISTS sets;

            DROP TABLE IF EXISTS settings;
        """
        )
    }

    static func updateExerciseList() async throws {
        guard let url = URL(string: EXERCISE_LIST_URL) else {
            throw NetworkError.invalidUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let remoteExercises = try JSONDecoder().decode([ListExercise].self, from: data)

        let localExercises = try ListExercise.all()

        let addTo = remoteExercises.filter({ !localExercises.contains($0) })
        let removeFrom = localExercises.filter({ !remoteExercises.contains($0) })

        if addTo.count > 0 { try Connection.client.insert(addTo) }

        let args = removeFrom.map({ Arg.string($0.id) })

        if removeFrom.count > 0 {
            try Connection.client.execute(
                "DELETE FROM list_exercises WHERE id IN (\(removeFrom.map({ $0.id }).joined(separator: ", ")))",
                args
            )
        }
    }
}
