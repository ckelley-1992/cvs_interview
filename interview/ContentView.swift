//
//  ContentView.swift
//  interview
//
//  Created by Connor Kelley on 10/9/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ImageEntry]
    @State private var keywordText = ""
    @State private var showDetail = false
    
    @State private var imageRef = ""
    @State private var imageDescription = ""
    @State private var imageTitle = ""
    @State private var imageAuthor = ""
    @State private var imageDate = Date(timeIntervalSince1970: 0)
    
    var body: some View {
        ZStack {
            VStack {
                SearchBarView(keywords: $keywordText).padding()
                ScrollView {
                    LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity))], spacing: 7) {
                        ForEach(items) { item in
                            AsyncImage(url: URL(string:item.imageRef),
                                       content: { image in
                                                image.resizable()
                                                .aspectRatio(1, contentMode: .fit)
                                                .frame(minWidth: 200, maxHeight: 200)
                                                .clipped()
                                                .aspectRatio(1, contentMode: .fill)
                                                .onTapGesture {
                                                    imageTitle = item.imageTitle
                                                    imageAuthor = item.imageAuthor
                                                    imageDescription = item.imageDescription
                                                    imageDate = item.dateTaken
                                                    imageRef = item.imageRef
                                                    showDetail.toggle()
                                                }
                                                .fullScreenCover(isPresented: $showDetail) {
                                                    DetailView(imageRef: imageRef,
                                                               imageDescription: imageDescription,
                                                               imageTitle: imageTitle,
                                                               imageAuthor: imageAuthor,
                                                               imageDate: imageDate)
                                                }
                                        },
                                       placeholder: { ProgressView() }
                            )
                        }.frame(maxWidth: 200, maxHeight: 200)
                    }
                }
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: ImageEntry.self, inMemory: true)
}
