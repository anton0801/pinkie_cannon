import Foundation

struct Level: Identifiable {
    let id: Int
    var isUnlocked: Bool
}

class CanonLevelsManager: ObservableObject {
    private let levelsKey = "canonLevels"
    private let totalLevels = 12
    @Published var levels: [Level]
    
    init() {
        if let savedLevels = UserDefaults.standard.array(forKey: levelsKey) as? [[String: Any]] {
            self.levels = savedLevels.compactMap { dict in
                guard let id = dict["id"] as? Int, let isUnlocked = dict["isUnlocked"] as? Bool else { return nil }
                return Level(id: id, isUnlocked: isUnlocked)
            }
        } else {
            self.levels = (1...totalLevels).map { Level(id: $0, isUnlocked: $0 == 1) }
            saveLevels()
        }
    }
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        guard let level = levels.first(where: { $0.id == level }) else {
            return false
        }
        return level.isUnlocked
    }
    
    func unlockLevel(_ level: Int) {
        guard let index = levels.firstIndex(where: { $0.id == level }) else {
            return
        }
        if !levels[index].isUnlocked {
            levels[index].isUnlocked = true
            saveLevels()
        }
    }
    
    private func saveLevels() {
        let savedLevels = levels.map { ["id": $0.id, "isUnlocked": $0.isUnlocked] }
        UserDefaults.standard.set(savedLevels, forKey: levelsKey)
    }
}
