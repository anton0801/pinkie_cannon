import SwiftUI

struct GamePauseView: View {
    
    var level: Int
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Level \(level)")
                .font(.custom("Yumi", size: 20))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
            
            Spacer()
            
            Text("PAUSED")
                .font(.custom("Yumi", size: 28))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
            
            Spacer()
            
            Button {
                NotificationCenter.default.post(name: Notification.Name("continue_game"), object: nil)
            } label: {
                Image("continue_btn")
                    .resizable()
                    .frame(width: 250, height: 80)
            }
            
            Button {
                NotificationCenter.default.post(name: Notification.Name("reply_game"), object: nil)
            } label: {
                Image("replay_btn")
                    .resizable()
                    .frame(width: 250, height: 80)
            }
            
            Button {
                NotificationCenter.default.post(name: Notification.Name("main_menu"), object: nil)
            } label: {
                Image("main_menu")
                    .resizable()
                    .frame(width: 250, height: 80)
            }
            
            Spacer()
        }
        .background(
            Image("main_back_image")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    GamePauseView(level: 1)
}
