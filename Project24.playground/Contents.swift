import UIKit

var str = "Hello, playground"
//for letter in str {
//    print("Letter is \(letter)\n")
//}

//print(str[str.index(str.startIndex, offsetBy: 4)])
//print(str[4])


//extension String {
//    subscript(i: Int) -> String {
//        return String(self[index(startIndex, offsetBy: i)])
//    }
//}
///////////////////////////////////////////////////////////////////////////
//let password = "1234567"
//password.hasPrefix("123")
//password.hasSuffix("567")
//
//
//extension String {
//    func deletePrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else {
//            return self
//        }
//        return String(self.dropFirst(prefix.count))
//    }
//    
//    func deleteSufix(_ sufix: String) -> String {
//        guard self.hasSuffix(sufix) else {
//            return self
//        }
//        return String(self.dropLast(sufix.count))
//    }
//}
//
//password.deleteSufix("567")
//password.deletePrefix("123")

///////////////////////////////////////////////////////////////////////////
//let whether = "it's going to rain"
//whether.capitalized
//
//extension String {
//    var capitalizedFirst: String {
//        guard let firstLetter = self.first else {
//            return ""
//        }
//        return firstLetter.uppercased() + self.dropFirst()
//    }
//}
//
//whether.capitalizedFirst


///////////////////////////////////////////////////////////////////////////
//let input = "Swift is like Object-c without C"
//input.contains("Swift")
//
//let languages = ["C", "Java", "Swift", "Ruby"]
//languages.contains("Swift")
//
//extension String {
//    func containsAny(of array: [String]) -> Bool {
//        for item in array {
//            if self.contains(item) {
//                return true
//            }
//        }
//        return false
//    }
//}
//
//input.containsAny(of: languages)
//
//languages.contains(where: languages.contains)

///////////////////////////////////////////////////////////////////////////
//let string = "This is a test string"

//let atributes: [NSAttributedString.Key: Any] = [
//    .foregroundColor: UIColor.black,
//    .backgroundColor: UIColor.red,
//    .font: UIFont.boldSystemFont(ofSize: 36)
//]
//let atributedString = NSMutableAttributedString(string: string, attributes: atributes)
//
//let atributedString = NSMutableAttributedString(string: string)
//atributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
//atributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
//atributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
//atributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
//atributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

/////////////////////////////////////////////////////////////////////////// chalange

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        }
        return String(prefix + self)
    }
    
    var isNumeric: Bool {
        guard (Double(self) != nil) else {
            return false
        }
        return true
    }
    
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

var pet = "pet"
pet.withPrefix("car")

pet.isNumeric
var numbar = "234.2352"
numbar.isNumeric

var s = "this\nis\na\ntest"
s.lines
