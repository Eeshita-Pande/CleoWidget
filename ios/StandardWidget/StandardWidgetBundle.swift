//
//  StandardWidgetBundle.swift
//  StandardWidget
//
//  Created by Eeshita Pande on 29/12/2022.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct StandardWidgetBundle: WidgetBundle {
    var body: some Widget {
        StandardWidget()
        FigmaWidget()
        SpendUnderWidget()
        StandardWidgetLiveActivity()
    }
}
