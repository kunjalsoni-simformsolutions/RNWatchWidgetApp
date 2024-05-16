//
//  CounterWidget.swift
//  CounterWidget
//
//  Created by Kunjal Soni on 28/03/24.
//

import WidgetKit
import SwiftUI


struct Provider: AppIntentTimelineProvider {
  
  @AppStorage("appCount", store: UserDefaults(suiteName: "group.watchWidget.count")) var appCount = 0
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(currentCount: appCount))
  }
  
  func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
    var config = configuration
    config.currentCount = appCount
    
    return SimpleEntry(date: Date(), configuration: config)
  }
  
  func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
    var config = configuration
    config.currentCount = appCount
    
    let entry = SimpleEntry(date: Date(), configuration: config)
    return Timeline(entries: [entry], policy: .atEnd)
  }
  
  func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
    // Create an array with all the preconfigured widgets to show.
    [AppIntentRecommendation(intent: ConfigurationAppIntent(currentCount: appCount), description: "Example Widget")]
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationAppIntent
}

struct CounterWidgetEntryView: View {
  @Environment(\.widgetFamily) var widgetFamily;
  var entry: Provider.Entry
  
  var body: some View {
    switch widgetFamily {
    case .accessoryCircular:
      Text("\(entry.configuration.currentCount)")
    case .accessoryInline:
      Text("Count: \(entry.configuration.currentCount)").multilineTextAlignment(.center)
    default:
      Text("Count: \(entry.configuration.currentCount)").multilineTextAlignment(.center)
    }
  }
}

@main
struct CounterWidget: Widget {
  let kind: String = "CounterWidget"
  
  var body: some WidgetConfiguration {
    AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
      CounterWidgetEntryView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }.configurationDisplayName("Counter widget")
      .description("Shows latest value of appCounter")
      .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
  }
}
