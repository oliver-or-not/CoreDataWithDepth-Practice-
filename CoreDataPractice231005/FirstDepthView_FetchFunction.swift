//
//  FirstDepthView_FetchFunction.swift
//  CoreDataPractice231005
//
//  Created by Wonil Lee on 10/6/23.
//

import CoreData
import SwiftUI

struct FirstDepthView_FetchFunction: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var note: Note
    @State private var subnoteArray = [Subnote]()
    
    init(note: Note) {
        self.note = note
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
                                SecondDepthView_FetchFunction(subnote: subnote)
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
        .onAppear {
            fetchSubnoteArray()
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
            fetchSubnoteArray()
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
        fetchSubnoteArray()
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
        fetchSubnoteArray()
    }
    
    func fetchSubnoteArray() {
        subnoteArray = (note.subnotes!.allObjects as! [Subnote]).sorted {
            ($0.name ?? "") <= ($1.name ?? "")
        }
    }
}

#Preview {
    FirstDepthView_FetchFunction(note: Note())
}
