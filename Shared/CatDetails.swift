//
//  CatDetails.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/24/21.
//

import SwiftUI

struct CatDetails: View {
    @Binding var cat: CatsData
    @State private var zoomed = false;
    
    @StateObject var mapModel =  MapModel()
    @State private var isMapViewPresented = false
    var body: some View {
        VStack{
            Image(uiImage: UIImage(imageLiteralResourceName: cat.photo!))
                .resizable()
                .aspectRatio(contentMode: zoomed ? .fill : .fit)
                .edgesIgnoringSafeArea(.bottom)
                .onTapGesture {
                    withAnimation{
                        zoomed.toggle()
                    }
                }
            Text(cat.title)
                .padding(.all)
                .background(Color.green)
            Button(action: {
                mapModel.update(name: cat.title, coordinate: cat.coordinate)
                isMapViewPresented = true
            }, label: {Text("Show Map")
                
            })
        }.navigationTitle(cat.title)
        .fullScreenCover(isPresented: $isMapViewPresented, content: {
            NavigationView{
                MapView(mapModel: mapModel)
                    .navigationBarTitle(cat.title, displayMode: .inline)
                    .navigationBarItems(trailing: Button("Done"){
                        isMapViewPresented = false;
                    })
            }
        })
    }
}

struct CatDetails_Previews: PreviewProvider {
    static var previews: some View {
        CatDetails(cat: .constant(CatsData.defaultData[0]))
    }
}
