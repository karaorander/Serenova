//
//  TipsView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 04/05/24
//

import SwiftUI
import SafariServices

struct WebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct VideoLinkView: View {
    var videoURL: URL
    @State private var isPresentingWebView = false // State to control the presentation of the WebView

    var body: some View {
        VStack {
            // Placeholder for video thumbnail
            Image(systemName: "film") // Replace "sleep_image" with the name of your sleep-related image asset
                .resizable()
                .aspectRatio(16/9, contentMode: .fit)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            Button(action: {
                isPresentingWebView = true // Set this to true to present the WebView
            }) {
                Text("Watch Video")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue.opacity(0.85))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .frame(width: 300) // Set a fixed width for uniformity
        .sheet(isPresented: $isPresentingWebView) {
            WebView(url: videoURL) // Present the WebView when isPresentingWebView is true
        }
    }
}

struct TipsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(spacing: 30) {
                            Text("Sleep Well")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            
                            SectionHeaderView(title: "Sleep Videos")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    VideoLinkView(videoURL: URL(string: "https://www.youtube.com/watch?v=t0kACis_dJE")!)
                                    VideoLinkView(videoURL: URL(string: "https://www.youtube.com/watch?v=ZKNQ6gsW45M")!)
                                }
                            }
                            .frame(height: 250) // Increase height to accommodate the video links better
                            
                            SectionHeaderView(title: "Sleep Hygiene Tips")
                            ForEach(0..<3) { _ in // Replace with actual data
                                ExpandableTipView(tipTitle: "Maintain a Sleep Schedule",
                                                                     tipDescription: "Sticking to a consistent sleep schedule helps regulate your body's clock.",
                                                                     detailedSteps: ["Decide on a fixed bedtime and wake-up time.",
                                                                                     "Avoid sleeping in, even on weekends.",
                                                                                     "Nap to make up for lost sleep, but not too late in the day."])

                            }
                            
                            SectionHeaderView(title: "Science of Sleep")
                            ForEach(0..<3) { _ in // Replace with actual data
                                ArticleCardView(articleTitle: "The Role of REM Sleep", articleDescription: "Explore the importance of REM sleep in learning and memory.")
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarHidden(true) // Hide the navigation bar for a cleaner look
    }
}

struct SectionHeaderView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ExpandableTipView: View {
    var tipTitle: String
    var tipDescription: String
    var detailedSteps: [String]
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(tipTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.5))
            .cornerRadius(10)

            if isExpanded {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(detailedSteps.indices, id: \.self) { index in
                        Text("Step \(index + 1): \(detailedSteps[index])")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                            .padding(.top, 5)
                    }
                }
                .padding(.bottom, 10)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(10)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1) // Ensure this layer is above the button when animating
            }
        }
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

struct TipsCardView: View {
    var tipTitle: String
    var tipDescription: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(tipTitle)
                .font(.headline)
                .foregroundColor(.white)
            Text(tipDescription)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.blue.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ArticleCardView: View {
    var articleTitle: String
    var articleDescription: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(articleTitle)
                .font(.headline)
                .foregroundColor(.white)
            Text(articleDescription)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.purple.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// SwiftUI Preview Provider

#Preview {
    TipsView()
}
