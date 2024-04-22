//
//  TipsView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 04/05/24
//

import SwiftUI
import SafariServices
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift

struct WebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

let tips = [
    Article(articleTitle: "Improve Your Sleep Environment", articleLink: "Get Some Deep Sleep Today", articlePreview: "Make your bedroom conducive to sleep by keeping it dark, quiet, and cool. Remove distractions and create a relaxing atmosphere to promote better sleep.", articleTags: ["insomnia"], articleId: "1"),
    Article(articleTitle: "Establish a Bedtime Routine", articleLink: "Get better sleep hygiene", articlePreview: "Create a consistent bedtime routine to signal to your body that it's time to wind down and sleep. Engage in calming activities such as reading or taking a warm bath before bed.", articleTags: ["insomnia"], articleId: "2"),
    Article(articleTitle: "Stay Active During the Day", articleLink: "N/A", articlePreview: "Incorporate regular physical activity into your daily routine to improve sleep quality and overall health. Aim for activities that you enjoy and are appropriate for your fitness level.", articleTags: ["old"], articleId: "3"),
    Article(articleTitle: "Limit Caffeine Intake", articleLink: "N/A", articlePreview: "Reduce caffeine consumption, especially in the afternoon and evening. Opt for decaffeinated beverages or herbal teas to prevent interference with sleep.", articleTags: ["old"], articleId: "4"),
    Article(articleTitle: "Establish a Consistent Sleep Schedule", articleLink: "N/A", articlePreview: "Set a regular bedtime and wake-up time for your child to help regulate their body clock and promote better sleep. Consistency is key for establishing healthy sleep habits.", articleTags: ["kid"], articleId: "5"),
    Article(articleTitle: "Create a Relaxing Bedtime Routine", articleLink: "N/A", articlePreview: "Develop a calming bedtime routine for your child by engaging in soothing activities such as reading a book, listening to soft music, or practicing relaxation exercises.", articleTags: ["kid"], articleId: "6"),
    Article(articleTitle: "Follow a Soothing Bedtime Ritual", articleLink: "N/A", articlePreview: "Establish a soothing bedtime routine for your baby to help them relax and prepare for sleep. Consider activities such as gentle rocking, swaddling, or singing lullabies.", articleTags: ["baby"], articleId: "7"),
    Article(articleTitle: "Use White Noise for Sleep", articleLink: "N/A", articlePreview: "Use white noise machines or apps to create a consistent and calming background sound that can help mask distracting noises and lull your baby to sleep.", articleTags: ["baby"], articleId: "8"),
    Article(articleTitle: "Practice Relaxation Techniques", articleLink: "N/A", articlePreview: "Engage in relaxation techniques such as deep breathing, meditation, or gentle yoga to reduce stress and promote relaxation before bedtime.", articleTags: ["female"], articleId: "9"),
    Article(articleTitle: "Prioritize Self-Care", articleLink: "N/A", articlePreview: "Take time for self-care activities that promote relaxation and well-being, such as taking a warm bath, practicing mindfulness, or indulging in a hobby you enjoy.", articleTags: ["female"], articleId: "10"),
    Article(articleTitle: "Prioritize Regular Exercise", articleLink: "N/A", articlePreview: "Engage in regular physical activity such as aerobic exercises, strength training, or sports to improve overall health and promote better sleep. Aim for at least 30 minutes of moderate exercise most days of the week, but avoid vigorous workouts close to bedtime as they may interfere with sleep.", articleTags: ["male"], articleId: "11"),
    Article(articleTitle: "Limit Caffeine and Alcohol Intake", articleLink: "N/A", articlePreview: "Reduce consumption of caffeinated beverages and alcohol, especially in the evening. Caffeine can interfere with sleep quality and disrupt the natural sleep-wake cycle, while alcohol may initially make you feel drowsy but can lead to fragmented sleep later in the night.", articleTags: ["male"], articleId: "12")
    // Add more articles as needed
] // ex: index = 0-4 insomnia articles (this is the backup plan)

struct Video {
    var title: String
    var url: URL
    var tags: [String]
}

let videos = [
    Video(title: "Sleep Meditation", url: URL(string: "https://www.youtube.com/watch?v=t0kACis_dJE")!, tags: ["male"]),
    Video(title: "Tips for Better Sleep", url: URL(string: "https://www.youtube.com/watch?v=ZKNQ6gsW45M")!, tags: ["female"]),
    Video(title: "Tips for Better Sleep", url: URL(string: "https://www.youtube.com/watch?v=j5Sl8LyI7k8")!, tags: ["insomnia"]),
    Video(title: "Tips for Better Sleep", url: URL(string: "https://www.youtube.com/watch?v=WVPtF7gr1jw")!, tags: ["insomnia"])
    // Add more videos as needed
]

