//
//  ContentView.swift
//  Project1
//
//  Created by jessica fung on 9/1/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("𖤐 𖥔.   Matched for you   .𖥔 𖤐")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.8))
                
//            Text("Forget-Me-Not")
//                    .font(.title)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .padding(.top, 12)
            
            AlbumSongTitles()
                .padding(.top, -16)
                
                ZStack {
                    Circle() //glow
                        .fill(Color.white.opacity(0.4))
                        .blur(radius:60)
                        .frame(width: 240, height: 240)
                    
                    Image("Laufey_AMatterOfTime")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.top, 24)
                }
                
            Text("A Matter of Time (Standard Edition)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                    
            Text("Laufey • Album • 2025")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, -4)
                
            Button(action: {}) {
                Text("Play Album")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .frame(width:180)
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.4),lineWidth: 1.6))
                    .padding(.top, 24)
                }
            }
        }
    }
}


struct AlbumSongTitles: View {
@State private var index = 0
    
    let lines = [
        "Forget-Me-Not",
        "Castle in Hollywood",
        "Silver Lining",
        "Tough Luck",
        "Lover Girl",
        "Snow White",
        "Too Little, Too Late",
        "Mr. Eclectic",
        "Carousel"
    ]
    
    var body: some View {
        Text(lines[index]) //timer
            .font(.title)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.top, 24)
            .multilineTextAlignment(.center)
            .onReceive(Timer.publish(every: 2, on: .main, in: .common).autoconnect())
            {_ in index = (index + 1) % lines.count}
    }
}

#Preview {
    ContentView()
}
