//
//  SignUpView.swift
//  Trackizer
//
//  Created by CodeForAny on 11/07/23.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var realmManager: RealmManager
    
    @State var txtEmail: String = ""
    @State var txtPassword: String = ""
    @State var showSignIn: Bool = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    func handleSignUp() {
        guard validateInputs() else {
            return
        }
        
        let newUser = User(email: txtEmail, password: txtPassword)
        
        self.realmManager.signUpNewUser(newUser)
        
        showSignIn.toggle()
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

        if realmManager.getUserByEmail(txtEmail) != nil {
            alertMessage = "Email is already registered"
            showingAlert = true
            
            return false
        }

        if !isValidPassword(txtPassword) {
            alertMessage = "Password is not valid"
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
                        .padding(.bottom, 20)
                    
                    HStack {
                        
                        Rectangle()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, maxHeight: 5)
                            .padding(.horizontal, 1)
                        
                        Rectangle()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, maxHeight: 5)
                            .padding(.horizontal, 1)
                        
                        Rectangle()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, maxHeight: 5)
                            .padding(.horizontal, 1)
                        
                        Rectangle()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 5, maxHeight: 5)
                            .padding(.horizontal, 1)
                        
                    }
                    .padding(.horizontal, 20)
                    .foregroundColor(.gray70)
                    .padding(.bottom, 20)
                    
                    Text("Use 8 or more characters with a mix of letters,\nnumbers & symbols.")
                        .multilineTextAlignment(.leading)
                        .font(.customfont(.regular, fontSize: 14))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .foregroundColor(.gray50)
                        .padding(.bottom, 20)
                    
                    PrimaryButton(title: "Get Started, it's free!", onPressed: {
                        handleSignUp()
                    })
                    
                    Spacer()
                    
                    Text("Do you have already an account?")
                        .multilineTextAlignment(.center)
                        .font(.customfont(.regular, fontSize: 14))
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    SecondaryButton(title: "Sign In", onPressed: {
                        showSignIn.toggle()
                    })
                    .padding(.bottom, .bottomInsets + 8)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("错误"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("好的")){
                        showingAlert = false
                        alertMessage = ""
                    }
                )
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
