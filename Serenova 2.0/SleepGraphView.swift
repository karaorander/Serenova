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

struct SleepGraphView: View {
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
    //TODO: Get Average sleep Times from database

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    
                    LinearGradient(gradient: Gradient(colors: [ .nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                        
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
                }
            }.overlay(alignment: .bottom, content: {
                
                HStack (spacing: 40){
                    NavigationLink(destination: SleepGraphView().navigationBarBackButtonHidden(true)) {
                        
                        Image(systemName: "chart.xyaxis.line")
                            .resizable()
                            .frame(width: 30, height: 35)
                            .foregroundColor(.white)
                        
                    }
                    NavigationLink(destination: SleepLogView().navigationBarBackButtonHidden(true)) {
                        
                        Image(systemName: "zzz")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                        
                    }
                    NavigationLink(destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {
                        
                        Image(systemName: "list.clipboard")
                            .resizable()
                            .frame(width: 30, height: 40)
                            .foregroundColor(.white)
                        
                    }
                    NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {
                        
                        Image(systemName: "person.2")
                            .resizable()
                            .frame(width: 45, height: 30)
                            .foregroundColor(.white)
                        
                    }
                }.padding()
                    .hSpacing(.center)
                    .background(Color.dreamyTwilightMidnightBlue)
                
            })
            
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let averageSleep: Int
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}


#Preview {
    SleepGraphView()
}
