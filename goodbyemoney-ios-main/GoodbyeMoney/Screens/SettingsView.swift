//
//  SettingsView.swift
//  Trackizer
//
//  Created by CodeForAny on 16/07/23.
//

import SwiftUI

struct SettingsView: View {
    
    @State var isActive: Bool = false
    @State var showCategories: Bool = false
    @State var showLogin: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 4){
                    Image("u1")
                        .resizable()
                        .frame(width: 70, height: 70)
                    Spacer()
                        .frame(height: 15)
                    Text("User")
                        .font(.customfont(.bold, fontSize: 20))
                        .foregroundColor(.white)
                    // TODO: 记得改回来
                    //                Text(UserManager.shared.currentUser!.email)
                    //                    .font(.customfont(.medium, fontSize: 12))
                    //                    .accentColor(.gray30)
                    
                    Text("UserManager.shared.currentUser!.email")
                        .font(.customfont(.medium, fontSize: 12))
                        .accentColor(.gray30)
                }
                .padding(.top, .topInsets + 200)
                
                VStack(alignment: .leading, spacing: 8){
                    Text("General")
                        .font(.customfont(.semibold, fontSize: 14))
                        .padding(.top, 40)
                    
                    VStack{
                        IconItemRow(icon: "category", title: "Category", value: "", onClick: {
                            showCategories.toggle()
                        })
                        
                        IconItemRow(icon: "aboutus", title: "About Us", value: "", onClick: {
                            showCategories.toggle()
                        })
                        
                        IconItemRow(icon: "logout", title: "Log Out", value: "", onClick: {
                            showLogin.toggle()
                        })
                        
                    }
                    .padding(.vertical, 10)
                    .background(Color.gray60.opacity( 0.2))
                    .overlay {
                        RoundedRectangle(cornerRadius:  16)
                            .stroke( Color.gray70 , lineWidth: 1)
                    }
                    .cornerRadius(16)
                }
                .foregroundColor(.white)
                
            }
            .padding(.horizontal, 20)
            .navigationTitle("Settings")
            .background(Color.grayC)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $showCategories) {
                Categories()
            }
            .navigationDestination(isPresented: $showLogin) {
                SignInView()
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
