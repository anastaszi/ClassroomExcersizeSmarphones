//
//  TestImage.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 5/16/21.
//

import SwiftUI

struct TestImage: View {
    @StateObject var remoteimage = AsyncRemoteImage()
    private var url: URL
    
    init(url: URL){
        self.url = url
    }
    
    var body: some View {
        VStack {
            if remoteimage.image != nil {
                withAnimation(){
                    Image(uiImage: remoteimage.image!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                }
            } else {
                //placeholder
                //Image(uiImage: UIImage(imageLiteralResourceName: "Spartan"))
                ActivityIndicator(shouldAnimate: .constant(true))
            }
        }
        .onAppear{
            self.remoteimage.load(url: self.url)
        }
        .onDisappear{
            self.remoteimage.cancel()
        }
    }
}

struct TestImage_Previews: PreviewProvider {
    static let url = URL(string: "https://d2t51sxsanqkl5.cloudfront.net/eda01ed9-26e5-4996-899b-a362b46315d1")!
    static var previews: some View {
        TestImage(url: url)
    }
}

