//
//  UserData.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/25/21.
//

import Foundation

class UserData: ObservableObject {
    @Published var catsData: [CatsData] = []
    @Published var userProfile: ProfileData
    
    
    init(catsData: [CatsData] = CatsData.defaultData, profile: ProfileData = ProfileData.myDefault) {
        self.catsData = catsData;
        self.userProfile = profile;
    }
    
    private static var documentFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find document directory")
        }
    }
    
    private static var catfileURL: URL {
        return documentFolder.appendingPathComponent("catsmodel.data")
    }
    
    private static var profilefileURL: URL {
        return documentFolder.appendingPathComponent("profilemodel.data")
    }
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.catfileURL), let profiledata = try? Data(contentsOf: Self.profilefileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.catsData = CatsData.defaultData
                    self?.userProfile = ProfileData.myDefault
                }
                #endif
                return
            }
            guard let decodedCatsData = try? JSONDecoder().decode([CatsData].self, from: data) else {
                fatalError("Can't decode saved cats data")
            }
            
            
            guard let decodedProfileData = try? JSONDecoder().decode(ProfileData.self, from: profiledata) else {
                fatalError("Can't decode saved profiledata")
            }
            
            DispatchQueue.main.async {
                self?.catsData = decodedCatsData
                self?.userProfile = decodedProfileData
            }
        }
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let cats = self?.catsData else {fatalError("Self out of scope")}
            guard let myprofile = self?.userProfile else {fatalError("Self out of scope")}
            
            guard let catsdata = try? JSONEncoder().encode(cats) else {fatalError("Error in encoding catsdata")}
            guard let profiledata = try? JSONEncoder().encode(myprofile) else {fatalError("Error in encoding profile data")}
            
            do {
                let outfile = Self.catfileURL
                try catsdata.write(to: outfile)
                try profiledata.write(to: Self.profilefileURL)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}

let testUser = UserData(catsData: CatsData.defaultData, profile: ProfileData.myDefault)
    

struct ProfileData: Identifiable, Codable {
    var id: UUID
    var userName: String
    var bestBreed: Breed
    var joinedDate: Date
    var allowNotifications: Bool
    var vip: Bool
    
    
    static let myDefault = Self(userName: "Anastasia", breed: .british, notifications: true);
    
    
    init(id: UUID = UUID(), userName: String, breed: Breed = .british, notifications: Bool, vip: Bool = true) {
        self.userName = userName
        self.bestBreed = breed
        self.allowNotifications = notifications
        self.joinedDate = Date()
        self.vip = vip
        self.id = id
    }
    
    enum Breed: String, CaseIterable, Codable {
        case british = "British"
        case persian = "Persian"
        case maincoon = "Main Coon"
    }
    
}
