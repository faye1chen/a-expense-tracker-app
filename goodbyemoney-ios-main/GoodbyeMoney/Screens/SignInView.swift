//
//  SignInView.swift
//
//

import SwiftUI

struct SignInView: View {
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
            return
        }
//        txtEmail = "Alicelmx@126.com"
//        txtPassword = "lmx1994.LMX@"
        
//        txtEmail = "Xuyi@gmail.com"
//        txtPassword = "lmx1994.LMX@"
//        UserDefaults.standard.set(false, forKey: "isAppPINEnabled")
        
        let curUser = realmManager.signInUser(txtEmail, txtPassword)
        
        if curUser != nil {
            showHomePage.toggle()
            
            // 登陆后存储用户信息和用户设置
            UserManager.shared.currentUser = curUser!
            let key = UserManager.shared.currentUser!.email + "isAppPINEnabled"
            UserManager.shared.isAppPINEnabled = UserDefaults.standard.bool(forKey: key)
            
            print(key)
        } else {
            alertMessage = "User not found or password is incorrect."
            showingAlert = true
            
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
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")){
                        showingAlert = false
                        alertMessage = ""
                    }
                )
            }
            .onAppear(){
                // realmManager.deleteAllData()
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $showHomePage) {
                ContentView()
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }

        }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
