import SwiftUI

struct FailedGameView: View {
    
    var level: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Level \(level)")
                .font(.custom("Yumi", size: 20))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
            
            Spacer()
            
            Text("FAILED!")
                .font(.custom("Yumi", size: 28))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
            
            Spacer()
            
            ZStack {
                Image("game_result_bg")
                    .resizable()
                    .frame(width: 350, height: 250)
                
                HStack {
                    Spacer()
                    Image("zero_money")
                        .resizable()
                        .frame(width: 100, height: 140)
                    Spacer()
                    VStack {
                        Button {
                            NotificationCenter.default.post(name: Notification.Name("reply_game"), object: nil)
                        } label: {
                            Image("replay_btn")
                                .resizable()
                                .frame(width: 100, height: 50)
                        }
                        
                        Button {
                            NotificationCenter.default.post(name: Notification.Name("main_menu"), object: nil)
                        } label: {
                            Image("main_menu")
                                .resizable()
                                .frame(width: 100, height: 50)
                        }
                    }
                    Spacer()
                }
                .frame(width: 350)
            }
            
            Spacer()
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
    FailedGameView(level: 1)
}
