//
//  PinValidateView.swift
//  GoodbyeMoney
//
//  Created by 李明霞 on 12/13/23.
//

import SwiftUI

struct PinValidateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var pin: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showContentView = false
    @State private var verifyState = false
    let pinLength = 4
    var textAlign:Alignment  = .leading
    
    var body: some View {
        
        VStack {
            
            VStack{
                Text("APP PIN Verification")
                    .font(.customfont(.bold, fontSize: 24))
                    .padding(.bottom, 10)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: textAlign)
                
                Text("Remember the pin you set before?")
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
                let settingPin = KeychainManager.getPIN(for: UserManager.shared.currentUser!.email)
                
                showingAlert = true
                
                if settingPin == pin {
                    alertMessage = "Verification Successful"
                    verifyState = true
                } else {
                    alertMessage = "Wrong Pin"
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
                    
                    if verifyState {
                        dismiss()
                    } else {
                        pin = ""
                    }
                }
            )
        }
    }
    
    private func appendPin(digit: Int) {
        guard pin.count < pinLength else { return }
        pin += "\(digit)"
    }
}

//#Preview {
//    PinValidateView()
//}
struct PinValidateView_Previews: PreviewProvider {
    static var previews: some View {
        PinValidateView()
    }
}
