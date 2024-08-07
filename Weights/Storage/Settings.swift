import Foundation

private let SETTINGS_ROW_ID = "SETTINGS_ID" 

struct Settings: Queryable, Insertable {
    static var shared = Settings() { get }

    let id: String
    let planId: String?

    static var table: String { "settings" }
    static var cols: [String: String] {[
        "plan_id": "planId"
    ]}
    var inserts: [String: Arg] {[
        "id": .string(id),
        "plan_id": .string(planId)
    ]}

    private init() {
        do {
            let rows = try Settings.query("SELECT * FROM settings", Connection.client)
            if rows.count > 0 {
                let settings = rows.first!
                self.id = settings.id
                self.planId = settings.planId
                return
            }

            self.id = SETTINGS_ROW_ID
            self.planId = nil

            let _ = try Connection.client.insert(self)
        } catch {
            NSLog(error.localizedDescription)
        }
    }

    static func update(planId: String) {
        let settings = Settings(id: SETTINGS_ROW_ID, planId: planId)
        let _ = try Connection.client.execute(
            "UPDATE settings SET plan_id = ? WHERE id = ?",
            [.string(settings.planId), .string(settings.id)]
        )
        Settings.shared = settings
    }
}