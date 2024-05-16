//
//  CountHelper.swift
//  RNWatchWidget Watch App
//
//  Created by Kunjal Soni on 11/03/24.
//

import SwiftUI
import WatchKit
import WatchConnectivity
import WidgetKit

class ConnectionHelper: NSObject, ObservableObject {
  
  @AppStorage("appCount", store: UserDefaults(suiteName: "group.watchWidget.count")) var appCount = 0

  @Published var count = 0 {
    didSet {
      appCount = count;
      WidgetCenter.shared.reloadAllTimelines()
    }
  }
  
  var session: WCSession
  
  init(session: WCSession  = .default) {
    self.session = session
    super.init()
    if WCSession.isSupported() {
      session.delegate = self
      session.activate()
    }
  }
  
  func sendNewCount() {
    let messageData = ["count": self.count]
    self.session.sendMessage(messageData) { reply in
      print("received response :", reply)
    } errorHandler: { error in
      print("error sending message :", error)
    }
  }
  
}

extension ConnectionHelper: WCSessionDelegate {
  
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
    guard let newCount = message["count"] as? Int else { return }
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.count = newCount
      replyHandler(["success": true, "count": count])
    }
  }
  
}
