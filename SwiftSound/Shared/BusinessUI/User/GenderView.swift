//
//  GenderView.swift
//  SwiftSound
//
//  Created by Jinchao Lin on 2026/8/23.
//

import SwiftUI

struct GenderView: View {
    let gender: Gender

    var body: some View {
        switch gender {
        case .male:
            Image(systemName: "person.fill")
                .font(.font14)
                .foregroundStyle(Color.blue)
        case .female:
            Image(systemName: "person.fill")
                .font(.font14)
                .foregroundStyle(Color.pink)
        case .unknow:
            EmptyView()
        }
    }
}

#Preview {
    HStack {
        GenderView(gender: .male)
        GenderView(gender: .female)
        GenderView(gender: .unknow)
    }
    .padding()
}
