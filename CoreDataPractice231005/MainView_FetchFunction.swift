//
//  MainView_FetchFunction.swift
//  CoreDataPractice231005
//
//  Created by Wonil Lee on 10/5/23.
//

import CoreData
import SwiftUI

struct MainView_FetchFunction: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State var noteArray = [Note]()
    
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
                                FirstDepthView_FetchFunction(note: note)
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
        .onAppear {
            fetchNoteArray()
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
        fetchNoteArray()
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
        fetchNoteArray()
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
        fetchNoteArray()
    }
    
    func fetchNoteArray() {
        do {
            noteArray = try viewContext.fetch(Note.fetchRequest())
            return
        } catch {
            print("error fetching Note: \(error.localizedDescription)")
        }
        noteArray = [Note]()
    }
}

#Preview {
    MainView_FetchFunction()
}
