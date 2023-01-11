import UIKit

protocol ImageNameProtocol {
    var imageName: String { get }
}

protocol ImageDataProtocol {
    var imageData: Data { get }
}

protocol ImageSaveProtocol {
    func save(to url: URL) throws
}

protocol ImageCompressionProtoctol {
    var base64Encoded: String { get }
}


class Image: ImageNameProtocol, ImageDataProtocol, ImageSaveProtocol, ImageCompressionProtoctol {
    var imageName: String
    var imageData: Data
    var name: String {
        return imageName
    }

    func save(to url: URL) throws {
        try self.imageData.write(to: url)
    }
    
    init(name: String, data: Data) {
        imageName = name
        imageData = data
    }
    
    convenience init(name: String, contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        self.init(name: name, data: data)
    }
    
    // compression
    convenience init?(named name: String, data: Data, compressionQuality: Double) {
        guard let image = UIImage.init(data: data) else { return nil }
        guard let jpegData = image.jpegData(compressionQuality: CGFloat(compressionQuality))
        else { return nil }
        self.init(name: name, data: jpegData)
    }
    
    // BASE64 encoding
    var base64Encoded: String {
        return imageData.base64EncodedString()
    }
}

// Test
var image = Image(name: "Pic", data: Data(repeating: 0, count: 100))
print(image.base64Encoded)

do {
    // persist image
    let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
    let imageURL = documentDirectory.appendingPathComponent("MyImage")
    try image.save(to: imageURL)
    print("Image saved successfully to path \(imageURL)")
    
    // load image from persistence
    let storedImage = try Image.init(name: "MyRestoredImage", contentsOf: imageURL)
    print("Image loaded successfully from path \(imageURL)")
} catch {
    print(error)
}

