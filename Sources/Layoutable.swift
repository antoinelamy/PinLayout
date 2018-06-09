//
//  Layoutable.swift
//  PinLayout-iOS
//
//  Created by Luc Dion on 2018-06-09.
//  Copyright © 2018 mcswiftlayyout.mirego.com. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

public protocol Layoutable: class, Equatable {
    associatedtype View

    var superview: View? { get }
    var subviews: [View] { get }

    var anchor: AnchorList { get }
    var edge: EdgeList { get }

    func getRect(keepTransform: Bool) -> CGRect
    func setRect(_ rect: CGRect, keepTransform: Bool)

    func sizeThatFits(_ size: CGSize) -> CGSize
    func convert(_ point: CGPoint, to view: View?) -> CGPoint

    func isLTR() -> Bool
}
