//
//  CardViewsPull.swift
//  KolodaView
//
//  Created by Alexey Pak on 03/11/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import Foundation
import UIKit

class CardViewsPull {

    private var nibs: [String: UINib] = [:]
    private var views: [String: [CardView]] = [:]

    init() {

    }

    fileprivate func makeView(withIdentifier reuseIdentifier: String) -> CardView {
        let view = nibs[reuseIdentifier]?.instantiate(withOwner: nil, options: nil).first
        guard let cardView = view as? CardView else {
            fatalError("Unable to dequeue reusable card with reuse identifier: \(reuseIdentifier)")
        }

        return cardView
    }

    func dequeueReusebleCard(withIdentifier reuseIdentifier: String) -> CardView {
        if let view = (views[reuseIdentifier]?.first { $0.superview == nil }) {
            view.transform = .identity
            return view
        } else {
            let view = makeView(withIdentifier: reuseIdentifier)
            if views[reuseIdentifier] != nil {
                views[reuseIdentifier]?.append(view)
            } else {
                views[reuseIdentifier] = [view]
            }

            return view
        }
    }

    func register(_ nib: UINib, forCardReuseIdentifier reuseIdentifier: String) {
        nibs[reuseIdentifier] = nib
    }

}
