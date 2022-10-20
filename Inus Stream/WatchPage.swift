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
    
    func getCurrentItem() -> AVPlayerItem? {
        return player.currentItem
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
    @State var showUI: Bool
    
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
    var episodeData: StreamData?
    let animeData: InfoData
    @State var qualityIndex: Int
    @Binding var showUI: Bool
    @State var episodeIndex: Int
    @ObservedObject var playerVM: PlayerViewModel
    @State var progress = 0.25
    @State var showEpisodeSelector: Bool = false
    @StateObject var streamApi = StreamApi()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    func secondsToMinutesSeconds(_ seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        let minuteString = (minutes < 10 ? "0" : "") +  "\(minutes)"
        let secondsString = (seconds < 10 ? "0" : "") +  "\(seconds)"
        
        return minuteString + ":" + secondsString
    }
    
    
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 0),
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), location: 0.5),
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 1)]),
                    startPoint: UnitPoint(x: 0, y: 0),
                    endPoint: UnitPoint(x: 0, y: 1)))
                .frame(width: .infinity, height: .infinity)
            Color.clear
                .frame(width: .infinity, height: 300)
                .contentShape(Rectangle())
                .onTapGesture {
                    showUI = false
                }
            
            VStack {
                Spacer()
                    .frame(maxHeight: 12)
                HStack {
                    // self.presentationMode.wrappedValue.dismiss()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundColor(.white)
                    })
                    
                    Spacer()
                    VStack {
                        HStack {
                            Text("\(animeData.title.english ?? animeData.title.romaji) -")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .bold()
                            Text("EP: \(animeData.episodes![episodeIndex].number)")
                                .foregroundColor(Color(hex: "#ff999999"))
                                .font(.system(size: 16))
                                .bold()
                                .padding(.leading, -3)
                        }
                        Text("\(animeData.episodes![episodeIndex].title ?? "")")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .bold()
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    if(episodeData != nil) {
                        ZStack {
                            Color(hex: "#ff1E222C")
                                .cornerRadius(12)
                            
                            VStack(alignment: .center, spacing: 8) {
                                ForEach(0..<(episodeData!.sources!.count - 1)) { index in
                                    ZStack {
                                        if(index == qualityIndex) {
                                            Color(hex: "#ff464E6C")
                                        }
                                        
                                        Text("\(episodeData!.sources![index].quality!)")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                            .bold()
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                    }
                                    .frame(maxWidth: 90)
                                    .cornerRadius(8)
                                    .onTapGesture(perform: {
                                        Task {
                                            let curTime = playerVM.currentTime
                                            self.qualityIndex = index
                                            await self.streamApi.loadStream(id: self.animeData.episodes![episodeIndex].id)
                                            playerVM.setCurrentItem(AVPlayerItem(url: URL(string:  self.streamApi.streamdata?.sources![self.qualityIndex].url ?? "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!))
                                            await playerVM.player.seek(to: CMTime(seconds: curTime, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                                            playerVM.player.play()
                                        }
                                        
                                    })
                                    
                                }
                                
                            }
                            .padding(8)
                            .cornerRadius(12)
                        }
                        .frame(maxWidth: 106)
                        .cornerRadius(12)
                        .clipped()
                    }
                    
                    
                    Spacer()
                    Image("goBackward")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white.opacity(0.6))
                        .onTapGesture {
                            playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime - 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                            
                        }
                    
                    Spacer().frame(maxWidth: 72)
                    
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
                    Spacer().frame(maxWidth: 72)
                    Image("goForward")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                        .onTapGesture {
                            playerVM.player.seek(to: CMTime(seconds: playerVM.currentTime + 15, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                        }
                    Spacer()
                    Spacer()
                        .frame(maxWidth: 106)
                }
                .padding(.top, 20)
                Spacer()
                HStack {
                    if let duration = playerVM.duration {
                        HStack {
                            CustomView(percentage: $playerVM.currentTime, isDragging: $playerVM.isEditingCurrentTime, total: playerVM.duration!)
                                .frame(height: 6)
                                .frame(maxHeight: 20)
                                .padding(.bottom, playerVM.isEditingCurrentTime ? 3 : 0 )
                            
                            Spacer().frame(maxWidth: 34)
                            
                            Text("\(secondsToMinutesSeconds(Int(playerVM.currentTime))) / \(secondsToMinutesSeconds(Int(playerVM.duration!)))")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.white)
                            
                            Spacer()
                                .frame(maxWidth: 34)
                            
                            FontIcon.button(.awesome5Solid(code: .closed_captioning), action: {
                                print("subtitles")
                            }, fontsize: 20)
                            .foregroundColor(.white)
                            
                            Spacer()
                                .frame(maxWidth: 34)
                            
                            Image("episodeSelector")
                                .resizable()
                                .frame(width: 24, height: 19)
                                .foregroundColor(.white.opacity(0.7))
                                .onTapGesture {
                                    showEpisodeSelector = true
                                }
                            
                            
                            Spacer()
                                .frame(maxWidth: 34)
                            
                            FontIcon.button(.awesome5Solid(code: .step_forward), action: {
                                Task {
                                    self.episodeIndex = self.episodeIndex + 1
                                    await self.streamApi.loadStream(id: self.animeData.episodes![episodeIndex].id)
                                    playerVM.setCurrentItem(AVPlayerItem(url: URL(string:  self.streamApi.streamdata?.sources![0].url ?? "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!))
                                    playerVM.player.play()
                                }
                                
                            }, fontsize: 20)
                            .foregroundColor(.white)
                        }
                    } else {
                        Spacer()
                    }
                }
                .padding()
            }
            
            
            ZStack(alignment: .trailing) {
                Color(.black.withAlphaComponent(0.6))
                    .onTapGesture {
                        showEpisodeSelector = false
                    }
                VStack {
                    
                    Spacer()
                    
                    ZStack {
                        Color(hex: "#ff16151A")
                            .ignoresSafeArea()
                        VStack(alignment: .leading) {
                            Text("Select Episode")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    ForEach((episodeIndex+1)..<animeData.episodes!.count) { index in
                                        ZStack {
                                            AsyncImage(url: URL(string: animeData.episodes![index].image)) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 160, height: 90)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            
                                            VStack(alignment: .trailing) {
                                                Text("\(animeData.episodes![index].number)")
                                                    .bold()
                                                    .font(.headline)
                                                    .bold()
                                                    .foregroundColor(.white)
                                                    .padding()
                                                
                                                Spacer()
                                                
                                                ZStack(alignment: .center) {
                                                    Color(.black)
                                                    
                                                    Text("\(animeData.episodes![index].title ?? "Episode \(animeData.episodes![index].number)")")
                                                        .font(.caption2)
                                                        .bold()
                                                        .lineLimit(2)
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal, 4)
                                                }
                                                .frame(width: 160, height: 50)
                                            }
                                        }
                                        .frame(width: 160, height: 90)
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            Task {
                                                self.episodeIndex = self.episodeIndex  + index - 1
                                                await self.streamApi.loadStream(id: self.animeData.episodes![episodeIndex].id)
                                                playerVM.setCurrentItem(AVPlayerItem(url: URL(string:  self.streamApi.streamdata?.sources![0].url ?? "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!))
                                                playerVM.player.play()
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(width: 440, height: 160)
                    .cornerRadius(20)
                    .padding(.bottom, 60)
                }
                .frame(maxHeight: .infinity)
            }
            .opacity(showEpisodeSelector ? 1.0 : 0.0)
            .animation(.spring(response: 0.3), value: showEpisodeSelector)
        }
        .opacity(showUI ? 1.0 : 0.0)
        .animation(.spring(response: 0.3), value: showUI)
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
    let headers: header?
    let sources: [source]?
}

struct header: Codable {
    let Referer: String
}

struct source: Codable {
    let url: String
    let isM3U8: Bool
    let quality: String?
}

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.white
    var strokeWidth = 12.0
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}


struct CustomPlayerWithControls: View {
    var animeData: InfoData?
    var episodeIndex: Int
    @StateObject var streamApi = StreamApi()
    @State var doneLoading = false
    @State var showUI: Bool = true
    @State var episodeData: StreamData? = nil
    @State var resIndex: Int = 0
    
    @StateObject private var playerVM = PlayerViewModel()
    @Environment(\.managedObjectContext) var storage
    @FetchRequest(sortDescriptors: []) var animeStorageData: FetchedResults<AnimeStorageData>
    
    init(animeData: InfoData?, episodeIndex: Int) {
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
        if animeData != nil {
            if #available(iOS 16.0, *) {
            ZStack {
                Color(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .ignoresSafeArea(.all)
                    .persistentSystemOverlays(.hidden)
                    VStack {
                        VStack {
                            ZStack {
                                CustomVideoPlayer(playerVM: playerVM, showUI: showUI).onTapGesture {
                                    showUI = true
                                }
                                .overlay(CustomControlsView(episodeData: episodeData,animeData: animeData!, qualityIndex: resIndex, showUI: $showUI, episodeIndex: episodeIndex, playerVM: playerVM)
                                         , alignment: .bottom)
                            }
                            .padding(.horizontal, 60)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .edgesIgnoringSafeArea(.all)
                            .ignoresSafeArea(.all)
                            .persistentSystemOverlays(.hidden)
                        }
                    }
                    .task {
                        await self.streamApi.loadStream(id: self.animeData!.episodes![episodeIndex].id)
                        
                        episodeData = streamApi.streamdata!
                        
                        // get 1080p res
                        
                        for i in 0..<streamApi.streamdata!.sources!.count {
                            if (self.streamApi.streamdata!.sources![i].quality! == "1080p")
                            {
                                resIndex = i
                            }
                        }
                        
                        print(episodeData)
                        
                        playerVM.setCurrentItem(AVPlayerItem(url:  URL(string: self.streamApi.streamdata?.sources![resIndex].url ?? "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!))
                        
                        let index = animeStorageData.firstIndex(where: {($0.id!) == animeData!.id})
                        if(index != nil && animeStorageData[index!].watched != nil && animeStorageData[index!].currentTime != nil && animeStorageData[index!].episodeNumber == episodeIndex + 1) {
                            await playerVM.player.seek(to: CMTime(seconds: animeStorageData[index!].currentTime, preferredTimescale: 1))
                        }
                        
                        playerVM.player.play()
                    }
                    .onDisappear {
                        playerVM.player.pause()
                        
                        
                        let index = animeStorageData.firstIndex(where: {($0.id!) == animeData!.id})
                        if(index != nil && animeStorageData[index!].watched != nil) {
                            animeStorageData[index!].watched!.append(animeData!.episodes![episodeIndex].number)
                            animeStorageData[index!].episodeThumbnail = animeData!.episodes![(animeStorageData[index!].watched!.max() ?? 1) - 1].image
                            animeStorageData[index!].episodeProgress = 0.5
                            animeStorageData[index!].currentTime = playerVM.currentTime
                            animeStorageData[index!].duration = playerVM.duration ?? (24.0 * 60.0)
                            animeStorageData[index!].animeTitle = animeData!.title.english ?? animeData!.title.romaji
                            animeStorageData[index!].episodeNumber = Int16(animeData!.episodes![episodeIndex].number)
                        } else {
                            let storageDataTemp = AnimeStorageData(context: storage)
                            storageDataTemp.id = animeData!.id
                            storageDataTemp.watched = [animeData!.episodes![episodeIndex].number]
                            storageDataTemp.episodeProgress = 0.5
                            storageDataTemp.episodeThumbnail = animeData!.episodes![episodeIndex].image
                            storageDataTemp.currentTime = playerVM.currentTime
                            storageDataTemp.duration = playerVM.duration!
                            storageDataTemp.animeTitle = animeData!.title.english ?? animeData!.title.romaji
                            storageDataTemp.episodeNumber = Int16(animeData!.episodes![episodeIndex].number)
                        }
                        
                        
                        try? storage.save()
                        
                        
                        playerVM.player.replaceCurrentItem(with: nil)
                    }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .ignoresSafeArea(.all)
            .persistentSystemOverlays(.hidden)
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(GaugeProgressStyle())
            }
        }
    }
}

struct Loading: View {
    var body: some View {
        ZStack {
            ProgressView()
        }
    }
}


struct WatchPage: View {
    var animeData: InfoData?
    let episodeIndex: Int
    let anilistId: String?
    @Environment(\.presentationMode) var presentation
    @StateObject var infoApi = InfoApi()
    @State private var isPresented = false
    
    init(aniData: InfoData?, episodeIndex: Int, anilistId: String?) {
        animeData = aniData
        self.episodeIndex = episodeIndex
        self.anilistId = anilistId
    }
    
    var body: some View {
        if #available(iOS 16, *) {
            
            return ZStack {
                CustomPlayerWithControls(animeData: animeData, episodeIndex: episodeIndex)
                    .navigationBarBackButtonHidden(true)
                    .contentShape(Rectangle())
                    .ignoresSafeArea(.all)
                    .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .edgesIgnoringSafeArea(.all)
            .supportedOrientation(.landscape)
            .prefersHomeIndicatorAutoHidden(true)
        } else {
            return CustomPlayerWithControls(animeData: animeData!, episodeIndex: episodeIndex)
                .navigationBarBackButtonHidden(true)
                .contentShape(Rectangle())
                .ignoresSafeArea(.all)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                .onAppear() {
                    print("VIEWWWWW")
                }
        }
        
        
    }
}

struct WatchPage_Previews: PreviewProvider {
    static var previews: some View {
        WatchPage(aniData: InfoData(id: "98659",
                                    title: Title(
                                      romaji: "Youkoso Jitsuryoku Shijou Shugi no Kyoushitsu e",
                                      native: "ようこそ実力至上主義の教室へ",
                                      english: "Classroom of the Elite"
                                    ),
                                    malId: 35507,
                                    synonyms: [
                                      "Youjitsu",
                                      "You-Zitsu",
                                      "ขอต้อนรับสู่ห้องเรียนนิยม (เฉพาะ) ยอดคน",
                                      "Cote",
                                      "歡迎來到實力至上主義的教室"
                                    ],
                                    isLicensed: true,
                                    isAdult: false,
                                    countryOfOrigin: "JP",
                                    trailer: nil,
                                    image: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/b98659-sH5z5RfMuyMr.png",
                                    popularity: 224139,
                                    color: "#43a135",
                                    cover: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/98659-u46B5RCNl9il.jpg",
                                    description: "Koudo Ikusei Senior High School is a leading school with state-of-the-art facilities. The students there have the freedom to wear any hairstyle and bring any personal effects they desire. Koudo Ikusei is like a utopia, but the truth is that only the most superior students receive favorable treatment.<br><br>\n\nKiyotaka Ayanokouji is a student of D-class, which is where the school dumps its \"inferior\" students in order to ridicule them. For a certain reason, Kiyotaka was careless on his entrance examination, and was put in D-class. After meeting Suzune Horikita and Kikyou Kushida, two other students in his class, Kiyotaka's situation begins to change. <br><br>\n(Source: Anime News Network, edited)",
                                    status: "Completed",
                                    releaseDate: 2017,
                                    startDate: EndDateClass(
                                      year: 2017,
                                      month: 7,
                                      day: 12
                                    ),
                                    endDate: EndDateClass(
                                      year: 2017,
                                      month: 9,
                                      day: 27
                                    ),
                                    nextAiringEpisode: nil,
                                    totalEpisodes: 12,
                                    duration: 24,
                                    rating: 77,
                                    genres: [
                                      "Drama",
                                      "Psychological"
                                    ],
                                    season: "SUMMER",
                                    studios: [
                                      "Lerche"
                                    ],
                                    subOrDub: "sub",
                                    type: "TV",
                                    recommendations: nil,
                                    characters: [],
                                    relations: nil,
                                    episodes: [
                                        Episode(id: "classroom-of-the-elite-713$episode$12865",
                                                title: "What is evil? Whatever springs from weakness.",
                                                description: "Kiyotaka Ayanokoji begins attending school in class 1-D at the Tokyo Metropolitan Advanced Nurturing High School, an institution established by the government for training Japan's best students. Class D homeroom teacher Sae Chabashira explains the point system where everybody gets a monthly allowance 100,000 points that they can use as money at local shops with one point equaling one yen, and also warns the students that they are judged on merit. Ayanokoji begins navigating through the system being careful about how he spends his points, while becoming friends with the gregarious Kikyo Kushida and then attempting to become friends with the aloof outsider Suzune Horikita. In an attempt to become friends, Ayanokoji brings Suzune to a cafe where only girls meet having secretly arranged for Kushida and two other classmates to be there, but Suzune saw through the plan and leaves without becoming friends. As the month of April passes, the majority of class D lavishly spends their points and slacks off in class without any reprimand, causing Ayanokoji to be suspicious. On May 1, the class D students are surprised to find out that they did not get an allowance, and Chabashira explains that their allowance depends on merit and having ignored their studies, the class receives no points for the month.",
                                                number: 1,
                                                image: "https://artworks.thetvdb.com/banners/episodes/329822/6125438.jpg", isFiller: false
                                              )
                                    ]
                                   ), episodeIndex: 0, anilistId: "98659")
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
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: geometry.size.width * CGFloat(self.percentage / total)).frame(height: barHeight, alignment: .bottom).cornerRadius(12)
                
                
            }.frame(maxHeight: .infinity, alignment: .center)
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
