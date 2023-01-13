//
//  StandardWidget.swift
//  StandardWidget
//
//  Created by Eeshita Pande on 29/12/2022.
//

import WidgetKit
import SwiftUI
import Intents



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
      StandardWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "widget", checkInt: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

