import SwiftUI

public struct CachedAsyncImage<Content: View>: View {
    
    private let path: String?
    private let placeholder: Content
    @StateObject private var loader = CachedAsyncImageImageLoader()
    
    init(path: String?,
         @ViewBuilder placeholder: @escaping () -> Content = { ProgressView() })
    {
        self.path = path
        self.placeholder = placeholder()
    }
    
    public var body: some View {
        ZStack {
            if let image = loader.uiImage {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder
            }
        }
        .task {
            await downloadImage()
        }
    }
    
    private func downloadImage() async {
        do {
            try await loader.loadImage(from: path)
        } catch {
            print(error)
        }
    }
}
