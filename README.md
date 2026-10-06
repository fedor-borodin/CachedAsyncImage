# CachedAsyncImage

A lightweight SwiftUI component for asynchronously loading and persistently caching remote images.

`CachedAsyncImage` downloads images using Swift Concurrency and `URLSession`, stores them in the app's caches directory, and reuses cached files on subsequent loads.

## Features

- SwiftUI-native API
- Asynchronous image loading with `async/await`
- Persistent disk caching
- URL-based cache keys
- Custom SwiftUI placeholder support
- No third-party dependencies
- Swift Package Manager support
- iOS 15+

## Installation

Add this repository as a Swift Package dependency in Xcode:

```
https://github.com/fedor-borodin/CachedAsyncImage
```

Then import the package:

```swift
import CachedAsyncImage
```

## Usage

```swift
CachedAsyncImage("https://example.com/image.jpg")
    .aspectRatio(contentMode: .fit)
```

A custom placeholder can be supplied using the trailing closure:

```swift
CachedAsyncImage("https://example.com/image.jpg") {
    ProgressView()
}
.aspectRatio(contentMode: .fit)
```

## How it works

When an image is requested, the package derives a cache filename from the image URL and first checks the app's caches directory. If the image is already cached, it is loaded from disk. Otherwise, it is downloaded with `URLSession`, stored in the cache, and then displayed.

The image loader is isolated to the main actor for UI state updates.

## Requirements

- iOS 15.0+
- Swift 5.8+

## License

No license has been specified for this project.
