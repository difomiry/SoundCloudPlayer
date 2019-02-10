
struct User: Codable {

  let id: Int
  let avatar: String
  let username: String

  enum CodingKeys: String, CodingKey {
    case id
    case avatar = "avatar_url"
    case username
  }

}
