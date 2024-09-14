import Foundation

class UserData: ObservableObject {
    
    @Published var cash: Int = UserDefaults.standard.integer(forKey: "cash") {
        didSet {
            UserDefaults.standard.set(cash, forKey: "cash")
        }
    }
    
    @Published var selectedBall: String = UserDefaults.standard.string(forKey: "cannon_bullet") ?? "cannon_bullet" {
        didSet {
            UserDefaults.standard.set(selectedBall, forKey: "cannon_bullet")
        }
    }
    
}
