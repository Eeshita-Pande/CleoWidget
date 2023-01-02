//
//  StandardWidget.swift
//  StandardWidget
//
//  Created by Eeshita Pande on 29/12/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct widgetData: Decodable {
   var text: String
}
struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "widget")
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, text: "widget")
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    let entryDate = Date()
    
    let userDefaults = UserDefaults.init(suiteName: "group.com.eeshita.widget")
    if userDefaults != nil {
      if let savedData = userDefaults!.value(forKey: "widgetKey") as? String {
        let decoder = JSONDecoder()
        let data = savedData.data(using: .utf8)
        
        if let parsedData = try? decoder.decode(widgetData.self, from: data!) {
          let nextRefresh = Calendar.current.date(byAdding: .minute, value: 1, to: entryDate)!
          let entry = SimpleEntry(date: nextRefresh, configuration: configuration, text: parsedData.text)
          let timeline = Timeline(entries: [entry], policy: .atEnd)
          
          completion(timeline)
        } else {
          print("Could not parse data")
        }
        
      } else {
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 5, to: entryDate)!
        let entry = SimpleEntry(date: nextRefresh, configuration: configuration, text: "No data set")
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
}

struct StandardWidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    ZStack (alignment: .leading) {
      Color(red: 194/255, green: 210/255, blue: 253/255)
      VStack (alignment: .leading) {
        Text(entry.text)
          .bold()
          .font(.system(size: 12))
          .foregroundColor(.black)
          .padding(.leading)
        Image("WidgetImage")
          .resizable()
          .frame(alignment: .bottom)
          .aspectRatio(88/100, contentMode: .fit)
          .padding(.leading)
      }
      .padding(.top)
    }
  }
}

struct StandardWidget: Widget {
    let kind: String = "StandardWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            StandardWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct StandardWidget_Previews: PreviewProvider {
    static var previews: some View {
      StandardWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "widget"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

