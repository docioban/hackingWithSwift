import UIKit

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

extension Int {
    func times(_ closure: () -> Void) {
        guard self < 0 else {
            return
        }
        for _ in 0..<self {
            closure()
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        guard let index = self.firstIndex(of: item) else { return }
        guard let index2 = self.lastIndex(of: item) else { return }
        if index < index2 {
            self.remove(at: index)
        }
    }
}

let view = UIView()
view.bounceOut(duration: 3)

5.times {
    print("Hello\n")
}

var items = [1, 2, 3, 4, 5, 3]
items.remove(item: 3)
