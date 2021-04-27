//
//  AddCat.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/25/21.
//

import SwiftUI

struct CatPhotoPicker: View {
    @Binding var photo: CatPhoto
    
    var body: some View {
        Picker(selection: $photo, label: Text("Pic")) {
            ForEach(CatPhoto.allCases) { photo in
                //Text(photo.rawValue).tag(photo)
                Image(uiImage: UIImage(imageLiteralResourceName: photo.rawValue))
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/67.6/*@END_MENU_TOKEN@*/)
                    .tag(photo)
            }
        }
    }
}



struct AddCat: View {
    @Binding var showSheetView: Bool
    @State var emptyPlaceHolder = "Tell us more!"
    
    @State var addcat = AddCatData()
    @Binding var catsData: [CatsData]
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Cat info")) {
                    TextField("Enter Cat name", text: $addcat.title)
                    TextField("Enter Cat's best friend", text: $addcat.author)
                }
                Section(header: Text("Enter your Review")) {
                    TextEditor(text: $addcat.review)
                        .foregroundColor(.secondary)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 100,  maxHeight: 200)
                }
                Section(header: Text("Choose Cat pic")) {
                    CatPhotoPicker(photo: $addcat.photo)
                }
                Section(header: Text("How do you feel about this Cat?")) {
                    Toggle(isOn: $addcat.attitude) {
                        Text(addcat.attitude ? "I like it!" : "I don't like it")
                    }
                    if (addcat.attitude) {
                        TextEditor(text: $addcat.bestCharacteristics)
                            .foregroundColor(.secondary)
                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 50,  maxHeight: 100)
                    }
                }
                Section(header: Text("Add you Rating")) {
                    Stepper(value: $addcat.rating, in: 1...5) {
                        Text("Rating: \(addcat.rating)")
                    }
                }
            }
            .navigationTitle("Add New Cat")
            .navigationBarItems(trailing: Button(action: {
                    print("Dismiss sheet view...")
                let myAttitude = (addcat.attitude) ? "like" : "dislike"
                let newData = CatsData.init(title: addcat.title, author: addcat.author, review: addcat.review, photo: addcat.photo.rawValue, attitude: myAttitude, userName: "Anastasia", link: nil, rating: addcat.rating, bestCharacteristics: addcat.bestCharacteristics, coordinate: nil)
                if newData != nil {
                    catsData.append(newData!)
                }
                    self.showSheetView = false;
                }){
                    Text("Save").bold()
                })
        }
    }
}

struct AddCat_Previews: PreviewProvider {
    static var previews: some View {
        AddCat(showSheetView: .constant(true), catsData: .constant(CatsData.defaultData))
    }
}
