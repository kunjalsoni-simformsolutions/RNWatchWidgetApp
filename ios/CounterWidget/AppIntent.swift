//
//  AppIntent.swift
//  CounterWidget
//
//  Created by Kunjal Soni on 28/03/24.
//

import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
  
  static var title: LocalizedStringResource = "Configuration"
  static var description = IntentDescription("This is an example widget.")
  
  var currentCount = 0
  
  init() {}
  
  init(currentCount: Int = 0) {
    self.currentCount = currentCount
  }
  
}
