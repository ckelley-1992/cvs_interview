//
//  DetailView.swift
//  interview
//
//  Created by Connor Kelley on 10/10/24.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    var imageRef = ""
    var imageDescription = ""
    var imageTitle = ""
    var imageAuthor = ""
    var imageDate = Date(timeIntervalSince1970: 0)
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color(.systemBackground))
                .shadow(radius: 3)
                .overlay(
                    VStack {
                        Text(imageTitle)
                        AsyncImage(url: URL(string:imageRef),
                                   content: { image in
                            image.resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(minWidth: 200, maxHeight: 200)
                                .clipped()
                                .aspectRatio(1, contentMode: .fill)
                        },
                                   placeholder: { ProgressView() }
                        ).onTapGesture {
                            dismiss()
                        }
                        HStack {
                            Text(imageAuthor)
                            Text(imageDate.formatted(date: .abbreviated, time: .omitted))
                        }
                        Spacer()
                        Text(imageDescription)
                        ShareLink(items: [imageRef], subject: Text("Check out this image!")) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                )
                .padding(25)
        }
    }
}


#Preview {
    let previewEntry = ImageEntry(imageRef: "https://live.staticflickr.com/7064/6953057301_7391724bf0_m.jpg",
                                  imageTitle: "Picture of a dog",
                                  imageDescription: "This is an image of a dog",
                                  imageAuthor: "ckelley",
                                  dateTaken: Date(timeIntervalSince1970:0))
    DetailView(imageRef: previewEntry.imageRef,
               imageDescription: previewEntry.imageDescription,
               imageTitle: previewEntry.imageTitle,
               imageAuthor: previewEntry.imageAuthor,
               imageDate: previewEntry.dateTaken)
}