class TipsViewModel: ObservableObject {
    @Published var fullname = ""
    @Published var totalSleepGoalHours : Float = -1
    @Published var totalSleepGoalMins : Float = -1
    @Published var deepSleepGoalHours : Float = -1
    @Published var deepSleepGoalMins : Float = -1
    @Published var moonCount : Int = -1
    @Published var age : Int = -1
    @Published var gender = ""
    @Published var weight : Float = -1
    @Published var snore : Bool = true
    @Published var hadinsomnia : Bool = true
    @Published var hasinsomnia : Bool = true
    @Published var hasmedication : Bool = true
    @Published var hasnightmares : Bool = true
    @Published var isearlybird : Bool = true
    
    
    
    func fetchMoons() {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
        
        ur.observe(.value) { snapshot,arg  in
            guard let userData = snapshot.value as? [String: Any] else {
                print("Error fetching data")
                return
            }
            
            // Extract additional information based on your data structure
            if let fullname = userData["name"] as? String {
                self.fullname = fullname
            }
            
            if let totalSleepGoalHours = userData["totalSleepGoalHours"] as? Float {
                self.totalSleepGoalHours = totalSleepGoalHours
                //currUser?.totalSleepGoalHours = totalSleepGoalHours
                
            }
            
            if let hasinsomnia = userData["hasInsomnia"] as? Bool {
                self.hasinsomnia = hasinsomnia
            }
            
            if let hadinsomnia = userData["hadInsomnia"] as? Bool {
                self.hadinsomnia = hadinsomnia
            }
            
            if let age = userData["age"] as? Int {
                self.age = age
            }
            
            if let gender = userData["gender"] as? String {
                self.gender = gender
            }
            
            if let weight = userData["weight"] as? Float {
                self.weight = weight
            }
            
            if let snore = userData["snore"] as? Bool {
                self.snore = snore
            }
            
            if let hasmedication = userData["hasmedication"] as? Bool {
                self.hasmedication = hasmedication
            }
            
            if let hasnightmares = userData["hasnightmares"] as? Bool {
                self.hasnightmares = hasnightmares
            }
            
            if let isearlybird = userData["isearlybird"] as? Bool {
                self.isearlybird = isearlybird
            }
        
        }
           /* self.objectWillChange.send()
                            
                            // Call the completion closure to indicate that data fetching is completed
                            completion()*/
    }
}

struct BreathingExercise {
    var title: String
    var url: URL
}

let breathingExercises = [
    BreathingExercise(title: "4-7-8 Breathing Technique", url: URL(string: "https://www.youtube.com/watch?v=YRPh_GaiL8s")!),
    BreathingExercise(title: "Box Breathing Exercise", url: URL(string: "https://www.youtube.com/watch?v=gz4G31LGyog")!)
    // Add more breathing exercises as needed
]

struct BreathingExerciseView: View {
    var breathingExercise: BreathingExercise
    
