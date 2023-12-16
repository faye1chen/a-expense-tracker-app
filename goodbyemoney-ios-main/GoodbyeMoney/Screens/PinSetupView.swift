//
//  PinSetupView.swift
//  GoodbyeMoney
//
//  Created by 李明霞 on 12/12/23.
//
import SwiftUI

struct PinSetupView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var pin: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var showSettings = false
    
    let pinLength = 4
    var textAlign:Alignment  = .leading
    
    var body: some View {
        NavigationStack {
                
                VStack {
                    
                    VStack{
                        Text("Setup PIN")
                            .font(.customfont(.bold, fontSize: 24))
                            .padding(.bottom, 10)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: textAlign)
                        
                        Text("Let's create a PIN for extra security")
                            .multilineTextAlignment(.leading)
                            .font(.customfont(.regular, fontSize: 18))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: textAlign)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                    .padding(.top, .topInsets + 40)
                    
                    // PIN Circles
                    HStack(spacing: 44) {
                        ForEach(0..<pinLength, id: \.self) { index in
                            Circle()
                                .stroke(Color.blue, lineWidth: 2)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    self.pin.count > index ? Circle().fill() .foregroundColor(.blue): nil
                                )
                        }
                    }
                    Spacer()
                    
                    // Number Pad
                    VStack(spacing: 30) {
                        ForEach(0..<3) { row in
                            HStack(spacing: 90) {
                                ForEach(1..<4) { column in
                                    Button(action: {
                                        self.appendPin(digit: row * 3 + column)
                                    }) {
                                        Text("\(row * 3 + column)")
                                            .font(.customfont(.bold, fontSize: 44))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        
                        // Bottom Row
                        HStack() {
                            Button(action: {
                                self.appendPin(digit: 0)
                            }) {
                                Text("0")
                                    .font(.customfont(.bold, fontSize: 48))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            // Delete Button
                            if pin.count > 0 {
                                Button(action: {
                                    self.pin = String(self.pin.dropLast())
                                }) {
                                    Image(systemName: "delete.left")
                                        .font(.largeTitle)
                                }
                            } else {
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 70)
                    }
                    .padding(.bottom, .bottomInsets + 8)
                }
                .onChange(of: pin) { newValue in
                    if newValue.count == pinLength {
                        // 将PIN存储到Keychain
                        let saved = KeychainManager.savePIN(pin: newValue, for: UserManager.shared.currentUser!.email)
                        if saved {
                            let key = UserManager.shared.currentUser!.email + "isAppPINEnabled"
                            UserDefaults.standard.set(true, forKey: key)
                            
                            // 处理PIN成功存储的情况
                            showingAlert = true
                            alertMessage = "PIN saved successfully."
                        } else {
                            // 处理PIN存储失败的情况
                            print("Failed to save PIN.")
                        }
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Info"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")){
                            showingAlert = false
                            alertMessage = ""
                        }
                    )
                }
            }
        
}
    
    private func appendPin(digit: Int) {
        guard pin.count < pinLength else { return }
        pin += "\(digit)"
    }
}

struct PinSetupView_Previews: PreviewProvider {
    static var previews: some View {
        PinSetupView()
    }
}

