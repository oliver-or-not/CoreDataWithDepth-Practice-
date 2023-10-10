//
//  FirstDepthView_FetchedResults.swift
//  CoreDataPractice231005
//
//  Created by Wonil Lee on 10/6/23.
//

import CoreData
import SwiftUI

struct FirstDepthView_FetchedResults: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var note: Note
    
    @FetchRequest var subnoteArray: FetchedResults<Subnote>

    init(note: Note) {
        self.note = note
        
        let request: NSFetchRequest<Subnote> = Subnote.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Subnote.name, ascending: true)]
        request.predicate = NSPredicate(format: "note == %@", note)
        
        _subnoteArray = FetchRequest(fetchRequest: request)
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 30)
                
                HStack {
                    Button {
                        addSubnote()
                    } label: {
                        Text("Add")
                    }
                    Spacer()
                        .frame(width: 50)
                    Button {
                        resetSubnoteArray()
                    } label: {
                        Text("Reset")
                    }
                }
                
                if subnoteArray.count > 0 {
                    List {
                        ForEach(subnoteArray, id: \.self) { subnote in
                            NavigationLink {
                                SecondDepthView_FetchedResults(subnote: subnote)
                            } label: {
                                HStack {
                                    Text(subnote.name ?? "")
                                    Spacer()
                                    Text("\(subnote.volume) pages")
                                        .font(.footnote)
                                }
                            }
                        }
                        .onDelete(perform: deleteSubnote)
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
            .navigationTitle("Depth 1")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func addSubnote() {
            let tempSubnote = Subnote(context: viewContext)
            tempSubnote.name = "Subnote \(subnoteArray.count)"
            tempSubnote.volume = Int64.random(in: 50...500)
            note.addToSubnotes(tempSubnote)
            do {
                try viewContext.save()
            } catch {
                print("error while saving data: \(error.localizedDescription)")
            }
    }
    
    func deleteSubnote(at indexSet: IndexSet) {
        for index in indexSet {
            let tempSubnote = subnoteArray[index]
            note.removeFromSubnotes(tempSubnote)
            viewContext.delete(tempSubnote)
        }
        do {
            try viewContext.save()
        } catch {
            print("error while saving data: \(error.localizedDescription)")
        }
    }
    
    func resetSubnoteArray() {
        for subnote in subnoteArray {
            note.removeFromSubnotes(subnote)
            viewContext.delete(subnote)
        }
        do {
            try viewContext.save()
        } catch {
            print("error while saving data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    FirstDepthView_FetchedResults(note: Note())
}
