import SwiftUI
import SpriteKit

class CanonGameScene: SKScene, SKPhysicsContactDelegate {
    
    var level: Int
    
    func retryGame() -> CanonGameScene {
        let newCanonScene = CanonGameScene(level: level)
        view?.presentScene(newCanonScene)
        return newCanonScene
    }
    
    var levelLabel: SKSpriteNode {
        get {
            let node = SKSpriteNode()
            
            let level2 = SKLabelNode(text: "LEVEL \(level)")
            level2.fontSize = 110
            level2.fontName = "Yumi"
            level2.fontColor = .black
            level2.position = CGPoint(x: 0, y: -2)
            node.addChild(level2)
            
            let level1 = SKLabelNode(text: "LEVEL \(level)")
            level1.fontSize = 104
            level1.fontName = "Yumi"
            level1.fontColor = .white
            node.addChild(level1)
            
            
            node.position = CGPoint(x: 250, y: size.height - 200)
            
            return node
        }
    }
    
    private var pauseBtn: SKSpriteNode {
        get {
            let node = SKSpriteNode(imageNamed: "pause_button")
            
            let pauseBtn = SKSpriteNode(imageNamed: "pause_button")
            pauseBtn.size = CGSize(width: 240, height: 120)
            pauseBtn.name = "pause_button"
            node.addChild(pauseBtn)
            
            node.position = CGPoint(x: size.width - 200, y: size.height - 170)
            
            return node
        }
    }
    
    private var cannon: SKSpriteNode!
    
    var fireTimer: Timer!
    var enemySpawner: Timer!
    var spawnAditional: Timer!
    
    private var isHoldCannon = false
    
    var objective: Int {
        get {
            return 10 + (level * 2)
        }
    }
    private var currentObjectiveCount = 0 {
        didSet {
            if currentObjectiveCount == objective {
                NotificationCenter.default.post(name: Notification.Name("win_game"), object: nil)
                isPaused = true
            }
        }
    }
    
    var errors = 0 {
        didSet {
            if errors == 3 {
                NotificationCenter.default.post(name: Notification.Name("loss_game"), object: nil)
                isPaused = true
            }
        }
    }
    
    init(level: Int) {
        self.level = level
        super.init(size: CGSize(width: 2250, height: 2600))
    }
    
    private var tutorImage: SKSpriteNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        addBackground()
        
        addChild(levelLabel)
        addChild(pauseBtn)
        
        addCannon()
        
