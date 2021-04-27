//
//  ImagePickView.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/27/21.
//

import SwiftUI
import PhotosUI

struct ImageListItem: Hashable, Equatable, Identifiable {
    var id: Int
    var image: UIImage
}

struct ImagePickView: View {
    @State var images: [ImageListItem] = [
        ImageListItem(id: 1, image: UIImage(named: "cat")!),
        ImageListItem(id: 2, image: UIImage(named: "heart")!),
        ImageListItem(id: 3, image: UIImage(named: "friends")!)
    ]
    @State var showPhotoLibrary = false
    
    var pickerConfiguration: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 10
        return config
    }
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Button(action: {
                        showPhotoLibrary = true
                    }) {
                        Text("Add photos")
                    }
                    Spacer()
                }.sheet(isPresented: $showPhotoLibrary) {
                    ImagePicker(configuration: pickerConfiguration){
                        selectedImage in
                        images.append(ImageListItem(id: images.count + 1, image: selectedImage))
                    }
            
                }
                Collection(data: images, cols: 3, spacing: 4) {
                    data, _ in
                    Image(uiImage: data.image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                }
            }.navigationBarTitle("PHPicker App", displayMode: .inline).padding()
        }
    }
}

struct ImagePickView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickView()
    }
}
