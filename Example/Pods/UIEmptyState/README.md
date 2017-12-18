![banner](https://raw.githubusercontent.com/luispadron/UIEmptyState/master/GitHubAssets/banner.jpg)

<img src="https://raw.githubusercontent.com/luispadron/UIEmptyState/master/GitHubAssets/screen1.jpg" width="280"><img src="https://raw.githubusercontent.com/luispadron/UIEmptyState/master/GitHubAssets/screen2.jpg" width="280"><img src="https://raw.githubusercontent.com/luispadron/UIEmptyState/master/GitHubAssets/screen3.jpg" width="280">



## Requirements

- Xcode 9.0 +
- iOS 9.0 or greater


## Installation

### CocoaPods

1. Install [CocoaPods](http://cocoapods.org)
2. Add this repo to your `Podfile`

```ruby
target 'Example' do
  use_frameworks!
	
  pod 'UIEmptyState'
end
```

3. Run `pod install`
4. Open up the new `.xcworkspace` that CocoaPods generated
5. Whenever you want to use the library: `import UIEmptyState`

### Carthage

1. Make sure Carthage is install

	`brew install carthage`
2. Add this repo to your Cartfile

	`github "luispadron/UIEmptyState"`
	

### Manually

1. Simply download the `UIEmptyState` source files and import them into your project.


## Usage

As long as you are using a `UIViewController` subclass you will get default conformance as well as the `reloadEmptyState` method.

```swift
// No subclassing required, simply conform to the two protocols
class ViewController: UITableViewController, UIEmptyStateDataSource, UIEmptyStateDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the data source and delegate
        self.emptyStateDataSource = self
        self.emptyStateDelegate = self
        // Optionally remove seperator lines from empty cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
   }
   
   override func viewDidAppear(_ animated: Bool) {
   	super.viewDidAppear(animated)
	// Set the initial state of the tableview, called here because cells should be done loading by now
	// Number of cells are used to determine if the view should be shown or not
	self.reloadEmptyState()
   }
}
```

Whenever you need to reload the empty state view for example, on data changes to your table view source, make sure to call `self.reloadEmptyState()` if inside a `UITableViewController` or `UICollectionViewController`. If inside a regular `UIViewController` make sure to call the appropriate `reloadEmptyStateForTableView(_:)` or `reloadEmptyStateForCollectionView(_:)` methods.

Example: 

```swift
// Inside a UITableViewController subclass

func foo() {
	// My data has changed here, I want to my tableview, 
	// and in case I no longer have data (user deleted, etc) also reload empty view
	self.tableView.reloadData()
	// Reload empty view as well
	self.reloadEmptyState()
}

func deleteFoo() {
	// This works too, just call after end updates
	tableView.beginUpdates()
	fooSource.remove(at: indexPath.row)
	tableView.deleteRows(at: [indexPath], with: .automatic)
	tableView.endUpdates()
	// Call reload of empty state 
	self.reloadEmptyState()
}
```

If you need more help take a look at the example project here (Pokemon nerds, will like it): [Example](https://github.com/luispadron/UIEmptyState/tree/master/UIEmptyStateExample)

## Documentation


#### [Read the full documentation here](http://htmlpreview.github.io/?https://github.com/luispadron/UIEmptyState/blob/master/docs/index.html)

## Example Project

#### Clone this repo and run the `UIEmptyStateExample` project


## License (MIT)

```
Copyright (c) 2017 Luis Padron

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
