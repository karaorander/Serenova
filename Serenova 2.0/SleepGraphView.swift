//
//  SleepGraphView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/27/24.
//

import SwiftUI
import UIKit
import Charts
import Foundation

/*
let viewMonths: [ViewMonth] = [
    .init(date: Date.from(year: 2023, month: 1, day: 1), averageSleep: 800),
    .init(date: Date.from(year: 2023, month: 2, day: 1), averageSleep: 300),
    .init(date: Date.from(year: 2023, month: 3, day: 1), averageSleep: 900),
    .init(date: Date.from(year: 2023, month: 4, day: 1), averageSleep: 700),
    .init(date: Date.from(year: 2023, month: 5, day: 1), averageSleep: 700),
    .init(date: Date.from(year: 2023, month: 6, day: 1), averageSleep: 500),
    .init(date: Date.from(year: 2023, month: 7, day: 1), averageSleep: 800),
    .init(date: Date.from(year: 2023, month: 8, day: 1), averageSleep: 300),
    .init(date: Date.from(year: 2023, month: 9, day: 1), averageSleep: 900),
    .init(date: Date.from(year: 2023, month: 10, day: 1), averageSleep: 700),
    .init(date: Date.from(year: 2023, month: 11, day: 1), averageSleep: 700),
    .init(date: Date.from(year: 2023, month: 12, day: 1), averageSleep: 500)
]
*/

/*
VStack {
    Text("Sleep Trends")
        .font(Font.custom("NovaSquare-Bold", size: 50))
        .foregroundColor(.white.opacity(0.7))
        .scaledToFit().minimumScaleFactor(0.01)
        .lineLimit(1)
        .overlay(alignment: .topTrailing, content: {
            
                NavigationLink(destination: AccountInfoView().navigationBarBackButtonHidden(true)) {

                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(.circle)
                        .foregroundColor(.white)
                        .position(x:300, y:0)
                
                }.padding(.bottom)
            
        })
        
    
    //Spacer().frame(height: 30)
    
    VStack(alignment: .leading, spacing:2) {
        
        Chart {
            //Goal Line
            RuleMark(y: .value("Goal", 600))
            // TODO: Get Goal from User's Goals
                .foregroundStyle(Color.moonlitSerenitySteelBlue.opacity(2))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            
            //Sleep Graph
            ForEach(viewMonths) { viewMonth in
                LineMark(
                    x: .value("Month", viewMonth.date, unit: .month),
                    y: .value("Minutes", viewMonth.averageSleep)
                )
                .foregroundStyle(Color.purple.gradient)
                .cornerRadius(3)
            }
        }
        .chartXAxis {AxisMarks(values: .automatic) {
            AxisValueLabel()
                .foregroundStyle(Color.white)
            AxisGridLine()
                .foregroundStyle(Color.white)
        }
        }
        .chartYAxis {AxisMarks(values: .automatic) {
            AxisValueLabel()
                .foregroundStyle(Color.white)
            AxisGridLine()
                .foregroundStyle(Color.white)
        }
        }
        .frame( width: 350, height: 300)
    }
}
}*/

//var monthly_sleep_data: [Daily] = [
    /*
    Daily(id: 0, day: "Day 1", sleepMinutes: 600, deepSleepMinutes: 300, remMinutes: 300),
    Daily(id: 1, day: "Day 2", sleepMinutes: 400, deepSleepMinutes: 150, remMinutes: 250),
    Daily(id: 2, day: "Day 3", sleepMinutes: 500, deepSleepMinutes: 300, remMinutes: 200),
    Daily(id: 3, day: "Day 4", sleepMinutes: 300, deepSleepMinutes: 220, remMinutes: 80),
    Daily(id: 4, day: "Day 5", sleepMinutes: 450, deepSleepMinutes: 300, remMinutes: 150),
    Daily(id: 5, day: "Day 6", sleepMinutes: 600, deepSleepMinutes: 400, remMinutes: 200),
    Daily(id: 6, day: "Day 7", sleepMinutes: 320, deepSleepMinutes: 300, remMinutes: 20)
    */
//]

