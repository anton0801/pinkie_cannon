import SwiftUI
import SpriteKit

enum GameView {
    case game, pause, failed, win
}

struct CanonGameView: View {
    
    var level: Int
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var manager: CanonLevelsManager
    @EnvironmentObject var userData: UserData
    
    @State var cannonScene: CanonGameScene!
    @State var gameView: GameView = .game
    
    var body: some View {
        ZStack {
            if let scene = cannonScene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
            
            switch (gameView) {
            case .pause:
                GamePauseView(level: level)
            case .win:
                WinGameView(level: level)
            case .failed:
                FailedGameView(level: level)
            default:
                EmptyView()
            }
        }
        .onAppear {
            cannonScene = CanonGameScene(level: level)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("continue_game")), perform: { _ in
            cannonScene.isPaused = false
            withAnimation(.linear) {
                gameView = .game
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("reply_game")), perform: { _ in
            cannonScene = cannonScene.retryGame()
            withAnimation(.linear) {
                gameView = .game
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("main_menu")), perform: { _ in
            presMode.wrappedValue.dismiss()
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("game_paused")), perform: { _ in
            withAnimation(.linear) {
                gameView = .pause
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("loss_game")), perform: { _ in
            withAnimation(.linear) {
                gameView = .failed
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("win_game")), perform: { _ in
            manager.unlockLevel(level + 1)
            userData.cash += 2000
            withAnimation(.linear) {
                gameView = .win
            }
        })
    }
}

#Preview {
    CanonGameView(level: 1)
        .environmentObject(CanonLevelsManager())
        .environmentObject(UserData())
}
