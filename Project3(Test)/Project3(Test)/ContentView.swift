//
//  ContentView.swift
//  Project3
//
//  Created by jessica fung on 9/16/25.
//

import SwiftUI
import AVKit
import AVFoundation

struct ContentView: View {
    var body: some View {
        NavigationStack {   // CHANGED: NavigationView → NavigationStack
            WelcomeView()
        }
    }
}

//Onboarding: Page 1
struct WelcomeView: View {
    @State var name = ""

    var isNameEmpty: Bool {
        name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack {
            BlobBackground()

            VStack(spacing: 24) {
                Spacer(minLength: 40)

                Text("Find your music archetype")
                    .font(.largeTitle).bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)

                ZStack(alignment: .leading) {
                    if name.isEmpty {
                        Text("Enter your name")
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                    }

                    TextField("", text: $name)
                        .foregroundColor(.white)
                        .tint(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                }
                .background(Color.white.opacity(0.16))
                .cornerRadius(48)
                .overlay(
                    RoundedRectangle(cornerRadius: 48)
                        .stroke(Color.white.opacity(0.64), lineWidth: 1)
                )
                .padding(.horizontal, 56)
                .padding(.bottom, 32)

                NavigationLink {
                    GenresView()
                } label: {
                    HStack(spacing: 8) {
                        Text("Get started").font(.headline)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white.opacity(0), lineWidth: 1)
                            .allowsHitTesting(false)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.24), radius: 16, x: 0, y: 6)
                }
                .opacity(isNameEmpty ? 0.6 : 1)
                .disabled(isNameEmpty)

                Spacer()
            }
            .padding(.top, 8)
        }
    }
}

struct BlobBackground: View {
    @State var move1 = false
    @State var move2 = false
    @State var move3 = false
    @State var scale1: CGFloat = 1.0
    @State var scale2: CGFloat = 1.0
    @State var scale3: CGFloat = 1.0

    let blur: CGFloat = 120
    let baseOpacity: Double = 1.0

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.opacity(baseOpacity).ignoresSafeArea()

                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: geo.size.width * 0.80)
                        .scaleEffect(scale1)
                        .position(x: move1 ? geo.size.width * 0.80 : geo.size.width * 0.20,
                                  y: move1 ? geo.size.height * 0.64 : geo.size.height * 0.32)
                        .blur(radius: blur)
                        .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: move1)
                        .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: scale1)

                    Circle()
                        .fill(Color.purple)
                        .frame(width: geo.size.width * 0.80)
                        .scaleEffect(scale2)
                        .position(x: move2 ? geo.size.width * 0.80 : geo.size.width * 0.20,
                                  y: move2 ? geo.size.height * 0.40 : geo.size.height * 0.80)
                        .blur(radius: blur)
                        .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: move2)
                        .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: scale2)

                    Circle()
                        .fill(Color.blue)
                        .frame(width: geo.size.width * 0.40)
                        .scaleEffect(scale3)
                        .position(x: move3 ? geo.size.width * 0.40 : geo.size.width * 0.40,
                                  y: move3 ? geo.size.height * 0.24 : geo.size.height * 0.80)
                        .blur(radius: blur)
                        .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: move3)
                        .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: scale3)
                }
                .compositingGroup()
                .blendMode(.plusLighter)
                .saturation(1.20)
                .opacity(0.80)
            }
            .onAppear {
                move1 = true; move2 = true; move3 = true
                scale1 = 1.10; scale2 = 1.06; scale3 = 1.08
            }
        }
    }
}


//Onboarding: Page 2
struct GenresView: View {
    @State var selected: Set<String> = []

    let genres = [
        "Pop", "Rock", "Hip Hop", "Electronic",
        "Country", "Indie", "R&B", "Jazz",
        "Blues", "Classical", "Folk", "Latin"
    ]

    var isValid: Bool { (1...3).contains(selected.count) }

