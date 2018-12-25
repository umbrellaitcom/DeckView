# UMDeckView
`UMDeckView` is an easy-to-use Swift library that provides a deck of views that can be swiped any side (inspired by the Tinder app).

<img src="https://github.com/umbrellaitcom/DeckView/blob/master/Example/demo.gif" width="300">

[![Version](https://img.shields.io/cocoapods/v/UMDeckView.svg?style=flat)](http://cocoapods.org/pods/UMDeckView)
[![License](https://img.shields.io/cocoapods/l/UMDeckView.svg?style=flat)](http://cocoapods.org/pods/UMDeckView)
[![Platform](https://img.shields.io/cocoapods/p/UMDeckView.svg?style=flat)](http://cocoapods.org/pods/UMDeckView)

## Requirements

- iOS 10.0+
- Xcode 10.1


## Installation

### Manually

Clone this repo and manually add the source files to project.

### CocoaPods
If you are using [CocoaPods](https://cocoapods.org) just add in your podfile:

`pod 'UMDeckView'`

## Usage
1) Create a new view (from storyboard or programmatically) inheriting `DeckView` and add it on your view. Conform to `DeckViewDataSource` as you would with a `UITableView`, register nib containing subclass of CardView and set the view's data source. 
```swift
class ViewController: UIViewController, DeckViewDataSource {

    @IBOutlet weak var deckView: DeckView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register nib containing subclass of CardView
        let nib = UINib(nibName: "MyCardView", bundle: nil)
        deckView.register(nib, forCardReuseIdentifier: "MyCardView")


        // Set the deckView's delegate & data source.
        deckView.delegate = self
        deckView.dataSource = self
    }
}
```

2) Return the number of cards that you wish to add in the deck, as you would do with `UITableViewDataSource`.

```swift
func numberOfItems(in deckView: DeckView) -> Int {
    return 3
}
```

3) Create your cards as you would do with `UITableViewCell`. Your cards must inherit `CardView`.
```swift
func deckView(_ deckView: DeckView, cardForCellAt index: Int) -> CardView {
    let card = deckView.dequeueReusableCard(withIdentifier: "MyCardView")
    card.backgroundColor = UIColor.random()
    return card
}
```

### Features

For a detailed guide on how to use the features visit [here](http://bit.ly/1Y9qX10)

1) Throw a card any side

2) Infinite loop of cards

## Author

[UmbrellaIT](https://umbrellait.com), alexey.pak@umbrellait.com

## License

UMDeckView is available under the MIT license. See the LICENSE file for more info.
