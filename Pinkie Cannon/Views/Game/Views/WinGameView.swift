import SwiftUI

struct WinGameView: View {
    
    var level: Int
    
    var body: some View {
        VStack {
            Spacer()
                        
            Text("Level \(level)")
                .font(.custom("Yumi", size: 20))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
            
            Spacer()
            
            Text("congratulations!")
                .font(.custom("Yumi", size: 42))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
            
            Spacer()
            
            ZStack {
                Image("game_result_bg")
                    .resizable()
                    .frame(width: 350, height: 250)
                
                HStack {
                    Spacer()
                    ZStack {
                        Image("cash")
                            .resizable()
                            .frame(width: 100, height: 140)
                        
                        VStack {
                            Spacer()
                            Text("+2k")
                                .font(.custom("Yumi", size: 24))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 2, x: 0, y: 0)
                                .padding(.bottom)
                        }
                    }
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
    WinGameView(level: 1)
}
