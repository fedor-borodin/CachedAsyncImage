import XCTest
@testable import CachedAsyncImage

final class CachedAsyncImageTests: XCTestCase {

    func testSameURLProducesSameCacheFilename() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/images/photo.jpg"))

        XCTAssertEqual(url.toFileName(), url.toFileName())
    }

    func testDifferentURLsProduceDifferentCacheFilenames() throws {
        let firstURL = try XCTUnwrap(URL(string: "https://example.com/images/first.jpg"))
        let secondURL = try XCTUnwrap(URL(string: "https://example.com/images/second.jpg"))

        XCTAssertNotEqual(firstURL.toFileName(), secondURL.toFileName())
    }

    func testCacheFilenameDoesNotContainURLPathSeparators() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com/images/photo.jpg"))

        XCTAssertFalse(url.toFileName().contains("/"))
    }
}
