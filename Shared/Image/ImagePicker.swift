//
//  ImagePicker.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/27/21.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    let configuration: PHPickerConfiguration
    let completion: (_ selectedImage: UIImage) -> Void // this is handler
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_: PHPickerViewController, context _: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            for image in results {
                image.itemProvider.loadObject(ofClass: UIImage.self) {
                    selectedImage, error in
                    if let error = error {
                        print("Error")
                        return
                    }
                    
                    guard let uiImage = selectedImage as? UIImage else {
                        print("unable to unwrap image as UIImage")
                        return
                    }
                    
                    self.parent.completion(uiImage)
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