    var body: some View {
        ZStack {
            BlobBackground() //Keep moving blobs

            VStack(spacing: 24) {
                Spacer(minLength: 24)

                Text("What genres do you listen to the most?")
                    .font(.title).bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 48)

                Text("Select up to 3")
                    .foregroundColor(.white.opacity(0.80))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)

                //Grid
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 120), spacing: 12)],
                        spacing: 12
                    ) {
                        ForEach(genres, id: \.self) { g in
                            GenreChip(
                                label: g,
                                isSelected: selected.contains(g)
                            ) {
                                toggle(g)
                            }
                        }
                    }
                    .padding(.horizontal, 48)
                }

                //Footnote + Continue
                let count = selected.count
                Text("\(count) of 3 selected")
                    .foregroundColor(.white.opacity(0.80))
                    .font(.subheadline)

                NavigationLink {
                    SongsView()
                } label: {
                    HStack(spacing: 8) {
                        Text("Continue").font(.headline)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white.opacity(0), lineWidth: 1)
                            .allowsHitTesting(false)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.24), radius: 16, x: 0, y: 6)
                }
                .opacity(isValid ? 1 : 0.6)
                .disabled(!isValid)

                Spacer(minLength: 24)
            }
            .padding(.top, 8)
        }
    }

    func toggle(_ g: String) {
        if selected.contains(g) {
            selected.remove(g)
        } else if selected.count < 3 {
            selected.insert(g)
        } //Ignore taps when already at 3
    }
}

//Rounded chips
struct GenreChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity) //Fills the grid cell width
                .background(isSelected ? Color.white.opacity(0.24) : Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color.white.opacity(0.88) : Color.white.opacity(0.80), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

//Onboarding: Page 3
struct Track: Identifiable, Hashable {
    var id: String { "\(title.lowercased())_\(artist.lowercased())" }
    let title: String
    let artist: String
}

struct SongsView: View {
    @State var selected: [Track] = []
    @State var query = ""

    let catalog: [Track] = [
        Track(title: "Fly Me to the Moon", artist: "Frank Sinatra"),
        Track(title: "Yellow", artist: "Coldplay"),
        Track(title: "I Fall in Love Too Easily", artist: "Chet Baker"),
        Track(title: "Chasing Cars", artist: "Snow Patrol"),
        Track(title: "Vienna", artist: "Billy Joel"),
    ]

    let albumArtMap: [String: String] = [
        "fly me to the moon_frank sinatra": "cover_fly_me_to_the_moon",
        "yellow_coldplay": "cover_yellow",
        "i fall in love too easily_chet baker": "cover_chet_baker_fall_in_love",
        "chasing cars_snow patrol": "cover_chasing_cars",
        "vienna_billy joel": "cover_vienna",
    ]

    var canContinue: Bool { selected.count == 5 }

    var results: [Track] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty { return [] }
        let selectedIDs = Set(selected.map { $0.id })
        return catalog
            .filter { !selectedIDs.contains($0.id) }
            .filter { t in startsWithPrefix(t.title, q) }
            .prefix(8)
            .map { $0 }
    }

    var body: some View {
        ZStack {
            BlobBackground()

            VStack(spacing: 24) {
                Spacer(minLength: 24)

                Text("Your favorite songs")
                    .font(.title).bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)

                Text("Select 5 to continue")
                    .foregroundColor(.white.opacity(0.80))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)

                //Search bar
                ZStack(alignment: .leading) {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.8))
                            .frame(width: 18)
                        TextField("", text: $query)
                            .foregroundColor(.white)
                            .tint(.white)
                            .disableAutocorrection(true)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)

                    if query.isEmpty {
                        Text("Search song title")
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 44)
                            .padding(.vertical, 14)
                            .allowsHitTesting(false)
                    }
                }
                .background(Color.white.opacity(0.16))
                .overlay(
                    RoundedRectangle(cornerRadius: 48)
                        .stroke(Color.white.opacity(0.64), lineWidth: 1)
                )
                .cornerRadius(48)
                .padding(.horizontal, 32)
                .zIndex(2)

                //Floating results overlay anchored to the search area
                if !results.isEmpty && selected.count < 5 {
                    VStack(spacing: 10) {
                        ScrollView {
                            LazyVStack(spacing: 10) {
                                ForEach(results) { track in
                                    TrackCardResult(
                                        track: track,
                                        imageName: albumArtMap[track.id],
                                        onAdd: { add(track) }
                                    )
                                }
                            }
                            .padding(8)
                        }
                        .frame(maxHeight: 260)
                    }
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.white.opacity(0.28), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .black.opacity(0.24), radius: 16, x: 0, y: 6)
                    .padding(.horizontal, 32)
                    .padding(.top, -8) //sits visually below the field
                    .zIndex(3)
                }

                //Selected list
                if !selected.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(selected.count)/5 selected")
                                .foregroundColor(.white.opacity(0.80))
                                .font(.subheadline)

                            ForEach(selected) { track in
                                TrackCardSelected(
                                    track: track,
                                    imageName: albumArtMap[track.id],
                                    onRemove: { remove(track) }
                                )
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 16)
                    }
                    .scrollIndicators(.hidden)
                    .zIndex(1)
                }

                Spacer(minLength: 12)

                NavigationLink {
                    VibesView()
                } label: {
                    HStack(spacing: 8) {
                        Text("Continue").font(.headline)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white.opacity(0), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.24), radius: 16, x: 0, y: 6)
                }
                .opacity(canContinue ? 1 : 0.6)
                .disabled(!canContinue)

                Spacer(minLength: 12)
            }
            .padding(.top, 8)
        }
    }

    //Actions
    func add(_ track: Track) {
        guard selected.count < 5 else { return }
        if !selected.contains(track) { selected.append(track) }
        query = ""
    }

    func remove(_ track: Track) {
        if let idx = selected.firstIndex(of: track) { selected.remove(at: idx) }
    }

    func startsWithPrefix(_ text: String, _ q: String) -> Bool {
        let t = text.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        let p = q.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        return t.hasPrefix(p)
    }
}

