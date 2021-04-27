//
//  ProfileEditor.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/25/21.
//

import SwiftUI

struct ProfileEditor: View {
    @ObservedObject var currentUser: UserData
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: currentUser.userProfile.joinedDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: currentUser.userProfile.joinedDate)!
        return min...max
    }
    
    var body: some View {
        List {
            HStack {
                Text("UserName").bold()
                Divider()
                TextField("Username", text: $currentUser.userProfile.userName)
            }
            Toggle(isOn: $currentUser.userProfile.allowNotifications) {
                Text("Enable Notifications")
            }
            
            Text("Notification Status: \(currentUser.userProfile.allowNotifications ? "On" : "Off") ")
            
            Picker("Best Breed", selection:
                    $currentUser.userProfile.bestBreed) {
                ForEach(ProfileData.Breed.allCases, id: \.self) { breed in
                    Text(breed.rawValue).tag(breed)
                }
            }
            VStack(alignment: .leading, spacing: 20, content: {
                Text("Date").bold()
                DatePicker("Date",
                           selection: $currentUser.userProfile.joinedDate,
                           in: dateRange)
            })
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(currentUser: testUser)
    }
}
