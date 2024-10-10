//
//  SearchBar.swift
//  interview
//
//  Created by Connor Kelley on 10/9/24.
//

import SwiftUI

public struct SearchBarView: View {
    @Binding var keywords: String
    @State var editing: Bool = false
    @Environment(\.modelContext) private var modelContext
    public var body: some View
    {
        HStack
        {
            TextField("Keywords", text: $keywords, onEditingChanged: searchKeywords)
                .cornerRadius(5)
                .padding(7)
                .frame(height: 25)
                .background(Color(.systemGray5))
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.editing = true
                }
                .onChange(of: keywords) {
                    searchKeywords(changed: true)
                }
            Button(action: clearSearch) {
                Text("Clear")
            }
            .padding()
        }
    }
    
    private func clearSearch()
    {
        debugPrint("Clear pressed")
        self.editing = false
        $keywords.wrappedValue = ""
        UIApplication.shared.resignFirstResponder()
    }
    
    // Sanitize the search terms by stripping out spaces and commas before reconstructing
    private func searchKeywords(changed: Bool)
    {
        if !changed
        {
            self.editing = false
            $keywords.wrappedValue = ""
            UIApplication.shared.resignFirstResponder()
        }
        
        if $keywords.wrappedValue.isEmpty
        {
            return
        }
        var sanitizedSearchTerms = ""
        for searchTerm in $keywords.wrappedValue.split(separator: /[ ,]+/)
        {
            if searchTerm.isEmpty
            {
                continue
            }
            if sanitizedSearchTerms.isEmpty
            {
                sanitizedSearchTerms = String(searchTerm)
            }
            else
            {
                sanitizedSearchTerms.append(",\(searchTerm)")
            }
        }
        debugPrint("Searching Flickr for \(sanitizedSearchTerms)")
        FlickrProvider.shared.fetchImages(from:String(sanitizedSearchTerms), completionHandler: onResponseReceived(response:))
    }
    
    private func onResponseReceived(response: NSDictionary)
    {
        debugPrint(response)
        for result in response["items"] as! [NSDictionary]
        {
            print(result)
            let imageRef = result["media"] as! NSDictionary
            var date = Date(timeIntervalSinceReferenceDate:0)
            if let dateString = result["date_taken"] as? String
            {
                date = ISO8601DateFormatter().date(from: dateString)!
            }
            let newEntry =  ImageEntry(imageRef: imageRef["m"] as! String,
                                       imageTitle: result["title"] as! String,
                                       imageDescription: result["description"] as! String,
                                       imageAuthor: result["author"] as! String,
                                       dateTaken: date)
            DispatchQueue.main.async {
                self.addResult(entry: newEntry)
            }
        }
    }
    
    private func addResult(entry: ImageEntry)
    {
        withAnimation {
            modelContext.insert(entry)
        }
    }
}

#Preview {
    SearchBarView(keywords: .constant("Porcupine"), editing: false)
}
