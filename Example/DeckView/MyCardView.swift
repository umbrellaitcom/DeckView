//
//  MyCardView.swift
//  DeckView_Example
//
//  Created by Alexey Pak on 18/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UMDeckView

class MyCardView: CardView {

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		translatesAutoresizingMaskIntoConstraints = false
	}

}
