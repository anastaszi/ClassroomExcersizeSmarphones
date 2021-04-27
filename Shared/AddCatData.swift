//
//  AddCatData.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/25/21.
//

import Foundation
import SwiftUI

struct AddCatData {
    var title: String = ""
    var author: String = ""
    var review: String = ""
    var photo: CatPhoto = .cat
    var attitude: Bool = true
    var userName: String = "Anastasia"
    var link: String = ""
    var bestCharacteristics: String = ""
    var rating: Int = 1;
    
}

enum CatPhoto: String, CaseIterable, Hashable, Identifiable {
    case cat = "cat"
    case friends = "friends"
    case heart = "heart"
    case meow = "meow"
    case sushi = "sushi"
    
    var id: CatPhoto {self}
}
