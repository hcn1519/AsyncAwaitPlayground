import UIKit

struct Gallery {
    static let photos = [
        "Spring": ["Flower", "Warm"],
        "Summer": ["Beach", "Hot"]
    ]

    static let imageNames = photos.values.flatMap { $0.map { $0 } }
}

enum Old {
    static func listPhotos(inGallery gallery: String,
                           completion: @escaping ([String]) -> Void) {
        if let photos = Gallery.photos[gallery] {
            completion(photos)
        }
    }
    
    static func downloadPhoto(named name: String,
                              completion: @escaping (String?) -> Void) {
        guard let imageName = Gallery.imageNames.first(where: {$0 == name }) else{
            completion(nil)
            return
        }
        completion(imageName)
    }

    class GalleryProvider {
        class func show(name: String?) {
            print(name!)
        }

        class func getPhotos(inGallery: String, completion: @escaping (String?) -> Void) {
            Old.listPhotos(inGallery: inGallery) { photoNames in
                let sortedNames = photoNames.sorted()
                let name = sortedNames[0]
                Old.downloadPhoto(named: name) { photo in
                    Self.show(name: photo)
                    completion(photo)
                }
            }
        }
    }
}

class New {
    static func listPhotos(inGallery gallery: String) async -> [String] {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        return Gallery.photos[gallery] ?? []
    }

    static func downloadPhoto(named name: String) async -> String? {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        return Gallery.imageNames.first(where: {$0 == name })
    }

    class GalleryProvider {
        class func show(name: String?) {
            print(name!)
        }

        class func getPhotos(inGallery: String) async -> String? {
            let photoNames: [String] = await New.listPhotos(inGallery: inGallery)
            let sortedNames = photoNames.sorted()
            let name = sortedNames[0]
            let photo = await New.downloadPhoto(named: name)
            show(name: photo)
            return photo
        }
    }
}

// Usage
Old.GalleryProvider.getPhotos(inGallery: "Summer") { photo in
    print("photo:", photo!)
}

Task(priority: .medium) {
    let photo = await New.GalleryProvider.getPhotos(inGallery: "Summer")
    print("photo:", photo!)
}