//Cards
struct TrackCardResult: View {
    let track: Track
    let imageName: String?
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AlbumArtView(imageName: imageName)
            VStack(alignment: .leading, spacing: 2) {
                Text(track.title)
                    .foregroundColor(.white)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text(track.artist)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.footnote)
                    .lineLimit(1)
            }
            Spacer()
            Button(action: onAdd) {
                Text("Add")
                    .font(.footnote.weight(.semibold))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.white.opacity(0.18))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .foregroundColor(.white)
        }
        .padding(12)
        .background(Color.white.opacity(0.10))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.28), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct TrackCardSelected: View {
    let track: Track
    let imageName: String?
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AlbumArtView(imageName: imageName)
            VStack(alignment: .leading, spacing: 2) {
                Text(track.title)
                    .foregroundColor(.white)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text(track.artist)
                    .foregroundColor(.white.opacity(0.8))
                    .font(.footnote)
                    .lineLimit(1)
            }
            Spacer()
            Button(action: onRemove) {
                Text("Remove")
                    .font(.footnote.weight(.semibold))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.white.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .foregroundColor(.white)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.20), lineWidth: 1)
        )
    }
}

struct AlbumArtView: View {
    let imageName: String?

    var body: some View {
        if let name = imageName {
            Image(name)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.28), lineWidth: 1)
                )
        }
    }
}

//Onboarding: Page 4
struct VibesView: View {
    @State var selected: String?

    let vibes = [
        "Calm", "Energetic", "Melancholy", "Adventurous",
        "Romantic", "Chill", "Focused", "Upbeat",
        "Dreamy", "Cinematic", "Nostalgic", "Groovy"
    ]

    var isValid: Bool { selected != nil }

