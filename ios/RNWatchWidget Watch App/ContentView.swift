//
//  ContentView.swift
//  RNWatchWidget Watch App
//
//  Created by Kunjal Soni on 11/03/24.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var connectionHelper = ConnectionHelper()
  
  var body: some View {
    VStack {
      Button("+", action: {
        connectionHelper.count += 1
        connectionHelper.sendNewCount()
      })
      Text("\(connectionHelper.count)")
      Button("-", action: {
        connectionHelper.count -= 1
        connectionHelper.sendNewCount()
      })
    }
  }
}

#Preview {
  ContentView()
}
