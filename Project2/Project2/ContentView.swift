//
//  ContentView.swift
//  Project2
//
//  Created by jessica fung on 9/1/25.
//

import SwiftUI

//equalizer to reflect music playing
struct Equalizer: View {
    let size: Double //outer square to match album cover size
    let innerScale: Double //percentage of outer square reserved for bars

    let barCount: Int = 10
    let barWidth: Double = 5
    let barSpacing: Double = 8

    //sizes based on outer square and scale
    var innerSize: Double {size * innerScale} //inner square where bars live
    var minH: Double {innerSize * 0.04} //shortest bar height, 4% of innerSize
    var maxH: Double {innerSize * 0.32} //tallest bar height, 32% of innerSize

    @State var levels: [Double] = [] //current heights for each bar, changes every tick
    @State var timer: Timer? //animation timer

    var body: some View {
        ZStack {
            //background card
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.40))

            //equalizer bars
            HStack(spacing: barSpacing) { //lays bars horizontally with spacing
                ForEach(0..<barCount, id: \.self) {i in //unique ID for each element, range of integers 0-9
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient( //for bars
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.80),
                                    Color.white.opacity(0.40)
                                ]),
                                startPoint: .bottom, endPoint: .top
                            )
                        )
                        .frame(
                            width: barWidth,
                            height: max(6, i < levels.count ? levels[i] : minH) //assigning randomized values
                        )
                }
            }
            .frame(width: innerSize, height: innerSize)
        }
        
        .frame(width: size, height: size) //equalizer square
        .onAppear { //what appears for the first time
            //initialize bars with random heights
            levels = (0..<barCount).map { _ in Double.random(in: minH...maxH) }

            timer = Timer.scheduledTimer(withTimeInterval: 0.20, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.32)) {
                    for i in 0..<barCount {
                        levels[i] = Double.random(in: minH...maxH)
                    }
                }
            }
        }
        
        //stop and clear timer when view goes away
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
}

struct ContentView: View {
    let songs = ["From The Start", "Falling Behind", "Silver Lining"]

    //reveals album name after 3 wrong tries
    let albumNameBySong = [
        "From The Start": "Bewitched • 2023",
        "Falling Behind": "Everything I Know About Love • 2022",
        "Silver Lining":  "A Matter of Time (Standard Edition) • 2025"
    ]

    let coverImageBySong = [
        "From The Start": "Bewitched-FromTheStart",
        "Falling Behind": "EverythingIKnowAboutLove-FallingBehind",
        "Silver Lining":  "AMatterOfTime-SilverLining"
    ]

    //game state
    @State var pool: [String] = []
    @State var target = ""
    @State var guess = ""
    @State var feedback = ""
    @State var score = 0
    @State var wrongCount = 0

    let cardSize: Double = 240 //album cover, same as equalizer card size
    let eqInnerScale: Double = 0.80 //inner percentage scale for equalizer bars

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .black]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("𖤐 𖥔.   What's playing?   .𖥔 𖤐")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                //score
                Text("Song score: \(score)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 16)
                
                //equalizer before hint, cover after hint
                if wrongCount < 3 {
                    ZStack {
                        Circle().fill(Color.white.opacity(0.40))//blur
                            .blur(radius: 60)
                            .frame(width: cardSize, height: cardSize)
                        Equalizer(size: cardSize, innerScale: eqInnerScale)
                    }
                }
                    else {
                        ZStack {
                            Circle().fill(Color.white.opacity(0.40)) //blur
                                .blur(radius: 60)
                                .frame(width: cardSize, height: cardSize)
                        
                            if let image = coverImageBySong[target] { //insert album cover
                                Image(image)
                                    .resizable().scaledToFit()
                                    .frame(width: cardSize, height: cardSize)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                    .padding(.top, 16)
                            }
                        }
                }

                //input area
                VStack(spacing: 16) {
                    Text("Enter song title")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.80))
                        .padding(.top, 16)

                    TextField("", text: $guess)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(EdgeInsets(top: 0, leading: 64, bottom: 24, trailing: 64))

                    Button(action: submit) {
                        Text("Check answer")
                            .font(.headline).foregroundColor(.white)
                            .padding(.horizontal, 24).padding(.vertical, 16)
                            .frame(width: 200)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 80))
                            .overlay(RoundedRectangle(cornerRadius: 80) //opacity
                                .stroke(Color.white.opacity(0.4), lineWidth: 1.6))
                    }

                    if !feedback.isEmpty {
                        Text(feedback)
                            .font(.headline)
                            .foregroundColor(feedbackColor(feedback))
                    }

                    Button(action: startGame) {
                        Text("Restart game")
                            .font(.headline).foregroundColor(.white)
                            .padding(.horizontal, 24).padding(.vertical, 16)
                            .frame(width: 200)
                            .background(Color.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 80))
                            .overlay(RoundedRectangle(cornerRadius: 80) //opacity
                                .stroke(Color.white.opacity(0.35), lineWidth: 1.4))
                    }
                }
                .padding(.top, 2)
            }
        }
        .onAppear {if target.isEmpty { startGame()}}
    }

    //game logic
    func startGame() {
        score = 0; feedback = ""; guess = ""; wrongCount = 0
        pool = songs
        pickNextTarget()
    }

    func pickNextTarget() {
        feedback = ""; guess = ""; wrongCount = 0
        if pool.isEmpty {pool = songs} //loop in order
        target = pool.removeFirst()
    }

    func submit() {
        let guess = normalize(guess), correctAnswer = normalize(target)
 
        if guess == correctAnswer {
            score += 1; feedback = "Correct!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { pickNextTarget() }
        }
        else {
            wrongCount += 1
            feedback = (wrongCount == 3) ? "Hint: Album" : "Guess again"
        }
    }

    //case and punctuation checkFrom 
    func normalize(_ text: String) -> String {
        let lower = text.lowercased()
        let filtered = lower.filter { $0.isLetter || $0.isNumber || $0.isWhitespace }
        let collapsed = filtered.split(whereSeparator: \.isWhitespace).joined(separator: " ")
        return collapsed.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //color states
    func feedbackColor(_ text: String) -> Color {
        if text == "Correct!" {
            return .green
            }
        if text.hasPrefix("Hint: Album") {
            return .white.opacity(0.80)
            }
        return .red
      }
}

#Preview {
    ContentView()
}
