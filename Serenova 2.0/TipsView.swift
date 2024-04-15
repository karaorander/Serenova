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
    Article(articleTitle: "The Importance of Deep Sleep", articleLink: "Get Some Deep Sleep Today", articlePreview: "Deep sleep plays a crucial role in your overall health...", articleTags: ["Health", "Sleep"], articleId: "1"),
    Article(articleTitle: "5 Tips for Better Sleep Hygiene", articleLink: "Get better sleep hygiene", articlePreview: "Improving your sleep hygiene can lead to better sleep quality...", articleTags: ["Tips", "Hygiene"], articleId: "2"),
    
    Article(articleTitle: "Insomnia: Symptoms, Causes, and Treatments", articleLink: "https://www.sleepfoundation.org/insomnia", articlePreview: "Insomnia is a sleep disorder characterized by difficulty...", articleTags: ["insomnia", "tips", "information"], articleId: "3"),
    Article(articleTitle: "What is insomnia? Everything you need to know", articleLink: "https://www.medicalnewstoday.com/articles/9155#definition", articlePreview: "Research shows that around 25% of people in the United States experience", articleTags: ["insomnia"], articleId: "4"),
    Article(articleTitle: "Prevalence of chronic insomnia in adult patients and its correlation with medical comorbidities", articleLink: "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5353813/", articlePreview: "Insomnia is one of the common but neglected conditions...", articleTags: ["insomnia"], articleId: "5"),
    
    Article(articleTitle: "Medicines for sleep", articleLink: "https://medlineplus.gov/ency/patientinstructions/000758.htm", articlePreview: "Some people may need medicines to help with sleep for a short period of time...", articleTags: ["meds"], articleId: "6"),
    Article(articleTitle: "The effects of medications on sleep quality and sleep architecture", articleLink: "https://www.uptodate.com/contents/the-effects-of-medications-on-sleep-quality-and-sleep-architecture", articlePreview: "Any medication that passes through the blood-brain barrier has the potential to alter the quality and/or architecture of sleep:...", articleTags: ["meds"], articleId: "7"),
    Article(articleTitle: "Sleep Medication Use in Adults Aged 18 and Over: United States, 2020", articleLink: "https://www.cdc.gov/nchs/products/databriefs/db462.htm", articlePreview: "In 2020, 8.4% of adults took sleep medication in the last 30 days either...", articleTags: ["meds"], articleId: "8"),
    
    // Add more articles as needed
] // ex: index = 0-4 insomnia articles (this is the backup plan)

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
    
    
    
    func fetchUsername(completion: @escaping () -> Void) {
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
            
            print("TOTAL SLEEP GOAL RETRIEVED: \(self.totalSleepGoalHours)")
            if let totalSleepGoalMins = userData["totalSleepGoalMins"] as? Float {
                self.totalSleepGoalMins = totalSleepGoalMins
                //currUser?.totalSleepGoalMins = totalSleepGoalMins
            }
            
            if let deepSleepGoalHours = userData["deepSleepGoalHours"] as? Float {
                self.deepSleepGoalHours = deepSleepGoalHours
                //currUser?.deepSleepGoalHours = deepSleepGoalHours
            }
            print("TOTAL SLEEP GOAL RETRIEVED: \(self.deepSleepGoalHours)")
            
            
            if let deepSleepGoalMins = userData["deepSleepGoalMins"] as? Float {
                self.deepSleepGoalMins = deepSleepGoalMins
                //currUser?.deepSleepGoalMins = deepSleepGoalMins
            }
            
            if let moonCount = userData["moonCount"]
                as? Int {
                self.moonCount = moonCount
            }
            self.objectWillChange.send()
                            
                            // Call the completion closure to indicate that data fetching is completed
                            completion()
            
        }
    }
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
    @StateObject private var viewModel = TipsViewModel()
    @State private var myTips: [Article] = []
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
                            
                            SectionHeaderView(title: "Relevant Sleep Tips")
                                // Display relevant tips in a row
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(myTips, id: \.articleId) { (article: Article) in
                                        ArticleCardView(articleTitle: article.articleTitle, articleDescription: article.articlePreview)
                                            .frame(width: 200, height: 150) // Adjust the frame size as needed
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
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
        .onAppear {
            // Call get_relevent_tips function when the view appears
            viewModel.fetchUsername{
                get_relevent_tips()
            }
            myTips = get_relevent_tips()
        }
    }
    
    func get_relevent_tips () -> Array<Article> {
        
        var releventArts = [Article]()
        
        var userTags = [String()]
        
        if (viewModel.hasinsomnia || viewModel.hadinsomnia) {
            userTags.append("insomnia")
        }
        
        let myAge = Int(viewModel.age) ?? -1
        
        if (myAge > 65) {
            userTags.append("old")
        }
        
        if (myAge <= 17 && myAge >= 5) {
            userTags.append("kid")
        }
        
        if (myAge < 5 && myAge > -1) {
            userTags.append("baby")
        }
        
        var gendervar = "female"
        
        if (viewModel.gender.lowercased() == gendervar) {
            userTags.append("female")
        }
        
        gendervar = "male"
        
        if (viewModel.gender.lowercased() == gendervar) {
            userTags.append("male")
        }
        
        if (viewModel.snore) {
            userTags.append("snore")
        }
        
        if (viewModel.hasmedication) {
            userTags.append("meds")
        }
        
        if (viewModel.hasnightmares) {
            userTags.append("nightmares")
        }
        
        if (viewModel.isearlybird) {
            userTags.append("earlybird")
        }
        
        
        
        for article in articles {
            for tag in article.articleTags {
                if (userTags.contains(tag)) {
                    releventArts.append(article)
                }
            }
        }
        
        //TODO: Add "read" tag to articles to keep track of if a user has already read an article
        
        if (releventArts.count == 0) {
            return articles
        }
        return releventArts
    } //end of get_relevent_articles
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
