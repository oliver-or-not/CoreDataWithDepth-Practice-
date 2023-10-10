//
//  SecondDepthView_FetchedResults.swift
//  CoreDataPractice231005
//
//  Created by Wonil Lee on 10/6/23.
//

import CoreData
import SwiftUI

struct SecondDepthView_FetchedResults: View {
    @Environment(\.managedObjectContext) var viewContext
    
    var subnote: Subnote
    
    @FetchRequest var subsubnoteArray: FetchedResults<Subsubnote>

    init(subnote: Subnote) {
        self.subnote = subnote
        
        let request: NSFetchRequest<Subsubnote> = Subsubnote.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Subsubnote.name, ascending: true)]
        request.predicate = NSPredicate(format: "subnote == %@", subnote)
        
        _subsubnoteArray = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 30)
                
                HStack {
                    Button {
                        addSubsubnote()
                    } label: {
                        Text("Add")
                    }
                    Spacer()
                        .frame(width: 50)
                    Button {
                        resetSubsubnoteArray()
                    } label: {
                        Text("Reset")
                    }
                }
                
                if subsubnoteArray.count > 0 {
                    List {
                        ForEach(subsubnoteArray, id: \.self) { subsubnote in
                            HStack {
                                Text(subsubnote.name ?? "")
                                Spacer()
                                Text("\(subsubnote.volume) pages")
                                    .font(.footnote)
                            }
                        }
                        .onDelete(perform: deleteSubsubnote)
                    }
                } else {
                    List(["List is empty."], id: \.self) { string in
                        HStack {
                            Spacer()
                            Text(string)
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Depth 2")
            .navigationBarTitleDisplayMode(.inline)
        }
    } 
    
    func addSubsubnote() {
            let tempSubsubnote = Subsubnote(context: viewContext)
            tempSubsubnote.name = "Subsubnote \(subsubnoteArray.count)"
            tempSubsubnote.volume = Int64.random(in: 50...500)
            subnote.addToSubsubnotes(tempSubsubnote)
            do {
                try viewContext.save()
            } catch {
                print("error while saving data: \(error.localizedDescription)")
            }
    }
    
    func deleteSubsubnote(at indexSet: IndexSet) {
        for index in indexSet {
            let tempSubsubnote = subsubnoteArray[index]
            subnote.removeFromSubsubnotes(tempSubsubnote)
            viewContext.delete(tempSubsubnote)
        }
        do {
            try viewContext.save()
        } catch {
            print("error while saving data: \(error.localizedDescription)")
        }
    }
    
    func resetSubsubnoteArray() {
        for subsubnote in subsubnoteArray {
            subnote.removeFromSubsubnotes(subsubnote)
            viewContext.delete(subsubnote)
        }
        do {
            try viewContext.save()
        } catch {
            print("error while saving data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SecondDepthView_FetchedResults(subnote: Subnote())
}
