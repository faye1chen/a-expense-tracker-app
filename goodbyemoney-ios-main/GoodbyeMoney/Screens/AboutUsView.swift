//
//  AboutUsView.swift
//  GoodbyeMoney
//
//  Created by Yifei.Chen on 12/13/23.
//

import Foundation
import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("About Our Team")
                    .font(.title)
                    .fontWeight(.bold)

                Text("We are a passionate team of developers focused on creating innovative and user-friendly software. Our mission is to make a positive impact in the world through our applications.")
                    .font(.body)
                    .foregroundColor(.secondary)

                Text("Our team members come from diverse backgrounds, possessing a wealth of technical and creative skills, dedicated to delivering the best user experience.")

                Text("Contact Us")
                    .font(.headline)
                    .padding(.top, 10)

                Link("Visit our GitHub", destination: URL(string: "https://github.com/faye1chen/a-expense-tracker-app")!)
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationBarTitle("About Us", displayMode: .inline)
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
