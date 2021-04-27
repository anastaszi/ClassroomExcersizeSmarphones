//
//  ContentView.swift
//  Shared
//
//  Created by Anastasia Zimina on 4/24/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var catsData: [CatsData]
    
    @State private var showingAlert = false;
    @State private var showSheetView = false;
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void
    
    var alert: Alert {
        Alert(title: Text("Clicked"), message: Text("Thank you!"), dismissButton: .default(Text("Ok")))
    }
    
    var body: some View {
        NavigationView {
            List{
                ForEach(catsData) { cat in
                    NavigationLink(
                    
                        destination: CatDetails(cat: binding(for: cat)),
                        label: {
                            CatCellView(cat: cat)
                        })
                        
                //CatCellView(cat: cat)
                }.onDelete(perform: { indexSet in
                    print("Delete Row")
                    catsData.remove(atOffsets: indexSet)
                    saveAction()
                })
            }.navigationTitle("My Cats")
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {self.showingAlert.toggle()}, label: {
                            Image(systemName: "bell.circle.fill")
                        })
                        Button(action: {self.showSheetView.toggle()}, label: {
                            Image(systemName: "pencil.and.outline")
                        })
                    }
                }
                .alert(isPresented: $showingAlert, content: {
                self.alert
                })
                .sheet(isPresented: $showSheetView, content: {
                    AddCat(showSheetView: self.$showSheetView, catsData: $catsData)
                })
            .onChange(of: scenePhase, perform: { phase in
                if phase == .inactive {
                    saveAction() // external block
                }
            })
        }
    }
    
    private func binding(for cats: CatsData)  -> Binding<CatsData> {
        guard let catIndex = catsData.firstIndex(where: {$0.id == cats.id}) else {
            fatalError("Cannot find cat in the array")
        }
        return $catsData[catIndex];
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(catsData: .constant(CatsData.defaultData), saveAction: {})
    }
}

struct CatCellView: View {
    var cat: CatsData
    var body: some View {
        //NavigationLink(
            //destination: CatDetails(cat: cat)) {
            Image(uiImage: UIImage(imageLiteralResourceName: cat.photo!))
                .resizable()
                .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/67.6/*@END_MENU_TOKEN@*/)
            
            VStack(alignment: .leading) {
                Text(cat.title)
                    .font(.headline)
                    .padding(.leading)
                Text(cat.review ?? "hero")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
            }}
    //}
}
/*
struct ContentView: View {
    var catsData: [CatsData] = CatsData.defaultData
    
    @State private var showingAlert = false;
    
    var alert: Alert {
        Alert(title: Text("Clicked"), message: Text("Thank you!"), dismissButton: .default(Text("Ok")))
    }
    var body: some View {
        NavigationView {
            List(catsData) { cat in
                CatCellView(cat: cat)
            }.navigationTitle("My Cats")
            .navigationBarItems(trailing: Button(action: {self.showingAlert.toggle()}) {
                Image(systemName: "plus")
            })
            .alert(isPresented: $showingAlert, content: {
                self.alert
            })
        }
    }
}
 */