struct SleepGraphView: View {
    @State var selected = 0
    var colors = [Color.tranquilMistAccentTurquoise.opacity(0.6), Color.dreamyTwilightMidnightBlue]
    @State private var currentMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var monthly_sleep_data: [Daily] = []

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [ .nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    //Daily Sleep Columns
                    VStack (alignment: .leading, spacing: 2){
                        Spacer()
                        Text("Sleep Trends")
                            .font(Font.custom("NovaSquare-Bold", size: 50))
                            .foregroundColor(.white.opacity(0.7))
                            .scaledToFit().minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .padding(.horizontal, 30).padding(.bottom, 50)
                            .overlay(alignment: .topTrailing, content: {
                                
                                    NavigationLink(destination: AccountInfoView().navigationBarBackButtonHidden(true)) {

                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 45, height: 45)
                                            .clipShape(.circle)
                                            .foregroundColor(.white)
                                            .position(x:300, y:-20)
                                    
                                    }.padding(.bottom)
                                
                            })
                        Text("\(Calendar.current.monthSymbols[currentMonth-1])")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.dreamyTwilightMidnightBlue)
                        Text("Monthly Sleep in Hours").font(.system(size: 15, weight: .heavy)).foregroundColor(.dreamyTwilightMidnightBlue)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack() {
                                ForEach(monthly_sleep_data.reduce(into: [String: Daily]()) { $0[$1.day, default: $1] = $1 }.values.sorted { $0.id < $1.id }, id: \.self) {data in
                                    VStack {
                                        VStack {
                                            Spacer(minLength: 0)
                                            if selected == data.id{
                                                Text(getHrs(value: data.sleepMinutes)).foregroundColor(.nightfallHarmonyNavyBlue).padding(.bottom, 5).font(.caption)
                                            }
                                            
                                            RoundedShape().fill(LinearGradient(gradient: Gradient(colors: selected == data.id ? colors : [Color.nightfallHarmonyNavyBlue.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                                                .frame(height: getheight(value: data.sleepMinutes))
                                            Text(data.day).font(.caption).foregroundColor(.nightfallHarmonyNavyBlue)
                                            
                                        }
                                        .frame(height: 200)
                                        .onTapGesture {
                                            withAnimation(.easeOut) {
                                                selected = data.id
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.06)).cornerRadius(10)
                    .ignoresSafeArea()
                    .overlay(alignment: .bottom, content: {
                        
                       MenuView()
                        
                    })
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear() {
            Task {
                monthly_sleep_data.removeAll()
                getDailyMonthlySleep()
            }
        }
    }
    func getHrs(value: CGFloat)->String {
        let hrs = value / 60
        return String(format: "%.1f", hrs)
    }
    func getheight(value: CGFloat)->CGFloat{
        //val in minutes
        let hrs = CGFloat(value / 1440) * 300
        return hrs
    }
    func getDailyMonthlySleep() {
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        let total_days = calendar.range(of: .day, in: .month, for: today)!.count
        let endDate = calendar.date(byAdding: .day, value: total_days - 1, to: today)!
        
        var currentDate = startDate
        
        let group = DispatchGroup()
        
        while currentDate <= endDate {
            group.enter()
            
            var queryDate = currentDate
            
            sleepManager.querySleepData(completion: { totalSleepTime, deepSleepTime, coreSleepTime, remSleepTime in
                let sleepMinutes = CGFloat(totalSleepTime ?? 0) / 60
                let deepSleepMinutes = CGFloat(deepSleepTime ?? 0) / 60
                let remMinutes = CGFloat(remSleepTime ?? 0) / 60
                
                let number = calendar.component(.day, from: queryDate)
          
                DispatchQueue.main.async {
                    if !monthly_sleep_data.contains(where: { $0.id == number-1 && $0.sleepMinutes > 0 }) {
                        monthly_sleep_data.append(Daily(id: number-1, day: "Day \(number)", sleepMinutes: sleepMinutes, deepSleepMinutes: deepSleepMinutes, remMinutes: remMinutes))
                    }
                }
                //E.g. Daily(id: 0, day: "Day 1", sleepMinutes: 600, deepSleepMinutes: 300, remMinutes: 300)
                group.leave() // Leave the dispatch group when the query completes
            }, date: currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }
}

struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let averageSleep: Int
}
/*
extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
*/

#Preview {
    SleepGraphView()
}
