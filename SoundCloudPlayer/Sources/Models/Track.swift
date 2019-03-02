
struct Track: Codable {

  let id: Int
  let title: String
  let description: String?
  let genre: String?
  let duration: Int
  let artwork: String?
  let streamable: Bool?
  let downloadable: Bool?
  let user: User

  enum CodingKeys: String, CodingKey {
    case id
    case title
    case description
    case genre
    case duration
    case artwork = "artwork_url"
    case streamable
    case downloadable
    case user
  }

}
