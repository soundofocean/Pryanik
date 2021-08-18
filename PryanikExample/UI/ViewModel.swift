import SwiftUI

class ViewModel: ObservableObject {
  
  /// Список всех View для нашего экрана
  @Published var viewContainers: [String] = []
  
  /// Текст для основного текстового блока
  @Published var mainText: String = ""
  
  /// Список вариантов для ... списка
  @Published var variants: [Variants] = []
  
  /// Изображение
  @Published var image: UIImage?
  
  /// Ссылка на изобаржения, для получения данных
  var imageUrlString: String = ""
  
  init() {
    
    // При инициализации View Model мы запрашиваем данные
    loadData { result in
      switch result {
      
      // В случае если данные успешно получены и "распарсены"
      // мы можем сделать запрос на получение данных об изображении
      case .success:
        self.loadImage()
      default: break
      } 
    }
  }
  
  /// Асинхронная загрузка данных с удалённого сервера
  /// - Parameter completion: Замыкающее сбегающее замыкание
  /// с результатами запроса к удалённому серверу
  func loadData(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
    
    // Ссылка на данные на удалённом сервере
    guard let url = URL(string: "https://pryaniky.com/static/json/sample.json") else {
      return completion(.failure(.badURL))
    }
    
    /// Объект запроса к удалённому серверу
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      
      if error != nil {
        
        // В случае ошибки вовзращаем замыкание с ошибкой
        completion(.failure(.decodeError))
      } else {
        
        
        /// Если запрос можно обработать
        if let response = response as? HTTPURLResponse {
          
          // Если код ответа от сервера - 200 (всё нормально)
          if response.statusCode == 200 {
            
            // Если данные в ответе присутствуют
            if let data = data {
              
              DispatchQueue.main.async {
                
                // Процесс превращения json-данных в объекты моделей
                let decodedResponse = try! JSONDecoder().decode(ReceivedData.self, from: data)
                
                self.viewContainers = decodedResponse.view
                
                self.mainText = decodedResponse.firstLevelData[0].secondLevelData.text ?? ""
                
                self.variants = decodedResponse.firstLevelData[2].secondLevelData.variants ?? []
                
                self.imageUrlString = decodedResponse.firstLevelData[1].secondLevelData.url ?? ""
                
                // Возвращаем успешное замыкание
                return completion(.success(true))
              }
            } else {
              
              return completion(.failure(.decodeError))
            }
          } else {
            
            completion(.failure(.requestFailed))
          }
          
        } else {
          completion(.failure(.requestFailed))
        }
        
      }
    }.resume()
  }
  
  /// Процесс загрузки изображения с удалённого сервера
  func loadImage() {
    
    // Ссылка на изображение с удалённого сервера
    guard let url = URL(string: imageUrlString) else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      
      // Проверка получения данных
      guard let data = data else { return }
      
      DispatchQueue.main.async {
        
        // Создание объекта изображения из полученных данных
        self.image = UIImage(data: data)
      }
    }.resume()
  }
}

/// Список ошибок запроса к серверу
enum NetworkError: Error {
  
  /// Ошибка преобразования String в URL
  case badURL
  
  /// Ошибка декодирования данных
  case decodeError
  
  /// Ошибка запроса
  case requestFailed
  
  /// Неизвестная ошибка
  case unknown
}
