import Foundation

struct Ball: Identifiable {
    let id: Int
    let name: String
    let price: Int
    let isSpecial: Bool
}

class ShopBallsViewModel: ObservableObject {
    @Published var purchasedBalls: [Ball] = []
    @Published var regularBalls: [Ball]
    @Published var specialBalls: [Ball]
    
    init() {
        self.regularBalls = [
            Ball(id: 1, name: "bullet_1", price: 5000, isSpecial: false),
            Ball(id: 2, name: "bullet_2", price: 6000, isSpecial: false),
            Ball(id: 3, name: "bullet_3", price: 7000, isSpecial: false),
            Ball(id: 4, name: "bullet_4", price: 8000, isSpecial: false),
            Ball(id: 5, name: "bullet_5", price: 10000, isSpecial: false)
        ]
        
        self.specialBalls = [
            Ball(id: 6, name: "special_ball_1", price: 20000, isSpecial: true),
            Ball(id: 7, name: "special_ball_2", price: 40000, isSpecial: true),
            Ball(id: 8, name: "special_ball_3", price: 50000, isSpecial: true),
            Ball(id: 9, name: "special_ball_4", price: 60000, isSpecial: true),
            Ball(id: 10, name: "special_ball_5", price: 100000, isSpecial: true)
        ]
        
        if purchasedBalls.isEmpty {
            purchasedBalls.append(Ball(id: 0, name: "cannon_bullet", price: 0, isSpecial: false))
        }
    }
    
    func purchaseBall(_ ball: Ball, userData: UserData) -> Bool {
        if purchasedBalls.contains(where: { $0.id == ball.id }) {
            return false
        }
        
        if userData.cash >= ball.price {
            userData.cash -= ball.price
            purchasedBalls.append(ball)
            savePurchasedBalls()
            return true
        } else {
            return false
        }
    }
    
    private func savePurchasedBalls() {
        let purchasedBallsData = purchasedBalls.map { ["id": $0.id, "name": $0.name, "price": $0.price, "isSpecial": $0.isSpecial] }
        UserDefaults.standard.set(purchasedBallsData, forKey: "purchasedBalls")
    }
    
    private func loadPurchasedBalls() {
        if let savedBalls = UserDefaults.standard.array(forKey: "purchasedBalls") as? [[String: Any]] {
            self.purchasedBalls = savedBalls.compactMap { dict in
                guard let id = dict["id"] as? Int,
                      let name = dict["name"] as? String,
                      let price = dict["price"] as? Int,
                      let isSpecial = dict["isSpecial"] as? Bool else { return nil }
                return Ball(id: id, name: name, price: price, isSpecial: isSpecial)
            }
        }
    }
}
