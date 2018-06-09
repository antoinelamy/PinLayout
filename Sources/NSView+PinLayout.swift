//  Copyright (c) 2018 Luc Dion
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

#if os(macOS)
import AppKit
//
//public protocol Layoutable: AnyObject, Equatable {
//    associatedtype View
//
//    var superview: View? { get }
//    var subviews: [View] { get }
//
//    var anchor: AnchorList { get }
//    var edge: EdgeList { get }
//
//    func getRect(keepTransform: Bool) -> CGRect
//    func setRect(_ rect: CGRect, keepTransform: Bool)
//
//    func sizeThatFits(_ size: CGSize) -> CGSize
//    func convert(_ point: CGPoint, to view: View?) -> CGPoint
//
//    func isLTR() -> Bool
//}

import AppKit

extension NSView: Layoutable {
//    var superview: NSView? {
//        return nil
//    }
//
//    var subviews: [NSView] {
//        return []
//    }

    public var anchor: AnchorList {
        return AnchorListImpl(view: self)
    }

    public var edge: EdgeList {
        return EdgeListImpl(view: self)
    }

    public var pin: PinLayout<NSView> {
        return PinLayout(view: self, keepTransform: true)
    }

    public var pinFrame: PinLayout<NSView> {
        return PinLayout(view: self, keepTransform: false)
    }

    public static func == (lhs: NSView, rhs: NSView) -> Bool {
        return lhs == rhs
    }

// Expose PinLayout's objective-c interface.
//    @objc public var pinObjc: PinLayoutObjC {
//        return PinLayoutObjCImpl(view: self, keepTransform: true)
//    }

    public func sizeThatFits(_ size: CGSize) -> CGSize {
        return .zero
    }

//    func convert(_ point: CGPoint, to view: View?) -> CGPoint
//    func convert(_ point: CGPoint, to view: NSView?) -> CGPoint {
//        return .zero
//    }

    public func getRect(keepTransform: Bool) -> CGRect {
        if let superview = superview, !superview.isFlipped {
            var flippedRect = frame
            flippedRect.origin.y = superview.frame.height - flippedRect.height - flippedRect.origin.y
            return flippedRect
        } else {
            return frame
        }
    }

    public func setRect(_ rect: CGRect, keepTransform: Bool) {
        let adjustedRect = DisplayScale.adjustRectToDisplayScale(rect)

        if let superview = superview, !superview.isFlipped {
            var flippedRect = adjustedRect
            flippedRect.origin.y = superview.frame.height - flippedRect.height - flippedRect.origin.y
            frame = flippedRect
        } else {
            frame = adjustedRect
        }
    }

    public func isLTR() -> Bool {
        switch Pin.layoutDirection {
        case .auto: return self.userInterfaceLayoutDirection == .leftToRight
        case .ltr:  return true
        case .rtl:  return false
        }
    }
}

#endif
