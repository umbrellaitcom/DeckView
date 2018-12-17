//
//  DeckView.swift
//  DeckView
//
//  Created by Alexey Pak on 11/10/2018.
//  Copyright © 2018 alexey.pak. All rights reserved.
//

import UIKit

public protocol DeckViewDataSource: class {

    func numberOfItems(in deckView: DeckView) -> Int
    func deckView(_ deckView: DeckView, cardForCellAt index: Int) -> CardView

}

public class DeckView: UIView {

    weak var dataSource: DeckViewDataSource?

    var cardSize: CGSize = CGSize(width: 300.0, height: 400.0) {
        didSet {
            setNeedsLayout()
        }
    }

    var isLooped: Bool = true

    private(set) var maxNumberOfVisibleCards: Int = 3
    private(set) var countOfCards: Int = 0
    private(set) var currentCardIndex: Int?

    private var cardViews: [CardView] = []
    private var cardViewsPull: CardViewsPull = CardViewsPull()
    private var animator: UIViewPropertyAnimator?

	override public func layoutSubviews() {
        super.layoutSubviews()

        cardViews.enumerated().forEach { index, cardView in
			cardView.isUserInteractionEnabled = index == 0

            let frame = frameForCardAt(position: index)
            cardView.bounds = CGRect(origin: .zero, size: frame.size)
            cardView.center = CGPoint(x: frame.origin.x + frame.size.width / 2,
                                      y: frame.origin.y + frame.size.height / 2)

			let alpha = alphaForCardAt(position: index)
			cardView.alpha = alpha
        }
    }

    private func frameForCardAt(position: Int) -> CGRect {
        let size = cardSize

        let offset: CGFloat
        if position == maxNumberOfVisibleCards - 1 {
            offset = (CGFloat(position - 1) * 8.0)
        } else {
            offset = (CGFloat(position) * 8.0)
        }

        let originX = bounds.width / 2.0 - size.width / 2.0
        let originY = bounds.height / 2.0 - size.height / 2.0 + offset
        let origin = CGPoint(x: originX, y: originY)

        return CGRect(origin: origin, size: size)
    }

	func index(for cardView: CardView) -> Int? {
		guard let cardViewIndex = cardViews.firstIndex(of: cardView),
			let currentCardIndex = currentCardIndex else {

			return nil
		}

		var index: Int
		index = currentCardIndex + cardViewIndex
		if index >= countOfCards {
			index = countOfCards - index
		}

		return index
	}

	func getTopCard() -> CardView? {
		return cardViews.first
	}

	private func alphaForCardAt(position: Int) -> CGFloat {
		switch position {
		case 0:
			return 1.0
		case 1:
			return 0.6
		default:
			return 0.0
		}
	}

	override public func didMoveToSuperview() {
        super.didMoveToSuperview()
    }

	func shouldDrag(card: CardView) -> Bool {
		return countOfCards != 1
	}

    func didBeginDrag(card: CardView) {
        animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear, animations: {
            self.cardViews.enumerated().forEach { index, cardView in
                guard index != 0 else {
                    return
                }

                cardView.frame = self.frameForCardAt(position: index - 1)
				cardView.alpha = self.alphaForCardAt(position: index - 1)
            }
        })
    }

    func didDrag(card: CardView, dragPercent: CGFloat) {
        animator?.fractionComplete = dragPercent
    }

    func didEndDrag(card: CardView, shouldSwipe: Bool) {
        if !shouldSwipe {
            animator?.isReversed = true
        }

        animator?.startAnimation()
    }

    func didSwipe(card: CardView) {
        card.removeFromSuperview()
        cardViews.removeAll(where: { $0 == card })

        guard var currentCardIndex = self.currentCardIndex,
            let dataSource = dataSource else {

            return
        }

        let isLastCard = currentCardIndex == countOfCards - 1
        if isLooped && isLastCard {
            currentCardIndex = 0
        } else if !isLooped && isLastCard {
            return
        } else {
            currentCardIndex += 1
        }

        self.currentCardIndex = currentCardIndex

        let needLoadCardView = (currentCardIndex + cardViews.count) < countOfCards || isLooped

        if !needLoadCardView {
            setNeedsLayout()
            return
        }

        let index: Int  = {
            if isLooped {
                var index = currentCardIndex + cardViews.count
                if index >= countOfCards {
                    index -= countOfCards
                }

                return index
            } else {
                return currentCardIndex + cardViews.count
            }
        }()

        let card = dataSource.deckView(self, cardForCellAt: index)
        cardViews.append(card)
        insertSubview(card, at: 0)

		card.alpha = 0.0

		UIView.animate(withDuration: 0.23, animations: {
			self.layoutIfNeeded()
		})
    }

    func register(_ nib: UINib, forCardReuseIdentifier reuseIdentifier: String) {
        cardViewsPull.register(nib, forCardReuseIdentifier: reuseIdentifier)
    }

    func dequeueReusableCard(withIdentifier reuseIdentifier: String) -> CardView {
        return cardViewsPull.dequeueReusebleCard(withIdentifier: reuseIdentifier)
    }

    func reloadData() {
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()

		func dropState() {
			currentCardIndex = nil
			countOfCards = 0
		}

        guard let dataSource = dataSource else {
			dropState()
            return
        }

        let newCountOfCards = dataSource.numberOfItems(in: self)

		if newCountOfCards == 0 {
			dropState()
			return
		}

        let newCurrentCardIndex: Int = {
            guard let currentCardIndex = currentCardIndex else {
                return 0
            }

            if currentCardIndex < newCountOfCards {
                return currentCardIndex
            } else {
                return newCountOfCards - 1
            }
        }()

        currentCardIndex = newCurrentCardIndex
        countOfCards = newCountOfCards

        let numberOfVisibleCards: Int = {
            if isLooped {
                return min(newCountOfCards, maxNumberOfVisibleCards)
            } else {
                return min(newCountOfCards - newCurrentCardIndex, maxNumberOfVisibleCards)
            }
        }()

        var index = newCurrentCardIndex
        for _ in 0..<numberOfVisibleCards {
            if index >= newCountOfCards {
                index = 0
            }

            let card = dataSource.deckView(self, cardForCellAt: index)
            cardViews.append(card)
            insertSubview(card, at: 0)

            index += 1
        }

        setNeedsLayout()
    }

	public func swipeToCard(at index: Int) {
		currentCardIndex = index
		reloadData()
	}

}
