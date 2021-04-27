//
//  ClassRoomExcersizeApp.swift
//  Shared
//
//  Created by Anastasia Zimina on 4/24/21.
//

import SwiftUI

@main
struct ClassRoomExcersizeApp: App {
    @StateObject private var userdata = UserData()
    var body: some Scene {
        WindowGroup {
            //ContentView()
            //Profile(currentUser: userdata)
            TabedView().environmentObject(userdata)
                .onAppear{
                    userdata.load()
                }
        }
    }
}
