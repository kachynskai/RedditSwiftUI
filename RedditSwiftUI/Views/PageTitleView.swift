//
//  PageTitleView.swift
//  RedditSwiftUI
//
//  Created by Iryna on 22.04.2025.
//

import SwiftUI

struct PageTitleView: View {
    let title: String
    var body: some View {
        Text(title)
            .foregroundStyle(Color("MainColor"))
            .font(.system(size: 30))
            .fontWeight(.medium)
            .padding(.vertical, 10)
    }
}
#Preview {
    PageTitleView(title: "Title")
}
