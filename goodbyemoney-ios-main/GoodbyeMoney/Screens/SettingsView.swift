//
//  SettingsView.swift
//
//

import SwiftUI

struct SettingsView: View {
    
    @State var isActive: Bool = false
    @State var showCategories: Bool = false
    @State var showLogin: Bool = false
    @State var pinSetup: Bool = false
    @State var showAboutUs: Bool = false
    @State var isAppPINEnabled: Bool = false {
        didSet {
            // 在这里添加当开关状态改变时的逻辑
            if isAppPINEnabled {
                print("Toggle state is now enable")
            } else {
                print("fdfdfdf")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 4){
                    Image("u1")
                        .resizable()
                        .frame(width: 120, height: 120)
                    Spacer()
                        .frame(height: 15)
                    Text("User")
                        .font(.customfont(.bold, fontSize: 20))
                        .foregroundColor(.white)
                    
                    Text(UserManager.shared.currentUser!.email)
                        .font(.customfont(.medium, fontSize: 12))
                        .accentColor(.gray30)
                }
                .padding(.top, 30)
                
                
                VStack(alignment: .leading, spacing: 8){
                    VStack{
                        IconItemRow(icon: "category", title: "Category", value: "", onClick: {
                            showCategories.toggle()
                        })
                        
                        IconItemRow(icon: "p", title: "App Pin", value: "") {
                            pinSetup.toggle()
                        }
                        
                        IconItemRow(icon: "aboutus", title: "About Us", value: "", onClick: {
                            showAboutUs.toggle()
                        })
                        
                        IconItemRow(icon: "logout", title: "Log Out", value: "", onClick: {
                            showLogin.toggle()
                        })
                        
                    }
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity( 0.20))
                    .overlay {
                        RoundedRectangle(cornerRadius:  16)
                            .stroke( Color.gray70 , lineWidth: 1)
                    }
                    .cornerRadius(16)
                }
                .foregroundColor(.white)
                .padding(.top, 30)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .navigationTitle("Settings")
        
            .navigationDestination(isPresented: $showCategories) {
                Categories()
            }
            .navigationDestination(isPresented: $showLogin) {
                SignInView()
            }
            .navigationDestination(isPresented: $pinSetup) {
                PinSetupView()
            }
            .navigationDestination(isPresented: $showAboutUs) {
                AboutUsView()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
