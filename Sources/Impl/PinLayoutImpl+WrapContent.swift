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

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

extension PinLayout {
    public func wrapContent() -> PinLayout {
        return wrapContent(.all, padding: PEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), { return "wrapContent()" })
    }

    public func wrapContent(padding: CGFloat) -> PinLayout {
        return wrapContent(.all, padding: PEdgeInsets(top: padding, left: padding, bottom: padding, right: padding), { return "wrapContent(padding: \(padding)" })
    }
    
    public func wrapContent(padding: PEdgeInsets) -> PinLayout {
        return wrapContent(.all, padding: padding, { return "wrapContent(padding: \(insetsDescription(padding))" })
    }

    public func wrapContent(_ type: WrapType) -> PinLayout {
        return wrapContent(type, padding: PEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), { return "wrapContent(\(type.description)" })
    }

    public func wrapContent(_ type: WrapType, padding: CGFloat) -> PinLayout {
        return wrapContent(type, padding: PEdgeInsets(top: padding, left: padding, bottom: padding, right: padding), { return "wrapContent(\(type.description), padding: \(padding)" })
    }

    public func wrapContent(_ type: WrapType, padding: PEdgeInsets) -> PinLayout {
        return wrapContent(type, padding: padding, { return "wrapContent(\(type.description), padding: \(insetsDescription(padding))" })
    }

    private func wrapContent(_ type: WrapType, padding: PEdgeInsets, _ context: Context) -> PinLayout {
        guard let subviews = view.subviews as? [TLayoutable] else { return self }
        guard !subviews.isEmpty else { return self }

        let firstViewRect = subviews[0].getRect(keepTransform: keepTransform)
        let boundingRect = subviews.reduce(firstViewRect, { (result, view) in
            result.union(view.getRect(keepTransform: keepTransform))
        })

        var offsetDx: CGFloat = 0
        var offsetDy: CGFloat = 0

        if type == .all || type == .horizontally {
            let contentWidth = boundingRect.width + padding.left + padding.right
            if contentWidth >= 0 {
                setWidth(contentWidth, context)
            }

            offsetDx = -boundingRect.minX + padding.left
        }

        if type == .all || type == .vertically {
            let contentHeight = boundingRect.height + padding.top + padding.bottom
            if contentHeight >= 0 {
                setHeight(contentHeight, context)
            }

            offsetDy = -boundingRect.minY + padding.top
        }

        if offsetDx != 0 || offsetDy != 0 {
            subviews.forEach { (view) in
                let viewRect = view.getRect(keepTransform: keepTransform)
                let newRect = viewRect.offsetBy(dx: offsetDx, dy: offsetDy)
                view.setRect(newRect, keepTransform: keepTransform)
            }
        }

        return self
    }
}
