//
//  SignInView.swift
//  Trackizer
//
//  Created by CodeForAny on 11/07/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userManager: UserManager
    // 表示 SignInView 依赖于一个RealmManager类型的环境对象
    @EnvironmentObject var realmManager: RealmManager
    
    @State var txtEmail: String = ""
    @State var txtPassword: String = ""

    @State var showSignUp: Bool = false
    @State var showHomePage: Bool = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    func handleSignIn() {
        guard validateInputs() else {
            print("Invalid Input.")
            return
        }
        
        let curUser = realmManager.signInUser(txtEmail, txtPassword)
        
        if curUser != nil {
            // TODO: Alert
            showHomePage.toggle()
            
            userManager.currentUser = curUser!
            print("Cur User...")
            print(curUser!)
        } else {
            print("User not found or password is incorrect.")
            return
        }
    }
    
    func validateInputs() -> Bool {
        guard !isEmptyInput(txtEmail),
              !isEmptyInput(txtPassword) else {
            
            alertMessage = "Inputs cannot be empty"
            showingAlert = true
            
            return false
        }

        if !isValidEmail(txtEmail) {
            alertMessage = "Email format is not valid"
            showingAlert = true
        
            return false
        }
        
        return true
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: .screenWidth, height: .screenHeight)
                
                VStack{
                    Spacer()
                    
                    RoundTextField(title: "Email", text: $txtEmail, keyboardType: .emailAddress)
                    
                        .padding(.horizontal, 20)
                        .padding(.bottom, 15)
                    
                    
                    
                    RoundTextField(title: "Passowrd", text: $txtPassword, isPassword: true)
                    
                        .padding(.horizontal, 20)
                        .padding(.bottom, 60)
                    
                    PrimaryButton(title: "Sign In", onPressed: {
                        handleSignIn()
                    })
                    
                    Spacer()
                    
                    Text("If you don't have an account yet?")
                        .multilineTextAlignment(.center)
                        .font(.customfont(.regular, fontSize: 14))
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    SecondaryButton(title: "Sign Up", onPressed: {
                        showSignUp.toggle()
                    })
                    .padding(.bottom, .bottomInsets + 8)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $showHomePage) {
                ContentView()
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView().environmentObject(RealmManager()).environmentObject(UserManager())
            }

        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
