import SwiftUI

struct CannonSettingsView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var shopViewModel: ShopBallsViewModel
    
    @State var soundsApp = UserDefaults.standard.bool(forKey: "sounds_app")
    @State var music = UserDefaults.standard.bool(forKey: "musicApp")
    
    @State var currentIndexBalls = 0 {
        didSet {
            currentBall = shopViewModel.purchasedBalls[currentIndexBalls]
        }
    }
    @State var currentBall: Ball? = nil
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("menu_btn")
                        .resizable()
                        .frame(width: 42, height: 42)
                }
                Spacer()
                
                ZStack {
                    Image("money_back")
                        .resizable()
                        .frame(width: 100, height: 50)
                    Text("\(userData.cash)")
                        .font(.custom("Yumi", size: 18))
                        .foregroundColor(.white)
                        .offset(x: 15)
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text("SETTINGS")
                .font(.custom("Yumi", size: 32))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
            
            ZStack {
                Image("game_result_bg")
                    .resizable()
                    .frame(width: 350, height: 250)
                
                HStack {
                    Spacer()
                    VStack {
                        Text("BALL SKIN")
                            .font(.custom("Yumi", size: 18))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                        
                        Spacer()
                        
                        HStack {
                            Button {
                                if currentIndexBalls > 0 {
                                    withAnimation(.linear) {
                                        currentIndexBalls -= 1
                                    }
                                }
                            } label: {
                                Image("arrow_left")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            if let ball = currentBall {
                                VStack {
                                    Spacer()
                                    
                                    Image(ball.name)
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                    
                                    Spacer()
                                    
                                    if userData.selectedBall != ball.name {
                                        Button {
                                            userData.selectedBall = ball.name
                                        } label: {
                                            Image("select_btn")
                                                .resizable()
                                                .frame(width: 80, height: 30)
                                        }
                                    }
                                    
                                }
                            }
                            
                            Button {
                                if currentIndexBalls < shopViewModel.purchasedBalls.count - 1 {
                                    withAnimation(.linear) {
                                        currentIndexBalls += 1
                                    }
                                }
                            } label: {
                                Image("arrow_next")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        Spacer()
                    }
                    .frame(height: 150)
                    
                    Spacer()
                    
                    VStack {
                        Text("SOUNDS")
                            .font(.custom("Yumi", size: 18))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                        
                        HStack {
                            Button {
                                withAnimation(.linear) {
                                    soundsApp = true
                                }
                            } label: {
                                if soundsApp {
                                    Image("sounds_on_btn")
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                } else {
                                    Image("sounds_on_btn")
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                        .opacity(0.6)
                                }
                            }
                            
                            Spacer().frame(width: 32)
                            
                            Button {
                                withAnimation(.linear) {
                                    soundsApp = false
                                }
                            } label: {
                                if !soundsApp {
                                    Image("sound_off_btn")
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                } else {
                                    Image("sound_off_btn")
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                        .opacity(0.6)
                                }
                            }
                        }
                        
                        Text("MUSIC")
                            .font(.custom("Yumi", size: 18))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                            .padding(.top)
                        
                        HStack {
                            Button {
                                withAnimation(.linear) {
                                    music = false
                                }
                            } label: {
                                Image("minus_btn")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            ZStack {
                                Image("music_indicator")
                                    .resizable()
                                    .frame(width: 100, height: 30)
                                
                                if music {
                                    Image("full")
                                        .resizable()
                                        .frame(width: 85, height: 20)
                                }
                            }
                            Button {
                                withAnimation(.linear) {
                                    music = true
                                }
                            } label: {
                                Image("plus_btn")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                    Spacer()
                }
            }
            
            Spacer()
        }
        .onAppear {
            currentBall = shopViewModel.purchasedBalls[currentIndexBalls]
        }
        .background(
            Image("main_back_image")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .onChange(of: soundsApp) { newvalue in
            UserDefaults.standard.set(newvalue, forKey: "sounds_app")
        }
        .onChange(of: music) { newvalue in
            UserDefaults.standard.set(newvalue, forKey: "musicApp")
        }
    }
}

#Preview {
    CannonSettingsView()
        .environmentObject(UserData())
        .environmentObject(ShopBallsViewModel())
}
