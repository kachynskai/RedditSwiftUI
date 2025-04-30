//
//  ButtonView.swift
//  RedditSwiftUI
//
//  Created by Iryna on 22.04.2025.
//

import SwiftUI

struct ButtonView: View {
    let buttonText: String
    let action: () -> Void
    var isDisabled: Bool = true
    var body: some View {
        Button(action: self.action){
            Text(buttonText)
                .foregroundStyle(.white)
                .font(.system(size: 20))
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("MainColor"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1)
    }
}

#Preview {
    ButtonView(buttonText: "Save", action:{ print("tratata")})
}
