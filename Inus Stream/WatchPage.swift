//
//  WatchPage.swift
//  Inus Stream
//
//  Created by Inumaki on 26.09.22.
//

import SwiftUI
import AVKit
import UIKit
import SwiftUIFontIcon

import Combine

final class PlayerViewModel: ObservableObject {
    let player = AVPlayer()
    @Published var isInPipMode: Bool = false
    @Published var isPlaying = false
    
    @Published var isEditingCurrentTime = false
    @Published var currentTime: Double = .zero
    @Published var buffered: Double = .zero
    @Published var duration: Double?
    
    private var subscriptions: Set<AnyCancellable> = []
    private var timeObserver: Any?
    
    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }
    
    init() {
        $isEditingCurrentTime
            .dropFirst()
            .filter({ $0 == false })
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.player.seek(to: CMTime(seconds: self.currentTime, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                if self.player.rate != 0 {
                    self.player.play()
                }
            })
            .store(in: &subscriptions)
        
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if self.isEditingCurrentTime == false {
                self.currentTime = time.seconds
            }
        }
    }
    
    func setCurrentItem(_ item: AVPlayerItem) {
        currentTime = .zero
        duration = nil
        player.replaceCurrentItem(with: item)
        
        item.publisher(for: \.status)
            .filter({ $0 == .readyToPlay })
            .sink(receiveValue: { [weak self] _ in
                self?.duration = item.asset.duration.seconds
            })
            .store(in: &subscriptions)
    }
}


class PlayerView: UIView {
    
    // Override the property to make AVPlayerLayer the view's backing layer.
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    // The associated player object.
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
}


struct CustomVideoPlayer: UIViewRepresentable {
    @ObservedObject var playerVM: PlayerViewModel
    
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.player = playerVM.player
        context.coordinator.setController(view.playerLayer)
        return view
    }
    
    func updateUIView(_ uiView: PlayerView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, AVPictureInPictureControllerDelegate {
        private let parent: CustomVideoPlayer
        private var controller: AVPictureInPictureController?
        private var cancellable: AnyCancellable?
        
        init(_ parent: CustomVideoPlayer) {
            self.parent = parent
            super.init()
            
            cancellable = parent.playerVM.$isInPipMode
                .sink { [weak self] in
                    guard let self = self,
                          let controller = self.controller else { return }
                    if $0 {
                        if controller.isPictureInPictureActive == false {
                            controller.startPictureInPicture()
                        }
                    } else if controller.isPictureInPictureActive {
                        controller.stopPictureInPicture()
                    }
                }
        }
        
        func setController(_ playerLayer: AVPlayerLayer) {
            controller = AVPictureInPictureController(playerLayer: playerLayer)
            controller?.canStartPictureInPictureAutomaticallyFromInline = true
            controller?.delegate = self
        }
        
        func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = true
        }
        
        func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
            parent.playerVM.isInPipMode = false
        }
    }
}

struct Media: Identifiable {
    let id = UUID()
    let title: String
    let url: String
    
    var asPlayerItem: AVPlayerItem {
        AVPlayerItem(url: URL(string: url)!)
    }
}

struct UISliderView: UIViewRepresentable {
    @Binding var value: Double
    
    var minValue = 1.0
    var maxValue = 100.0
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor = .blue
    var maxTrackColor: UIColor = .lightGray
    
    class Coordinator: NSObject {
        var value: Binding<Double>
        
        init(value: Binding<Double>) {
            self.value = value
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            self.value.wrappedValue = Double(sender.value)
        }
    }
    
    func makeCoordinator() -> UISliderView.Coordinator {
        Coordinator(value: $value)
    }
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.minimumValue = Float(minValue)
        slider.maximumValue = Float(maxValue)
        slider.value = Float(value)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }
}

struct CustomControlsView: View {
    let animeData: InfoData
    let episodeIndex: Int
    @ObservedObject var playerVM: PlayerViewModel
    @State var progress = 0.25
    
