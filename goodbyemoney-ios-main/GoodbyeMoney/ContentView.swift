//
//  ContentView.swift
//  GoodbyeMoney
//
//

import SwiftUI
import RealmSwift
import AVKit

struct ContentView: View {
    @EnvironmentObject var realmManager: RealmManager
    @State var needPinVerification: Bool = false
    
    var body: some View {
        
            TabView {
                Expenses()
                    .tabItem {
                        Label("Expenses", systemImage: "tray.and.arrow.up.fill")
                    }
                
                Reports()
                    .tabItem {
                        Label("Reports", systemImage: "chart.bar.fill")
                    }
                
                Add()
                    .tabItem {
                        Label("Add", systemImage: "plus")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print(UserManager.shared.isAppPINEnabled)
                if UserManager.shared.isAppPINEnabled {
                    needPinVerification.toggle()
                }
            }
            .fullScreenCover(isPresented: $needPinVerification) {
                // 您的PIN验证视图
                PinValidateView()
            }
            .navigationBarBackButtonHidden(true)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
