import Foundation

// MARK: - Characters

struct Characters: Codable {
    let data: CharacterResults?
    let attributionText: String
}

// MARK: - Result

struct  CharacterResults: Codable {
    let results: [Character]?
}

// MARK: - Character

struct Character: Codable {
    let name: String
    let thumbnail: Thumbnail?
    let resourceURI: String
    let series: SeriesResult?

    enum CodingKeys: String, CodingKey {
        case name, thumbnail, resourceURI, series
    }
}

// MARK: - Thumbnail

struct Thumbnail: Codable {
    let path, thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - Series

struct SeriesResult: Codable {
    let items: [Items]?
}

// MARK: - Items

struct Items: Codable {
    let name: String
    let resourceURI: String
}
