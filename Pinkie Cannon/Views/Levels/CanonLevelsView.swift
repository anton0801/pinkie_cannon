import SwiftUI

struct CanonLevelsView: View {
    
    @Environment(\.presentationMode) var presMode
    @StateObject var manager = CanonLevelsManager()
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
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
                }
                .padding(.horizontal)
                
                Spacer()
                
                LazyVGrid(columns: [
                    GridItem(.fixed(80)),
                    GridItem(.fixed(80)),
                    GridItem(.fixed(80))
                ], spacing: 52) {
                    ForEach(manager.levels, id: \.id) { level in
                        if manager.isLevelUnlocked(level.id) {
                            NavigationLink(destination: CanonGameView(level: level.id)
                                .environmentObject(manager)
                                .environmentObject(userData)
                                .navigationBarBackButtonHidden(true)) {
                                    ZStack {
                                        Image("level_bg")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                        
                                        VStack {
                                            Text("\(level.id)")
                                                .font(.custom("Yumi", size: 24))
                                                .foregroundColor(.white)
                                            Text("LEVEL")
                                                .font(.custom("Yumi", size: 20))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                        } else {
                            ZStack {
                                Image("level_bg")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                
                                VStack {
                                    Text("\(level.id)")
                                        .font(.custom("Yumi", size: 24))
                                        .foregroundColor(.white)
                                    Text("LEVEL")
                                        .font(.custom("Yumi", size: 20))
                                        .foregroundColor(.white)
                                }
                                
                                Image("ic_lock")
                                    .resizable()
                                    .frame(width: 24, height: 32)
                                    .offset(y: 25)
                            }
                        }
                    }
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    CanonLevelsView()
        .environmentObject(UserData())
}
