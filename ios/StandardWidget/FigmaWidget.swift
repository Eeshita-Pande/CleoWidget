//
//  FigmaWidget.swift
//  StandardWidgetExtension
//
//  Created by Eeshita Pande on 08/01/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct FigmaWidget: Widget {

    let kind: String = "FigmaWidget"

    var body: some WidgetConfiguration {
      IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
          FigmaWidgetEntryView(entry: entry)
      }
      .supportedFamilies([.systemSmall])
        .configurationDisplayName("Figma Widget")
        .description("This is an example widget.")
    }

}

struct FigmaWidgetEntryView : View {
  var entry: Provider.Entry
  
    var body: some View {
       
        ZStack(alignment: .bottomLeading) {
            VStack {
                Image("SAImage")
                    .resizable()
                    .aspectRatio(147/93, contentMode: .fit)
                    Spacer()
            }
            
            VStack {
                RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.153, green: 0.18, blue: 0.231))
                        .aspectRatio(100/53, contentMode: .fit)
                        .overlay {RoundedRectangle(cornerRadius: 20).stroke(.black.opacity(0.3), lineWidth: 7)}
            }
            HStack {
                VStack {
                    AmountButton(text: "$50", dim: 50, fontsize: 20)
                        .bold()
                }
                VStack {
                    HStack(spacing: -10) {
                        VStack {
                            AmountButton(text: "$40", dim: 30, fontsize: 12)
                        }
                        VStack {
                            AmountButton(text: "$30", dim: 30, fontsize: 12)
                        }
                        VStack {
                            AmountButton(text: "$20", dim: 30, fontsize: 12)
                        }
                    }
                    Text("available").foregroundColor(.gray)
                        .font(.system(size: 12))
                }
                
            }
 
            .padding()
            
        }
    }
}
  
  struct FigmaWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
      FigmaWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), text: "widget", checkInt: 0))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
  }

struct AmountButton: View {
    
    let text: String
    let dim: CGFloat
    let fontsize: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(red: 0.204, green: 0.11, blue: 1))
            .frame(width: dim, height: dim)
            .overlay(Text(text).foregroundColor(.white)
                .font(.system(size: fontsize))
                )
            .overlay {RoundedRectangle(cornerRadius: 20).stroke(.black.opacity(0.5), lineWidth: 2)}
    }
}
