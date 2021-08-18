import Foundation

/// Верхний уровень данных получаемых с удалённого сервера
struct ReceivedData: Codable, Identifiable {
  
  var id: String = UUID().uuidString
 
  var view: [String]
  
  var firstLevelData: [FirstLevelData]
  
  enum CodingKeys: String, CodingKey {
    case view
    case firstLevelData = "data"
  }
}

/// Средний уровень данных получаемых с удалённого сервера
struct FirstLevelData: Codable {
  var name: String
  var secondLevelData: SecondLevelData
  
  enum CodingKeys: String, CodingKey {
    case name
    case secondLevelData = "data"
  }
}

/// Самый глубокий уровень данных получаемых с сервера
struct SecondLevelData: Codable {
  var url: String?
  var text: String?
  var selectedId: Int?
  var variants: [Variants]?
}

struct Variants: Identifiable, Codable {
  var id: Int
  var text: String
}

// https://pryaniky.com/static/json/sample.json

//{
//  "data": [
//    {
//      "name": "hz",
//      "data": {
//        "text": "Текстовый блок"
//      }
//    },
//    {
//      "name": "picture",
//      "data": {
//        "url": "https://pryaniky.com/static/img/logo-a-512.png",
//        "text": "Пряники"
//      }
//    },
//    {
//      "name": "selector",
//      "data": {
//        "selectedId": 1,
//        "variants": [
//          {
//            "id": 1,
//            "text": "Вариант раз"
//          },
//          {
//            "id": 2,
//            "text": "Вариант два"
//          },
//          {
//            "id": 3,
//            "text": "Вариант три"
//          }
//        ]
//      }
//    }
//  ],
//  "view": [
//    "hz",
//    "selector",
//    "picture",
//    "hz"
//  ]
//}
