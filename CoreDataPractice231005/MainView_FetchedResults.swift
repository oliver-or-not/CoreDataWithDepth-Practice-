//
//  MainView_FetchedResults.swift
//  CoreDataPractice231005
//
//  Created by Wonil Lee on 10/5/23.
//

import CoreData
import SwiftUI

struct MainView_FetchedResults: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.name, ascending: true)]
    )
    var noteArray: FetchedResults<Note>
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 30)
                
                HStack {
                    Button {
                        addNote()
                    } label: {
                        Text("Add")
                    }
                    Spacer()
                        .frame(width: 50)
                    Button {
                        resetNoteArray()
                    } label: {
                        Text("Reset")
                    }
                }
                
                if noteArray.count > 0 {
                    List {
                        ForEach(noteArray, id: \.self) { note in
                            NavigationLink {
                                FirstDepthView_FetchedResults(note: note)
                            } label: {
                                HStack {
                                    Text(note.name ?? "")
                                    Spacer()
                                    Text("\(note.volume) pages")
                                        .font(.footnote)
                                }
                            }
                        }
                        .onDelete(perform: deleteNote)
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
            .navigationTitle("Main")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func addNote() {
        let tempNote = Note(context: viewContext)
        tempNote.name = "Note \(noteArray.count)"
        tempNote.volume = Int64.random(in: 50...500)
        do {
            try viewContext.save()
        } catch {
            print("error while saving data: \(error.localizedDescription)")
        }
    }
    
    func deleteNote(at indexSet: IndexSet) {
        for index in indexSet {
            viewContext.delete(noteArray[index])
        }
        do {
            try viewContext.save()
        } catch {
            print("error while saving data: \(error.localizedDescription)")
        }
    }
    
    func resetNoteArray() {
        for note in noteArray {
            viewContext.delete(note)
        }
        do {
            try viewContext.save()
        } catch {
            print("error while saving data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    MainView_FetchedResults()
}
