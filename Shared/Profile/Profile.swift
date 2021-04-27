//
//  Profile.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/25/21.
//

import SwiftUI

struct Profile: View {
    //@ObservedObject var currentUser: UserData
    @EnvironmentObject var currentUser: UserData
    @Environment(\.editMode) var mode
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                
                EditButton()
                    .padding(.horizontal)
            }
            if self.mode?.wrappedValue == .inactive {
                ProfileSummery(profile: currentUser.userProfile)
            } else {
                ProfileEditor(currentUser: currentUser)
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile().environmentObject(UserData())
    }
}

struct ProfileSummery: View {
    var profile: ProfileData
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        List {
            Text(profile.userName)
                .bold()
                .font(.title)
            
            Text("Notifications \(self.profile.allowNotifications ? "On" : "Off")")
            Text("UserName \(self.profile.userName)")
            
            Text("Joined Date: \(self.profile.joinedDate, formatter: Self.dateFormat)")
        }
    }
}
