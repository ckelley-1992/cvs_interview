//
//  Item.swift
//  interview
//
//  Created by Connor Kelley on 10/9/24.
//

import Foundation
import SwiftData

@Model
final class ImageEntry {
    var imageRef: String
    var imageTitle: String
    var imageDescription: String
    var imageAuthor: String
    var dateTaken: Date
        
    init(imageRef: String, imageTitle: String, imageDescription: String, imageAuthor: String, dateTaken: Date) {
        self.imageRef = imageRef
        self.imageTitle = imageTitle
        self.imageDescription = imageDescription
        self.imageAuthor = imageAuthor
        self.dateTaken = dateTaken
    }
}
