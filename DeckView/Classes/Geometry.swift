//
//  Geometry.swift
//  KolodaView
//
//  Created by Alexey Pak on 26/10/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation
import UIKit
import Foundation

// MARK: - Geometry
extension CGPoint {
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }

    static func intersectionBetweenLines(_ line1: CGLine, line2: CGLine) -> CGPoint? {
        let (point1, point2) = line1
        let (point3, point4) = line2

		// swiftlint:disable identifier_name
        var d = (point4.y - point3.y) * (point2.x - point1.x) - (point4.x - point3.x) * (point2.y - point1.y)
        var ua = (point4.x - point3.x) * (point1.y - point4.y) - (point4.y - point3.y) * (point1.x - point3.x)
        var ub = (point2.x - point1.x) * (point1.y - point3.y) - (point2.y - point1.y) * (point1.x - point3.x)

		if d < 0 {
            ua = -ua; ub = -ub; d = -d
        }

        if d != 0 {
            return CGPoint(x: point1.x + ua / d * (point2.x - point1.x),
						   y: point1.y + ua / d * (point2.y - point1.y))
        }
		// swiftlint:enable identifier_name

        return nil
    }
}

typealias CGLine = (start: CGPoint, end: CGPoint)