    var body: some View {
        ZStack {
            BlobBackground()

            VStack(spacing: 24) {
                Spacer(minLength: 24)

                Text("What feels the most like you right now?")
                    .font(.title).bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)

                Text("Choose 1 to continue")
                    .foregroundColor(.white.opacity(0.80))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)

                //Grid
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 120), spacing: 12)],
                        spacing: 12
                    ) {
                        ForEach(vibes, id: \.self) { v in
                            VibeChip(
                                label: v,
                                isSelected: selected == v
                            ) {
                                if selected == v { selected = nil } else { selected = v }
                            }
                        }
                    }
                    .padding(.horizontal, 32) // 32-pt rail
                }

                //Footnote + Continue
                Text(selected.map { "Selected: \($0)" } ?? "Nothing selected")
                    .foregroundColor(.white.opacity(0.80))
                    .font(.subheadline)

                NavigationLink {
                    ArchetypeFlowRoot()
                } label: {
                    HStack(spacing: 8) {
                        Text("Continue").font(.headline)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.white.opacity(0), lineWidth: 1)
                            .allowsHitTesting(false)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.24), radius: 16, x: 0, y: 6)
                }
                .opacity(isValid ? 1 : 0.6)
                .disabled(!isValid)

                Spacer(minLength: 24)
            }
            .padding(.top, 8)
        }
    }
}

//Rounded chip
struct VibeChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.white.opacity(0.24) : Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color.white.opacity(0.88) : Color.white.opacity(0.80), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

//Archetype
struct ArchetypeFlowRoot: View {
    @State var showReveal = false

    var body: some View {
        ZStack {   // CHANGED: Removed inner NavigationStack
            ArchetypeLoadingView {
                withAnimation { showReveal = true }
            }

            NavigationLink("", isActive: $showReveal) {
                ArchetypeRevealView()
                    .navigationTitle("Your archetype")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .opacity(0)
        }
    }
}

struct ArchetypeLoadingView: View {
    var onFinish: () -> Void
    @State var dotCount = 0

    var body: some View {
        ZStack {
            BlobBackground()

            VStack(spacing: 24) {
                Spacer(minLength: 60)

                Text("Finding your archetype")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Text("Analyzing your picks" + String(repeating: ".", count: dotCount))
                    .foregroundColor(.white.opacity(0.80))
                    .font(.subheadline)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 0.45, repeats: true) { _ in
                            dotCount = (dotCount + 1) % 4
                        }
                    }

                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.2)

                Spacer()
            }
            .padding(.top, 8)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation { onFinish() }
            }
        }
    }
}

struct ArchetypeRevealView: View {
    let videoName = "jess-butterfly"
    let archetypeTitle = "The Dreamy Romantic"
    let descriptionText =
    "Your taste carries a dreamy glow. Every song you love feels like it belongs to a memory."

    var body: some View {
        ZStack {
            BlobBackground()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 64)

                    LoopingVideo(resourceName: videoName, size: 260)

                    Text(archetypeTitle)
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                    Text(descriptionText)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.88))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 6)

                }
                .padding(.horizontal, 48)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LoopingVideo: View {
    let resourceName: String
    let ext: String = "mp4"
    let size: CGFloat

    @State var player: AVQueuePlayer?
    @State var looper: AVPlayerLooper?

    var body: some View {
        VideoPlayer(player: player)
            .disabled(true)
            .aspectRatio(1, contentMode: .fit)
            .frame(width: size, height: size)
            .background(Color.black.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.22), lineWidth: 1)
            )
            .onAppear(perform: setup)
            .onDisappear {
                player?.pause()
                player?.removeAllItems()
                player = nil
                looper = nil
            }
    }

    func setup() {
        guard player == nil else { return }

        guard let url = Bundle.main.url(forResource: resourceName, withExtension: ext) else {
            print("⚠️ Video not found in bundle: \(resourceName).\(ext)")
            return
        }

        let item = AVPlayerItem(url: url)
        let queue = AVQueuePlayer()
        queue.isMuted = true
        queue.allowsExternalPlayback = false
        queue.automaticallyWaitsToMinimizeStalling = true

        let loop = AVPlayerLooper(player: queue, templateItem: item)

        queue.replaceCurrentItem(with: item)
        queue.play()

        self.player = queue
        self.looper = loop
    }
}

#Preview {
    ContentView()
}
