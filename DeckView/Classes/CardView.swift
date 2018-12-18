//
//  CardView.swift
//  KolodaView
//
//  Created by Alexey Pak on 25/10/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation
import UIKit
import pop

open class CardView: UIView {

    fileprivate var deckView: DeckView? {
        return superview as? DeckView
    }

	public init() {
        super.init(frame: .zero)

        setup()
    }

	public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

}

fileprivate extension CardView {

    //center of view including transform
    var currentCenter: CGPoint {
        var center = frame.origin
        center.x += frame.size.width / 2
        center.y += frame.size.height / 2

        return center
    }

    var dragPercent: CGFloat {
        let dragDistance = currentCenter.distanceTo(center)
        return min(dragDistance / (frame.width / 3), 1.0)
    }

    func setup() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender: )))
		recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }

    @objc func didPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)

		switch sender.state {
		case .began:
			deckView?.didBeginDrag(card: self)
		case .changed:
			var transform = CATransform3DIdentity

			let dragDistance = currentCenter.x - center.x
			let rotationAngle = CGFloat.pi / 6.0 * min(dragDistance / (frame.width), 1.0)
			transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
			transform = CATransform3DTranslate(transform, translation.x, translation.y, 0)

			layer.transform = transform

			deckView?.didDrag(card: self, dragPercent: dragPercent)
		case .ended, .cancelled:
			let velocity = sender.velocity(in: self)

			let vectorDirection = CGPoint(x: center.x - currentCenter.x, y: center.y - currentCenter.y)
			let validDirection = (vectorDirection.x * velocity.x) < 0
									&& (vectorDirection.y * velocity.y) < 0

			var shouldSwipe = velocity.distanceTo(.zero) >= 500.0 || dragPercent == 1.0
			if shouldSwipe && validDirection {
				swipeCard(animated: true, velocity: velocity)
				shouldSwipe = true
			} else {
				resetPosition(animated: true)
			}

			deckView?.didEndDrag(card: self, shouldSwipe: shouldSwipe && validDirection)
		default:
			break
		}
    }

	func swipeCard(animated: Bool, velocity: CGPoint) {

        guard let deckView = deckView else {
            resetPosition(animated: animated)
            return
        }

         guard let finalCenter: CGPoint = {
			let vector = (center, currentCenter)

            var path = deckView.bounds

            path.size.width += frame.width
            path.size.height += frame.height

            path.origin.x -= frame.width / 2.0
            path.origin.y -= frame.height / 2.0

            let topLeft = path.origin
            let topRight = CGPoint(x: path.origin.x + path.width, y: path.origin.y)
            let bottomRight = CGPoint(x: path.origin.x + path.width, y: path.origin.y + path.height)
            let bottomLeft = CGPoint(x: path.origin.x, y: path.origin.y + path.height)

            let top = (topLeft, topRight)
            let left = (topRight, bottomRight)
            let bottom = (bottomRight, bottomLeft)
            let right = (bottomLeft, topLeft)

            let topIntersection = CGPoint.intersectionBetweenLines(vector, line2: top)
            let leftIntersection = CGPoint.intersectionBetweenLines(vector, line2: left)
            let bottomIntersection = CGPoint.intersectionBetweenLines(vector, line2: bottom)
            let rightIntersection = CGPoint.intersectionBetweenLines(vector, line2: right)

            let intersections = [topIntersection, leftIntersection,
                                 bottomIntersection, rightIntersection]

            let nearest = intersections.compactMap { return $0 }.min { lhs, rhs in
                let distanceToLhs = currentCenter.distanceTo(lhs)
                let distanceToRhs = currentCenter.distanceTo(rhs)

                return distanceToLhs < distanceToRhs
            }

            return nearest
        }() else {
            resetPosition(animated: animated)
            return
        }

        var finalOrigin = finalCenter
        finalOrigin.x -= deckView.frame.width / 2.0
        finalOrigin.y -= deckView.frame.height / 2.0

		let translationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY)
		translationAnimation?.duration = 0.35
		translationAnimation?.fromValue = NSValue(cgPoint: POPLayerGetTranslationXY(layer))
		translationAnimation?.toValue = NSValue(cgPoint: finalOrigin)
		translationAnimation?.completionBlock = { _, _ in
			deckView.didSwipe(card: self)
		}
		layer.pop_add(translationAnimation, forKey: "swipeTranslationAnimation")
    }

    func resetPosition(animated: Bool) {
        let options: AnimationOptions = [.curveEaseOut, .allowUserInteraction]
        UIView.animate(withDuration: animated ? 0.23 : 0.0, delay: 0.0, options: options, animations: {
            self.transform = .identity
        })
    }

}

extension CardView: UIGestureRecognizerDelegate {

	open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if !(deckView?.shouldDrag(card: self) ?? false) {
			return false
		}

		return super.gestureRecognizerShouldBegin(gestureRecognizer)
	}

}
