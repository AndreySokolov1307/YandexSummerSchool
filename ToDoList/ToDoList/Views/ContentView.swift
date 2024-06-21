import SwiftUI

struct ContentView: View {
    
    let fileCache = FileCache()
    var body: some View {
        VStack {
           Text("To do")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
