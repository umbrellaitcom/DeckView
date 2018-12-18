//
//  ViewController.swift
//  DeckView
//
//  Created by AlekseyPakAA on 11/11/2018.
//  Copyright (c) 2018 AlekseyPakAA. All rights reserved.
//

import UIKit
import UMDeckView

class ViewController: UIViewController {

	@IBOutlet weak var deckView: DeckView!

    override func viewDidLoad() {
        super.viewDidLoad()
		setupDeckView()
        // Do any additional setup after loading the view, typically from a nib.
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		deckView.cardSize = {
			let verticalInset: CGFloat = 64.0
			let horizontalInset: CGFloat = 32.0

			let height = deckView.bounds.height - verticalInset * 2
			let width = deckView.bounds.width - horizontalInset * 2

			return CGSize(width: width, height: height)
		}()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Private
extension ViewController {

	func setupDeckView() {
		let nib = UINib(nibName: "MyCardView", bundle: nil)
		deckView.register(nib, forCardReuseIdentifier: "MyCardView")
		deckView.translatesAutoresizingMaskIntoConstraints = false
		deckView.dataSource = self
		deckView.reloadData()
	}

}

// MARK: - DeckViewDataSource
extension ViewController: DeckViewDataSource {

	func numberOfItems(in deckView: DeckView) -> Int {
		return 3
	}

	func deckView(_ deckView: DeckView, cardForCellAt index: Int) -> CardView {
		let card = deckView.dequeueReusableCard(withIdentifier: "MyCardView")
		card.backgroundColor = UIColor.random()
		return card
	}

}

extension UIColor {

	static func random() -> UIColor {
		let random = { CGFloat(arc4random_uniform(255)) / 255.0 }
		return UIColor(red: random(), green: random(), blue: random(), alpha: 1)
	}

}

