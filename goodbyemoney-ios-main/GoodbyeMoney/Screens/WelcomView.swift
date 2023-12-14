//
//  WelcomView.swift
//
//

import SwiftUI

struct WelcomView: View {
    // @StateObject var realmManager = RealmManager()
    
    @State var showSignIn: Bool = false

    var body: some View {
        NavigationStack {
            ZStack{
                Image("welcome_screen")
                    .resizable()
                    .scaledToFill()
                    .frame(width: .screenWidth, height: .screenHeight)
                
                VStack{
                    Spacer()
                    PrimaryButton(title: "Sign In", onPressed: {
                        showSignIn.toggle()
                    })
                    .padding(.bottom, .bottomInsets)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $showSignIn) {
                SignInView()
            }
        }
    }
}

struct WelcomView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomView()
    }
}