        fireTimer = .scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            if self.isHoldCannon {
                self.cannonFire()
            }
        })
        
        enemySpawner = .scheduledTimer(withTimeInterval: 3.5, repeats: true, block: { timer in
            self.enemySpawn()
        })
        
        spawnAditional = .scheduledTimer(withTimeInterval: 3.5, repeats: true, block: { timer in
            self.spawnAditionalBoosts()
        })
        
        enemySpawn()
        
        if level == 1 && !UserDefaults.standard.bool(forKey: "level_1_showed_tutor") {
            showTutor1()
        }
        
        if level == 2 && !UserDefaults.standard.bool(forKey: "level_2_showed_tutor") {
            showTutor2()
        }
        
        spawnAditionalBoosts()
    }
    
    private func spawnAditionalBoosts() {
        if !self.isPaused && Bool.random() {
            let spawnItem = ["multiplicator"].randomElement() ?? "multiplicator"
            let randomX = CGFloat.random(in: 300...size.width - 300)
            let node = SKSpriteNode(imageNamed: spawnItem)
            node.size = CGSize(width: 250, height: 120)
            node.position = CGPoint(x: randomX, y: size.height - 400)
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.categoryBitMask = 3
            node.physicsBody?.collisionBitMask = 1
            node.physicsBody?.contactTestBitMask = 1
            addChild(node)
            
            let moveDown = SKAction.moveTo(y: -200, duration: 8)
            let s = SKAction.sequence([moveDown, SKAction.removeFromParent()])
            node.run(s)
        }
    }
    
    private func showTutor1() {
        isPaused = true
        tutorImage = SKSpriteNode(imageNamed: "tutor_game_1")
        tutorImage!.zPosition = 1
        tutorImage!.size = CGSize(width: size.width - 300, height: 800)
        tutorImage!.position = CGPoint(x: size.width / 2, y: 450)
        addChild(tutorImage!)
    }
    
    private func showTutor2() {
        isPaused = true
        tutorImage = SKSpriteNode(imageNamed: "tutor_game_2")
        tutorImage!.zPosition = 1
        tutorImage!.size = CGSize(width: size.width - 300, height: 800)
        tutorImage!.position = CGPoint(x: size.width / 2, y: 450)
        addChild(tutorImage!)
    }
    
    private func addCannon() {
        cannon = SKSpriteNode(imageNamed: "cannon")
        cannon.position = CGPoint(x: size.width / 2, y: 300)
        cannon.size = CGSize(width: 400, height: 300)
        cannon.name = "cannon"
        cannon.zPosition = 2
        addChild(cannon)
    }
    
    private func addBackground() {
        let back = SKSpriteNode(imageNamed: "game_back")
        back.position = CGPoint(x: size.width / 2, y: size.height / 2)
        back.size = size
        back.zPosition = -1
        addChild(back)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let l = t.location(in: self)
            let obj = atPoint(l)
            if obj.name == "cannon" {
                isHoldCannon = true
            }
            if obj.name == "pause_button" {
                isPaused = true
                NotificationCenter.default.post(name: Notification.Name("game_paused"), object: nil)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let l = t.location(in: self)
            let obj = atPoint(l)
            if obj.name == "cannon" {
                isHoldCannon = false
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let l = t.location(in: self)
            let obj = atPoint(l)
            if obj.name == "cannon" {
                if l.x > 200 && l.x < size.width - 200 {
                    cannon.position.x = l.x
                }
                
                if tutorImage != nil {
                    let fade = SKAction.fadeOut(withDuration: 0.5)
                    tutorImage!.run(SKAction.sequence([fade, SKAction.removeFromParent()]))
                    isPaused = false
                    if level == 1 && !UserDefaults.standard.bool(forKey: "level_1_showed_tutor") {
                        UserDefaults.standard.set(true, forKey: "level_1_showed_tutor")
                    }
                    if level == 2 && !UserDefaults.standard.bool(forKey: "level_2_showed_tutor") {
                        UserDefaults.standard.set(true, forKey: "level_2_showed_tutor")
                    }
                }
            }
        }
    }
    
    private func cannonFire() {
        if !self.isPaused {
            let cannonBullet = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "cannon_bullet") ?? "cannon_bullet")
            cannonBullet.position = CGPoint(x: cannon.position.x, y: cannon.position.y + 50)
            cannonBullet.size = CGSize(width: 150, height: 90)
            cannonBullet.zPosition = 1
            cannonBullet.physicsBody = SKPhysicsBody(circleOfRadius: cannonBullet.size.width / 2)
            cannonBullet.physicsBody?.isDynamic = true
            cannonBullet.physicsBody?.affectedByGravity = false
            cannonBullet.physicsBody?.categoryBitMask = 1
            cannonBullet.physicsBody?.collisionBitMask = 2 | 3
            cannonBullet.physicsBody?.contactTestBitMask = 2 | 3
            cannonBullet.name = "bullet_\(UUID().uuidString)"
            addChild(cannonBullet)
            
            let moveAction = SKAction.move(to: CGPoint(x: cannonBullet.position.x, y: size.height + 100), duration: 1.5)
            let s = SKAction.sequence([moveAction, SKAction.removeFromParent()])
            cannonBullet.run(s)
        }
    }
    
    private var enemyNodes: [String: SKNode] = [:]
    private var enemyLabelNodes: [String: SKLabelNode] = [:]
    private var enemyLives: [String: Int] = [:]
    
    private func enemySpawn() {
        if !self.isPaused {
            let enemyId = UUID().uuidString
            let enemyLife = Int.random(in: 2...8)
            let randomX = CGFloat.random(in: 300...size.width - 300)
            let enemyNode = SKSpriteNode(imageNamed: "enemy")
            enemyNode.position = CGPoint(x: randomX, y: size.height + 100)
            enemyNode.size = CGSize(width: 150 + (enemyLife * 3), height: 90 + (enemyLife * 3))
            enemyNode.physicsBody = SKPhysicsBody(circleOfRadius: enemyNode.size.width / 2)
            enemyNode.physicsBody?.isDynamic = false
            enemyNode.physicsBody?.affectedByGravity = false
            enemyNode.physicsBody?.categoryBitMask = 2
            enemyNode.physicsBody?.collisionBitMask = 1
            enemyNode.physicsBody?.contactTestBitMask = 1
            enemyNode.name = "enemy_\(enemyId)"
            addChild(enemyNode)
            enemyNodes[enemyNode.name!] = enemyNode
            
            let labelLifes = SKLabelNode(text: "\(enemyLife)")
            labelLifes.fontName = "Yumi"
            labelLifes.fontSize = 62
            labelLifes.fontColor = .white
            labelLifes.position = enemyNode.position
            labelLifes.position.y -= 15
            labelLifes.name = "label_enemy_\(enemyId)"
            addChild(labelLifes)
            enemyLabelNodes[labelLifes.name!] = labelLifes
            enemyLives[enemyNode.name!] = enemyLife
            
            let moveDown = SKAction.moveTo(y: -200, duration: 8)
            let s = SKAction.sequence([moveDown, SKAction.removeFromParent()])
            enemyNode.run(s) {
                self.errors += 1
            }
            labelLifes.run(s)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 ||
            contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1 {
            let enemyBody: SKPhysicsBody
            let ball: SKPhysicsBody
            
            if contact.bodyA.categoryBitMask == 1 {
                enemyBody = contact.bodyB
                ball = contact.bodyA
            } else {
                enemyBody = contact.bodyA
                ball = contact.bodyB
            }
            
            if let enemyNode = enemyBody.node,
               let enemyName = enemyNode.name {
                ball.node?.removeFromParent()
                let lifesLeft = enemyLives[enemyName]
                if let lifesLeft = lifesLeft {
                    if lifesLeft > 1 {
                        // reduce enemy life
                        enemyLives[enemyName] = lifesLeft - 1
                        enemyLabelNodes["label_\(enemyName)"]?.text = "\(lifesLeft - 1)"
                    } else {
                        // remove enemy it is gained
                        enemyNode.removeAllActions()
                        enemyLabelNodes["label_\(enemyName)"]?.run(SKAction.fadeOut(withDuration: 0.2))
                        let newTexture = SKAction.setTexture(SKTexture(imageNamed: "broke_enemy"))
                        let wait = SKAction.wait(forDuration: 1)
                        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
                        let seq = SKAction.sequence([newTexture, wait, fadeOut, SKAction.removeFromParent()])
                        enemyNode.run(seq)
                        
                        enemyLives[enemyName] = nil
                        enemyNodes[enemyName] = nil
                        enemyLabelNodes["label_\(enemyName)"] = nil
                        currentObjectiveCount += 1
                    }
                }
            }
        }
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 3 ||
            contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 1 {
            let boostBody: SKPhysicsBody
            let ball: SKPhysicsBody
            
            if contact.bodyA.categoryBitMask == 1 {
                boostBody = contact.bodyB
                ball = contact.bodyA
            } else {
                boostBody = contact.bodyA
                ball = contact.bodyB
            }
            
            if let ballNode = ball.node {
                
                let cannonBullet = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "cannon_bullet") ?? "cannon_bullet")
                cannonBullet.position = CGPoint(x: ballNode.position.x, y: ballNode.position.y + 250)
                cannonBullet.size = CGSize(width: 150, height: 90)
                cannonBullet.zPosition = 1
                cannonBullet.physicsBody = SKPhysicsBody(circleOfRadius: cannonBullet.size.width / 2)
                cannonBullet.physicsBody?.isDynamic = true
                cannonBullet.physicsBody?.affectedByGravity = false
                cannonBullet.physicsBody?.categoryBitMask = 1
                cannonBullet.physicsBody?.collisionBitMask = 2 | 3
                cannonBullet.physicsBody?.contactTestBitMask = 2 | 3
                cannonBullet.name = "bullet_\(UUID().uuidString)"
                addChild(cannonBullet)
                
                let moveAction = SKAction.move(to: CGPoint(x: ballNode.position.x, y: size.height + 100), duration: 1.5)
                let s = SKAction.sequence([moveAction, SKAction.removeFromParent()])
                cannonBullet.run(s)
            }
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: CanonGameScene(level: 1))
            .ignoresSafeArea()
    }
}
