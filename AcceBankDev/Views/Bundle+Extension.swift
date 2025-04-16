import Foundation

private var bundleKey: UInt8 = 0

//final class CustomBundle: Bundle {
//    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
//        guard let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle else {
//            return super.localizedString(forKey: key, value: value, table: tableName)
//        }
//        return bundle.localizedString(forKey: key, value: value, table: tableName)
//    }
//}
final class CustomBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = objc_getAssociatedObject(self, &bundleKey) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}


extension Bundle {
    static func setLanguage(_ language: String) {
        object_setClass(Bundle.main, CustomBundle.self)
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            return
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
