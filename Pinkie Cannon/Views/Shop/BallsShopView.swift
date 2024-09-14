import SwiftUI

struct BallsShopView: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var shopViewModel: ShopBallsViewModel
    
    @State var currentBallNormalIndex = 0 {
        didSet {
            currentBallNormal = shopViewModel.regularBalls[currentBallNormalIndex]
        }
    }
    @State var currentBallNormal: Ball? = nil
    
    @State var currentBallSpecialIndex = 0 {
        didSet {
            currentBallSpecial = shopViewModel.specialBalls[currentBallSpecialIndex]
        }
    }
    @State var currentBallSpecial: Ball? = nil
    
    @State var buyStatus = false
    
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
            
            Text("SHOP")
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
                        Text("normal skins")
                            .font(.custom("Yumi", size: 18))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                        
                        Spacer()
                        
                        HStack {
                            Button {
                                if currentBallNormalIndex > 0 {
                                    withAnimation(.linear) {
                                        currentBallNormalIndex -= 1
                                    }
                                }
                            } label: {
                                Image("arrow_left")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            if let ball = currentBallNormal {
                                VStack {
                                    Spacer()
                                    
                                    Image(ball.name)
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                    
                                    Spacer()
                                    
                                    ZStack {
                                        Image("money_back")
                                            .resizable()
                                            .frame(width: 60, height: 30)
                                        Text("\(ball.price)")
                                            .font(.custom("Yumi", size: 10))
                                            .foregroundColor(.white)
                                            .offset(x: 10)
                                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                                    }
                                    
                                    Spacer()
                                    
                                    if userData.selectedBall == ball.name {
                                        
                                    } else {
                                        if shopViewModel.purchasedBalls.contains(where: { $0.name == ball.name }) {
                                            Button {
                                                userData.selectedBall = ball.name
                                            } label: {
                                                Image("select_btn")
                                                    .resizable()
                                                    .frame(width: 80, height: 30)
                                            }
                                        } else {
                                            Button {
                                                buyStatus = !shopViewModel.purchaseBall(ball, userData: userData)
                                            } label: {
                                                Image("buy")
                                                    .resizable()
                                                    .frame(width: 80, height: 30)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Button {
                                if currentBallNormalIndex < shopViewModel.regularBalls.count - 1 {
                                    withAnimation(.linear) {
                                        currentBallNormalIndex += 1
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
                        Text("special skins")
                            .font(.custom("Yumi", size: 18))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                        
                        Spacer()
                        
                        HStack {
                            Button {
                                if currentBallSpecialIndex > 0 {
                                    withAnimation(.linear) {
                                        currentBallSpecialIndex -= 1
                                    }
                                }
                            } label: {
                                Image("arrow_left")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            if let ball = currentBallSpecial {
                                VStack {
                                    Spacer()
                                    
                                    Image(ball.name)
                                        .resizable()
                                        .frame(width: 42, height: 42)
                                    
                                    Spacer()
                                    
                                    ZStack {
                                        Image("money_back")
                                            .resizable()
                                            .frame(width: 60, height: 30)
                                        Text("\(ball.price)")
                                            .font(.custom("Yumi", size: 10))
                                            .foregroundColor(.white)
                                            .offset(x: 10)
                                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                                    }
                                    
                                    Spacer()
                                    
                                    if userData.selectedBall == ball.name {
                                        
                                    } else {
                                        if shopViewModel.purchasedBalls.contains(where: { $0.name == ball.name }) {
                                            Button {
                                                userData.selectedBall = ball.name
                                            } label: {
                                                Image("select_btn")
                                                    .resizable()
                                                    .frame(width: 80, height: 30)
                                            }
                                        } else {
                                            Button {
                                                buyStatus = !shopViewModel.purchaseBall(ball, userData: userData)
                                            } label: {
                                                Image("buy")
                                                    .resizable()
                                                    .frame(width: 80, height: 30)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Button {
                                if currentBallSpecialIndex < shopViewModel.regularBalls.count - 1 {
                                    withAnimation(.linear) {
                                        currentBallSpecialIndex += 1
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
                    
                }
            }
        
            Spacer()
        }
        .onAppear {
            currentBallNormal = shopViewModel.regularBalls[0]
            currentBallSpecial = shopViewModel.specialBalls[0]
        }
        .background(
            Image("main_back_image")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width,
                       minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $buyStatus) {
            Alert(
                title: Text("Error purchase!"),
                message: Text("Could not buy this ball/snapshot, you do not have enough cash to buy it :("),
                dismissButton: .cancel(Text("Got it"))
            )
        }
    }
}

#Preview {
    BallsShopView()
        .environmentObject(UserData())
        .environmentObject(ShopBallsViewModel())
}
