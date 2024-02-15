//
//  SpeechTextView.swift
//  OnlineEvents
//
//  Created by Luka Grujic on 08/01/2024.
//

import SwiftUI

struct SpeechBubbleView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(10)
            .foregroundColor(.white)
            .background(Color(hex: "#0D5474"))
            .cornerRadius(10)
            .shadow(radius: 5)
            .frame(width: 200)
    }
}