    var body: some View {
        VStack {
            // Placeholder for breathing exercise thumbnail
            Image(systemName: "waveform") // Replace with your own thumbnail image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 150) // Adjust size as needed
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom, 10)
            
            Button(action: {
                // Open the breathing exercise URL
                UIApplication.shared.open(breathingExercise.url)
            }) {
                Text(breathingExercise.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.dreamyTwilightAccentViolet.opacity(0.4)) // Customize button color
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
            .padding(.horizontal, 20)
        }
        .padding()
        .background(Color.dreamyTwilightAccentViolet.opacity(0.3)) // Change background color as desired
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

   // .nightfallHarmonyRoyalPurple.opacity(0.5), , .nightfallHarmonyNavyBlue

struct GuidedMeditation {
    var title: String
    var url: URL
}

let guidedMeditations = [
    GuidedMeditation(title: "Body Scan Meditation", url: URL(string: "https://www.youtube.com/watch?v=_v-OpjTUT18")!),
    GuidedMeditation(title: "Loving-Kindness Meditation", url: URL(string: "https://www.youtube.com/watch?v=sz7cpV7ERsM")!)
    // Add more guided meditations as needed
]

struct GuidedMeditationView: View {
    var guidedMeditation: GuidedMeditation
    
    var body: some View {
        VStack {
            // Placeholder for guided meditation thumbnail
            Image(systemName: "person.fill") // Replace with your own thumbnail image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 150) // Adjust size as needed
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom, 10)
            
            Button(action: {
                // Open the guided meditation URL
                UIApplication.shared.open(guidedMeditation.url)
            }) {
                Text(guidedMeditation.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.nightfallHarmonyNavyBlue.opacity(0.3)) // Customize button color
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
            .padding(.horizontal, 20)
        }
        .padding()
        .background(Color.nightfallHarmonyNavyBlue.opacity(0.2)) // Change background color as desired
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}


struct VideoLinkView: View {
    var videoURL: URL
    @State private var isPresentingWebView = false // State to control the presentation of the WebView

    var body: some View {
        VStack {
            // Placeholder for video thumbnail
            Image(systemName: "film") // Replace with your own video thumbnail image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 150) // Adjust size as needed
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom, 10)
            
            Button(action: {
                isPresentingWebView = true // Set this to true to present the WebView
            }) {
                Text("Watch Video")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
            .padding(.horizontal, 20)
        }
        .padding()
        .background(Color.nightfallHarmonyRoyalPurple.opacity(0.8)) // Change background color as desired
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
        .sheet(isPresented: $isPresentingWebView) {
            WebView(url: videoURL) // Present the WebView when isPresentingWebView is true
        }
    }
}
struct TipsView: View {
    @StateObject private var viewModel = TipsViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(spacing: 30) {
                            HStack {
                                NavigationLink(destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {
                                    
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.white)
                                    
                                }
                                Spacer()
                                Text("Sleep Tips")
                                    .font(Font.custom("NovaSquare-Bold", size: 50))
                                    .foregroundColor(Color.dreamyTwilightMidnightBlue)
                                    .fontWeight(.bold) // Ensure bold font weight
                                    .padding(.top, 20)
                                Spacer()
                            }
                            
                            Divider() // Add a line below the "Sleep Tips" text
                                .frame(height: 3)
                                .background(Color.dreamyTwilightMidnightBlue)
                            
                            SectionHeaderView(title: "Relevant Sleep Tips")
                                // Display relevant tips in a row
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(get_relevent_tips(), id: \.articleId) { (article: Article) in
                                        ArticleCardView(articleTitle: article.articleTitle, articleDescription: article.articlePreview)
                                            .frame(width: 200, height: 150) // Adjust the frame size as needed
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            SectionHeaderView(title: "Sleep Videos")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(get_relevant_video_urls(), id: \.self) { videoURL in
                                        VideoLinkView(videoURL: videoURL)
                                    }
                                }
                            }
                            .frame(height: 250) // Increase height to accommodate the video links better
                            
                            SectionHeaderView(title: "Detailed Tips")
                            ForEach(getSleepHygieneTips(), id: \.self) { tipView in
                                tipView
                            }
                            
                            SectionHeaderView(title: "Breathing Exercises")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(breathingExercises, id: \.title) { breathingExercise in
                                        BreathingExerciseView(breathingExercise: breathingExercise)
                                    }
                                }
                            }
                            .frame(height: 250)
                            
                            SectionHeaderView(title: "Guided Meditations")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(guidedMeditations, id: \.title) { guidedMeditation in
                                        GuidedMeditationView(guidedMeditation: guidedMeditation)
                                    }
                                }
                            }
                            .frame(height: 250)
                            Spacer()
                            Spacer()
                            
                        }
                        .padding(.horizontal)
                    }
                }
                .overlay(alignment: .bottom, content: {
                    
                   MenuView()
                    
                })
            }
        }
        .navigationBarHidden(true) // Hide the navigation bar for a cleaner look
        .onAppear {
            // Call get_relevent_tips function when the view appears
            viewModel.fetchMoons()
        }
    }
    
    func get_relevent_tips () -> Array<Article> {
        
        var releventArts = [Article]()
        
        var userTags = [String()]
        
        if (viewModel.hasinsomnia || viewModel.hadinsomnia) {
            print("insomn")
            userTags.append("insomnia")
        }
        
        let myAge = Int(viewModel.age) ?? -1
        
        if (myAge > 65) {
            print("old")
            userTags.append("old")
        }
        
        if (myAge <= 17 && myAge >= 5) {
            print("kid")
            userTags.append("kid")
        }
        
        if (myAge < 5 && myAge > -1) {
            print("baby")
            userTags.append("baby")
        }
        
        var gendervar = "female"
        
        if (viewModel.gender.lowercased() == gendervar) {
            print("female")
            userTags.append("female")
        }
        
        gendervar = "male"
        
        if (viewModel.gender.lowercased() == gendervar) {
            print("male")
            userTags.append("male")
        }
        
        if (viewModel.snore) {
            print("snore")
            userTags.append("snore")
        }
        
        if (viewModel.hasmedication) {
            print("meddy")
            userTags.append("meds")
        }
        
        if (viewModel.hasnightmares) {
            print("nightm")
            userTags.append("nightmares")
        }
        
        if (viewModel.isearlybird) {
            print("earlybird")
            userTags.append("earlybird")
        }
        
        
        
        for article in tips {
            for tag in article.articleTags {
                print("tag: \(article.articleTags)")
                if (userTags.contains(tag)) {
                    print("art \(article.articleTitle)")
                    releventArts.append(article)
                }
            }
        }
        
        //TODO: Add "read" tag to articles to keep track of if a user has already read an article
        
        if (releventArts.count == 0) {
            print("here")
            return articles
        }
        return releventArts
    } //end of get_relevent_articles
    
    func getSleepHygieneTips() -> [ExpandableTipView] {
        var sleepHygieneTips = [ExpandableTipView]()
        
        // Customize this logic based on user preferences
        if viewModel.hasinsomnia || viewModel.hadinsomnia {
            let insomniaTip = ExpandableTipView(tipTitle: "Manage Insomnia",
                                                tipDescription: "Effective strategies for managing insomnia.",
                                                detailedSteps: ["Practice relaxation techniques before bedtime.",
                                                                "Limit exposure to screens before sleep.",
                                                                "Create a calming bedtime routine."])
            sleepHygieneTips.append(insomniaTip)
        }
        
        let gender = viewModel.gender.lowercased()

        if gender == "male" {
            let maleTip = ExpandableTipView(tipTitle: "Male Sleep Tips",
                                            tipDescription: "Sleep tips tailored for men.",
                                            detailedSteps: ["Engage in regular physical activity.",
                                                            "Avoid heavy meals close to bedtime.",
                                                            "Create a comfortable sleep environment."])
            sleepHygieneTips.append(maleTip)
        } else if gender == "female" {
            let femaleTip = ExpandableTipView(tipTitle: "Female Sleep Tips",
                                              tipDescription: "Sleep tips tailored for women.",
                                              detailedSteps: ["Practice relaxation techniques.",
                                                              "Establish a consistent sleep schedule.",
                                                              "Limit caffeine intake, especially in the afternoon."])
            sleepHygieneTips.append(femaleTip)
        }

        if viewModel.age < 5 {
            let babyTip = ExpandableTipView(tipTitle: "Baby Sleep Tips",
                                            tipDescription: "Tips for improving your baby's sleep.",
                                            detailedSteps: ["Establish a soothing bedtime routine.",
                                                            "Create a sleep-friendly environment.",
                                                            "Watch for signs of tiredness."])
            sleepHygieneTips.append(babyTip)
        } else if viewModel.isearlybird {
            let earlyBirdTip = ExpandableTipView(tipTitle: "Early Bird Sleep Tips",
                                                  tipDescription: "Tips for optimizing sleep for early risers.",
                                                  detailedSteps: ["Go to bed and wake up at the same time every day, even on weekends.",
                                                                  "Get exposure to natural light in the morning.",
                                                                  "Limit caffeine intake in the afternoon and evening."])
            sleepHygieneTips.append(earlyBirdTip)
        }
        
        // Add more conditions based on user preferences
        
        return sleepHygieneTips
    }
    
    
    func get_relevant_video_urls() -> [URL] {
        var relevantURLs = [URL]()
        
        var userTags = [String()]
        
        if (viewModel.hasinsomnia || viewModel.hadinsomnia) {
            print("insomn")
            userTags.append("insomnia")
        }
        
        let myAge = Int(viewModel.age) ?? -1
        
        if (myAge > 65) {
            print("old")
            userTags.append("old")
        }
        
        if (myAge <= 17 && myAge >= 5) {
            print("kid")
            userTags.append("kid")
        }
        
        if (myAge < 5 && myAge > -1) {
            print("baby")
            userTags.append("baby")
        }
        
        var gendervar = "female"
        
        if (viewModel.gender.lowercased() == gendervar) {
            print("female")
            userTags.append("female")
        }
        
        gendervar = "male"
        
        if (viewModel.gender.lowercased() == gendervar) {
            print("male")
            userTags.append("male")
        }
        
        if (viewModel.snore) {
            print("snore")
            userTags.append("snore")
        }
        
        if (viewModel.hasmedication) {
            print("meddy")
            userTags.append("meds")
        }
        
        if (viewModel.hasnightmares) {
            print("nightm")
            userTags.append("nightmares")
        }
        
        if (viewModel.isearlybird) {
            print("earlybird")
            userTags.append("earlybird")
        }

        for video in videos {
            for tag in video.tags {
                if userTags.contains(tag) {
                    relevantURLs.append(video.url)
                    break // Once a relevant tag is found, no need to check other tags for this video
                }
            }
        }
        return relevantURLs
    }
}


struct SectionHeaderView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title) // Increase font size
            .fontWeight(.bold) // Optionally add bold font weight
            .foregroundColor(.white)
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .center) // Center alignment
    }
}
struct ExpandableTipView: View, Hashable {
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
    
    // Implementing Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(tipTitle)
        hasher.combine(tipDescription)
        hasher.combine(detailedSteps)
    }
    
    static func == (lhs: ExpandableTipView, rhs: ExpandableTipView) -> Bool {
        return lhs.tipTitle == rhs.tipTitle && lhs.tipDescription == rhs.tipDescription && lhs.detailedSteps == rhs.detailedSteps
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
