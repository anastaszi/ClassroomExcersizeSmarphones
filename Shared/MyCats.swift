//
//  NewsData.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/24/21.
//

import Foundation
import UIKit
import os.log

class CatsData: Identifiable, Codable {
    
    var id: UUID
    var title: String
    var author: String?
    var review: String?
    var photo: String?
    var attitude: String?
    var userName: String
    var link: URL?
    var rating: Int
    var bestCharacteristics: String?
    var coordinate: Coordinate?
    
    
    init?(id: UUID = UUID(), title: String, author: String?, review: String?, photo: String?, attitude: String?, userName: String, link: URL?, rating: Int, bestCharacteristics: String?, coordinate: Coordinate?) {
        
        guard !title.isEmpty  else {
            return nil
        }
        guard !userName.isEmpty  else {
            return nil
        }
        
        guard (rating > 0) && (rating <= 5) else {
            return nil
        }
        
        self.id = id
        self.title = title;
        self.author = author;
        self.review = review;
        self.photo = photo;
        self.attitude = attitude;
        self.userName = userName;
        self.link = link;
        self.rating = rating;
        self.bestCharacteristics = bestCharacteristics;
        self.coordinate = coordinate;
    }
    
    static var defaultData: [CatsData] = {
        /*if let savedData = loadMyDataFromArchive() {
            return savedData
        }
         */
        if let localData = loadDataFromPlistNamed("localdata") {
            return localData
        }
        return loadDataFromCode()
    }()
    
    static func loadDataFromCode() -> [CatsData] {
        guard let cat1 = CatsData.init(title: "Sleepy Queen", author: "Someone", review: "best hero", photo: "cat", attitude: "like", userName: "me", link: nil, rating: 3, bestCharacteristics: nil, coordinate: nil) else {fatalError("Unable to initiate data1")};
        
        guard let cat2 = CatsData.init(title: "Friends", author: "Someone", review: "best hero", photo: "friends", attitude: "like", userName: "me", link: nil, rating: 3, bestCharacteristics: "It's very friendly", coordinate: nil) else {fatalError("Unable to initiate data2")};
        guard let cat3 = CatsData.init(title: "Love", author: "Someone", review: "best hero", photo: "heart", attitude: "like", userName: "me", link: nil, rating: 3, bestCharacteristics: "It's very friendly", coordinate: nil) else {fatalError("Unable to initiate data2")};
        guard let cat4 = CatsData.init(title: "Meow", author: "Someone", review: "best hero", photo: "meow", attitude: "like", userName: "me", link: nil, rating: 3, bestCharacteristics: "It's very friendly", coordinate: nil) else {fatalError("Unable to initiate data2")};
        guard let cat5 = CatsData.init(title: "Food", author: "Someone", review: "best hero", photo: "sushi", attitude: "like", userName: "me", link: nil, rating: 3, bestCharacteristics: "It's very friendly", coordinate: nil) else {fatalError("Unable to initiate data2")};
                
                var mydata = [CatsData]()
                mydata += [cat1, cat2, cat3, cat4, cat5]
                return mydata
            }
/*
    static func saveMyData(mydata: [CatsData]) {
        do {
            let needsavedata = try NSKeyedArchiver.archivedData(withRootObject: mydata, requiringSecureCoding: false)
            try needsavedata.write(to: ArchiveURL)
        } catch {
            //fatalError("Unable to save data")
            print(error)
            os_log("Failed to save data...", log: OSLog.default, type: .error)
        }
    }

    static func loadMyDataFromArchive() -> [CatsData]? {
        do {
            guard let codedData = try? Data(contentsOf: CatsData.ArchiveURL) else {
                return nil
            }
            let loadedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [CatsData]
            return loadedData
        } catch {
            os_log("Failed to load data ....", log: OSLog.default, type: .error)
        }
        return nil
    }
*/
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("MyModelData")
    
    
    static func loadDataFromPlistNamed(_ plistName: String) -> [CatsData]? {
        guard
            let path = Bundle.main.path(forResource: plistName, ofType: "plist"),
            let dictArray = NSArray(contentsOfFile: path) as? [[String: AnyObject]]
        else {
            fatalError("An error occured while reading \(plistName).plist")
        }
        
        var CatsDataReturn: [CatsData] = [];
        
        for dict in dictArray {
            guard
                //let id = dict["id"] as? Int,
                let title = dict["title"] as? String,
                let author = dict["author"] as? String,
                let review = dict["review"] as? String,
                let photo = dict["thumbnailPic"] as? String,
                let attitude = dict["attitude"] as? String,
                let userName = dict["userName"] as? String,
                let link = dict["link"] as? String,
                let rating = dict["rating"] as? Int,
                let bestCharacteristics = dict["bestCharacteristics"] as? String,
                let longitude = dict["longitude"] as? Double,
                let latitude = dict["latitude"]
                    as? Double
            else {
                fatalError("error parsing data \(dict)")
            }
            
            let webUrl = URL(string: link)
            let coordinate = Coordinate(latitude: latitude, longitude: longitude)
            
            guard let newReview = CatsData.init(title: title, author: author, review: review, photo: photo, attitude: attitude, userName: userName, link: webUrl, rating: rating, bestCharacteristics: bestCharacteristics, coordinate: coordinate) else {
                fatalError("Error creating review")
            }
            
           CatsDataReturn.append(newReview)
                
        }
        return CatsDataReturn
    }
    

    
}

