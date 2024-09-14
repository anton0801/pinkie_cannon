import SwiftUI

struct ContentView: View {
    
    @StateObject var userData = UserData()
    @StateObject var shopViewModel = ShopBallsViewModel()
    @State var exitAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: BallsShopView()
                        .environmentObject(userData)
                        .environmentObject(shopViewModel)
                        .navigationBarBackButtonHidden(true)) {
                            VStack {
                                Image("shop_btn")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                Text("SHOP")
                                    .font(.custom("Yumi", size: 18))
                                    .foregroundColor(.white)
                            }
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
                    
                    Spacer()
                    
                    NavigationLink(destination: CannonSettingsView()
                        .environmentObject(userData)
                        .environmentObject(shopViewModel)
                        .navigationBarBackButtonHidden(true)) {
                            VStack {
                                Image("settings_btn")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                Text("SETTINGS")
                                    .font(.custom("Yumi", size: 18))
                                    .foregroundColor(.white)
                            }
                        }
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
                
                NavigationLink(destination: CanonLevelsView()
                    .environmentObject(userData)
                    .navigationBarBackButtonHidden(true)) {
                        Image("play_btn")
                            .resizable()
                            .frame(width: 280, height: 100)
                    }
                
                Button {
                    exitAlert = true
                } label: {
                    Image("exit_game_btn")
                        .resizable()
                        .frame(width: 280, height: 100)
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
            .alert(isPresented: $exitAlert) {
                Alert(title: Text("Alert!"), message: Text("Do you want to quit the game?"), primaryButton: .default(Text("Yes"), action: {
                    exit(0)
                }), secondaryButton: .default(Text("No")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
