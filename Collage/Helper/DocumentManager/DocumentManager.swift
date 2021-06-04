//
//  DocumentManager.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import Foundation


struct DocumentManager {

    private let configuration: Configuration

    init(configuration: Configuration) {
        self.configuration = configuration
    }

    var documentDirectory: URL? = {
        
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }()

    func fileUrls() -> [Int: URL] {
        guard let documentDirectory = documentDirectory else {
            return [:]
        }
        var dictionary: [Int: URL] = [:]

        filesUrls(in: documentDirectory)
            .filter { url in
                guard url.isFileURL,
                      let data = try? Data(contentsOf: url),
                      let mime = Document.MimeType(pattern: data) else {
                    return false
                }
                return configuration.searchingTypes.contains(mime)
            }
            .enumerated()
            .forEach { (index, url) in
                dictionary[index] = url
            }

        return dictionary
    }

//    func files() -> [Document] {
//        guard let documentDirectory = documentDirectory else {
//            return []
//        }
//        return filesUrls(in: documentDirectory)
//            .compactMap {
//                let name = $0.lastPathComponent
//                guard let data = try? Data(contentsOf: $0),
//                      let mime = Document.MimeType(pattern: data),
//                      !name.isEmpty else {
//                    return nil
//                }
//                return Document(name: name, mimeType: mime, payload: data)}
//    }

    private func filesUrls(in directory: URL) -> [URL] {

        let contents = (try? FileManager.default.contentsOfDirectory(at: directory,
                                                                    includingPropertiesForKeys: nil,
                                                                    options: [])) ?? []

        return (contents + contents.flatMap { filesUrls(in: $0) })
    }

}

