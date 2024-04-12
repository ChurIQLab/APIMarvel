import Foundation

struct APIConfig {
    static let publicKey = "b451b8ec0d74a130bbc44bff9b41e7a0"
    static let privateKey = "b27da1936beedfcc3d727be8393339edfdb76ceb"
    static let ts = 1
    static var hash: String {
        return (String(ts) + privateKey + publicKey).md5
    }
}
