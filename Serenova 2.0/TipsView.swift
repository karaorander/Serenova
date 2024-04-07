//
//  TipsView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 04/05/24
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Section for Videos
                    NavigationLink(destination: VideosListView()) {
                        HomeSectionView(title: "Sleep Videos", subtitle: "Watch and learn about sleep")
                    }
                    
                    // Section for Tips
                    NavigationLink(destination: TipsListView()) {
                        HomeSectionView(title: "Sleep Hygiene Tips", subtitle: "Improve your sleep quality")
                    }
                    
                    // Section for Articles
                    NavigationLink(destination: ArticlesListView()) {
                        HomeSectionView(title: "Science of Sleep", subtitle: "Deep dive into sleep studies")
                    }
                }
                .padding()
            }
            .navigationTitle("Sleep Well")
        }
    }
}

struct HomeSectionView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct VideosListView: View {
    var body: some View {
        List {
            // Example Video Item
            VideoListItemView(videoTitle: "The Importance of REM Sleep", videoDescription: "Explore the role of REM in sleep.")
            // More video items...
        }
        .navigationTitle("Sleep Videos")
    }
}

struct VideoListItemView: View {
    var videoTitle: String
    var videoDescription: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(videoTitle)
                .font(.headline)
            Text(videoDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// Placeholder Views for Tips and Articles List
struct TipsListView: View {
    var body: some View {
        Text("Tips List")
    }
}

struct ArticlesListView: View {
    var body: some View {
        Text("Articles List")
    }
}

// SwiftUI Preview Providers
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct VideosListView_Previews: PreviewProvider {
    static var previews: some View {
        VideosListView()
    }
}
