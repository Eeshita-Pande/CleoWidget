//
//  SpendUnderWidget.swift
//  StandardWidgetExtension
//
//  Created by Eeshita Pande on 11/01/2023.
//

import SwiftUI
import WidgetKit
import Intents

struct widgetData: Decodable {
  var text: String
}

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "widget", checkInt: -987654321)
    // Used a number which is out of range for valid values on balance over/under condition so it can be used to attribute an error if CheckInt isn't replaced by a more appropriate positive or negative balance
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, text: "widget", checkInt: -987654321)
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    let entryDate = Date()
    
    // Pulling data from react-app
    let userDefaults = UserDefaults.init(suiteName: "group.com.eeshita.widget")
    if userDefaults != nil {
      if let savedData = userDefaults!.value(forKey: "widgetKey") as? String {
        let decoder = JSONDecoder()
        let data = savedData.data(using: .utf8)
        
        // currently refreshing every 5 mins which is the most frequently Apple allows refreshes for widgets
        if let parsedData = try? decoder.decode(widgetData.self, from: data!) {
          let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: entryDate)!
          let entry = SimpleEntry(date: nextRefresh, configuration: configuration, text: parsedData.text, checkInt: Int(parsedData.text) ?? -987654321)
          let timeline = Timeline(entries: [entry], policy: .atEnd)
          
          completion(timeline)
        } else {
          print("Could not parse data")
        }
        
      } else {
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: entryDate)!
        let entry = SimpleEntry(date: nextRefresh, configuration: configuration, text: "No data set", checkInt: -987654321)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        
        completion(timeline)
      }
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let text: String
  let checkInt: Int
}

struct SpendUnderWidget: Widget {
  
  let kind: String = "SpendUnderWidget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      SpendUnderWidgetEntryView(entry: entry)
    }
    .supportedFamilies([.systemSmall])
    .configurationDisplayName("SpendUnderWidget")
    .description("This is an example widget.")
  }
  
}

struct SpendUnderWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    ZStack  {
      // conditional view if spending is under budget
      if entry.checkInt >= 0 {
        Color(red: 0.847, green: 0.82, blue: 1)
        VStack {
          Image("SpendUnder")
          Text("SPENDING IS").font(Font.custom("GTFlexaTrialVF-CompressedBold", size: 26)).bold()
          HStack{
            Text("$" + entry.text).font(Font.custom("GTFlexaTrialVF-CompressedBold", size: 26)).bold().foregroundColor(.indigo)
            Text("UNDER").font(Font.custom("GTFlexaTrialVF-CompressedBold", size: 26)).bold()
          }
          Text("").font(.system(size: 20)).bold()
          HStack {
            Text(Date(), style: .time).font(Font.custom("Archivo-Regular", size: 8))
            Text(Date(), style: .date).font(Font.custom("Archivo-Regular", size: 8))
          }
        }
        // conditional view if spending is over budget
      } else if entry.checkInt < 0 && entry.checkInt != -964783 {
        Color(red: 1, green: 0.89, blue: 0.847)
        VStack {
          Image("BankOnFire")
          Text("SPENDING IS").font(Font.custom("GTFlexaTrialVF-CompressedBold", size: 26)).bold()
          HStack{
            Text("$" + (String(abs(entry.checkInt)))).font(Font.custom("GTFlexaTrialVF-CompressedBold", size: 26)).bold().foregroundColor(.red)
            Text("OVER").font(Font.custom("GTFlexaTrialVF-CompressedBold", size: 26)).bold()
          }
          Text("").font(.system(size: 20)).bold()
          
          HStack {
            Text(Date(), style: .time).font(Font.custom("Archivo-Regular", size: 8))
            Text(Date(), style: .date).font(Font.custom("Archivo-Regular", size: 8))
          }
        }
        // error handling
      } else if entry.checkInt == -987654321 {
        Color(red: 0.847, green: 0.82, blue: 1)
        VStack {
          Image("EyeCandy")
          Text("No data available").font(Font.custom("Archivo-Regular", size: 8))
          HStack {
            Text(Date(), style: .time).font(Font.custom("Archivo-Regular", size: 8))
            Text("").font(.system(size: 20)).bold()
            Text(Date(), style: .date).font(Font.custom("Archivo-Regular", size: 8))
          }
        }
      }
    }
  }
}

