//
//  TabedView.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/25/21.
//

import SwiftUI

struct TabedView: View {
    @EnvironmentObject var currentUser: UserData
    @State private var tabSelected = 0;
    var body: some View {
        TabView(selection: $tabSelected) {
            ContentView(catsData: $currentUser.catsData, saveAction: {currentUser.save()})
                .tabItem{
                    Image(systemName: (tabSelected == 0 ? "newspaper" : "newspaper.fill"))
                    Text("My Cats")
                }.tag(0)
            Profile()
                .tabItem {
                    Image(systemName: (tabSelected == 1 ? "person.crop.circle" : "person.crop.circle.fill"))
                    Text("Profile")
                }.tag(1)
            ImagePickView()
                .tabItem {
                    Image(systemName: (
                        tabSelected == 2 ?
                        "photo" : "photo.fill"))
                    Text("Image Gallery")
                }.tag(2)
            CurrentLocationMapView()
                .tabItem {
                    Image(systemName: (tabSelected == 3 ? "location.circle" : "location.circle.fill"))
                    Text("Location")
                }.tag(3)
        }
    }
}

struct TabedView_Previews: PreviewProvider {
    static var previews: some View {
        TabedView().environmentObject(UserData())
    }
}