    func secondsToMinutesSeconds(_ seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        let minuteString = (minutes < 10 ? "0" : "") +  "\(minutes)"
        let secondsString = (seconds < 10 ? "0" : "") +  "\(seconds)"
        
        return minuteString + ":" + secondsString
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 0),
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), location: 0.5),
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 1)]),
                    startPoint: UnitPoint(x: 0, y: 0),
                    endPoint: UnitPoint(x: 0, y: 1)))
                .frame(width: .infinity, height: .infinity)
            
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        HStack {
                            Text("\(animeData.title.english ?? animeData.title.romaji) -")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .bold()
                            Text("EP: \(animeData.episodes[episodeIndex].number)")
                                .foregroundColor(Color(hex: "#ff999999"))
                                .font(.system(size: 16))
                                .bold()
                                .padding(.leading, -3)
                        }
                        Text("\(animeData.episodes[episodeIndex].title ?? "")")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Button(action: {
                        playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime - 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                    }, label: {
                        Image(systemName: "gobackward")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(.white.opacity(0.7))
                    })
                    
                    Spacer().frame(maxWidth: 30)
                    
                    if playerVM.isPlaying == false {
                        FontIcon.button(.awesome5Solid(code: .play), action: {
                            
                            playerVM.player.play()
                        }, fontsize: 42)
                        .foregroundColor(.white)
                    } else {
                        FontIcon.button(.awesome5Solid(code: .pause), action: {
                            playerVM.player.pause()
                        }, fontsize: 42)
                        .foregroundColor(.white)
                    }
                    Spacer().frame(maxWidth: 30)
                    Image(systemName: "goforward")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.white.opacity(0.7))
                        .onTapGesture {
                                playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime + 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                        }
                }
                .padding(.top, 20)
                Spacer()
                HStack {
                    if let duration = playerVM.duration {
                        HStack {
                            CustomView(percentage: $playerVM.currentTime, isDragging: $playerVM.isEditingCurrentTime, total: playerVM.duration!)
                                .frame(height: 6)
                                .frame(maxHeight: 10)
                                .padding(.bottom, playerVM.isEditingCurrentTime ? 3 : 0 )
                            
                            Spacer().frame(maxWidth: 30)
                            
                            Text("\(secondsToMinutesSeconds(Int(playerVM.currentTime))) / \(secondsToMinutesSeconds(Int(playerVM.duration!)))")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                            
                            Spacer()
                                .frame(maxWidth: 20)
                            
                            FontIcon.button(.awesome5Solid(code: .closed_captioning), action: {
                                print("subtitles")
                            }, fontsize: 20)
                            .foregroundColor(.white)
                            
                            Spacer()
                                .frame(maxWidth: 20)
                            
                            FontIcon.button(.ionicon(code: .ios_settings), action: {
                                print("settings")
                            }, fontsize: 20)
                            .foregroundColor(.white)
                            
                            Spacer()
                                .frame(maxWidth: 20)
                            
                            FontIcon.button(.awesome5Solid(code: .step_forward), action: {
                                print("subtitles")
                            }, fontsize: 20)
                            .foregroundColor(.white)
                        }
                    } else {
                        Spacer()
                    }
                }
                .padding()
            }
        }
    }
}

class StreamApi : ObservableObject{
    @Published var streamdata: StreamData? = nil
    
    func loadStream(id: String) async {
        guard let url = URL(string: "https://api.consumet.org/meta/anilist/watch/\(id)") else {
            print("Invalid url...")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.streamdata = try! JSONDecoder().decode(StreamData.self, from: data)
        } catch {
            print("couldnt load data")
        }
        
    }
}

struct StreamData: Codable {
    let headers: header
    let sources: [source]
}

struct header: Codable {
    let Referer: String
}

struct source: Codable {
    let url: String
    let isM3U8: Bool
}


struct CustomPlayerWithControls: View {
    var animeData: InfoData
    var episodeIndex: Int
    @StateObject var streamApi = StreamApi()
    @State var doneLoading = false
    
    @StateObject private var playerVM = PlayerViewModel()
    
    init(animeData: InfoData, episodeIndex: Int) {
        self.animeData = animeData
        self.episodeIndex = episodeIndex
        
        // we need this to use Picture in Picture
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            VStack {
                VStack {
                    CustomVideoPlayer(playerVM: playerVM)
                        .overlay(CustomControlsView(animeData: animeData, episodeIndex: episodeIndex, playerVM: playerVM )
                                 , alignment: .bottom)
                    
                }
                .padding(.horizontal, 60)
            }
            .padding()
            .ignoresSafeArea()
            .task {
                await self.streamApi.loadStream(id: self.animeData.episodes[episodeIndex].id)
                
                playerVM.setCurrentItem(AVPlayerItem(url:  URL(string: self.streamApi.streamdata?.sources[0].url ?? "")!))
                playerVM.player.play()
                
            }
            .onDisappear {
                playerVM.player.pause()
            }
        }
    }
}



struct WatchPage: View {
    let animeData: InfoData?
    let episodeIndex: Int
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            CustomPlayerWithControls(animeData: animeData!, episodeIndex: episodeIndex)
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(
              leading: Button(action: { presentation.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                      .font(.system(size: 24, weight: .bold))
                  .foregroundColor(.white)
                  .imageScale(.large) })
            .contentShape(Rectangle()) // Start of the gesture to dismiss the navigation
            .gesture(
              DragGesture(coordinateSpace: .local)
                .onEnded { value in
                  if value.translation.width > .zero
                      && value.translation.height > -30
                      && value.translation.height < 30 {
                    presentation.wrappedValue.dismiss()
                  }
                }
            )
    }
}


struct CustomView: View {

    @Binding var percentage: Double // or some value binded
    @Binding var isDragging: Bool
    @State var barHeight: CGFloat = 6
    
    var total: Double

    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .bottomLeading) {
            
                Rectangle()
                    .foregroundColor(.white.opacity(0.5)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width * CGFloat(self.percentage / total)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
            }.frame(maxHeight: .infinity, alignment: .bottom)
            .cornerRadius(12)
            .gesture(DragGesture(minimumDistance: 0)
                .onEnded({ value in
                    self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                    self.isDragging = false
                    self.barHeight = 6
                })
                .onChanged({ value in
                    self.isDragging = true
                    self.barHeight = 10
                    print(value)
                    // TODO: - maybe use other logic here
                    self.percentage = min(max(0, Double(value.location.x / geometry.size.width * total)), total)
                })).animation(.spring(response: 0.3), value: self.isDragging)
            
        }
    }
}
