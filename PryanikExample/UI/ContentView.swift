import SwiftUI

/// Список всех возможных типов View, используемых на экране
enum ReceivedViewTypes: String {
  
  /// Текстовый блок
  case hz
  
  /// Список с возможностью выбора
  case selector
  
  /// Блок с изображением
  case picture
}

struct ContentView: View {
  
  /// Источник данных для экрана
  @ObservedObject private var viewModel = ViewModel()
  
  /// Якорь для селектора
  @State private var selectedItem: Int = 0
  
  var body: some View {
    
    // Перебираем список всех View, которые пришли к нам с удалённого сервера
    // и выводим на экран
    ForEach(viewModel.viewContainers, id: \.self) { view in
      
      if view == "hz" {
        textComponentView()
        
      } else if view == "selector" {
        
        selecttorComponentView()
        
      } else {
        
        imageComponentView()
      }
    }
  }
}


extension ContentView {
  
  /// Содержимое блока с текстом
  /// - Returns: Контейнет с текстом
  private func textComponentView() -> some View {
    Text(String(viewModel.mainText))
  }
}


extension ContentView {
  
  /// Содержимое блока со списком
  /// - Returns: Контейнер со списком
  private func selecttorComponentView() -> some View {
    
    VStack {
      Picker(selection: $selectedItem, label: Text("Picker"), content: {
        
        ForEach(viewModel.variants) { variant in
          Text(variant.text)
        }
      })
    }
  }
}


extension ContentView {
  
  /// Содержимое блока с изображением
  /// - Returns: Контейнер с изображением
  private func imageComponentView() -> some View {
    
    HStack {
      Image(uiImage: viewModel.image ?? UIImage(systemName: "leaf.fill")!)
        .resizable()
        .aspectRatio(contentMode: .fit)
    }
    .frame(width: 100, height: 100, alignment: .center)
    
  }
}
