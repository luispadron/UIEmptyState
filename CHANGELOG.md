# UIEmptyState Changelog

## Version 0.8.2

- Fix issue with constraints not being set properly for Empty state view

## Version 0.8.1

- Make sure `.swift-version` is included in pod to fix warnings in Xcode 9

## Version 0.8.0

- Updated for Swift 4 and Xcode 9
- Now uses `safeAreaLayoutGuide` to adjust centering of empty state view, if on iOS 11 when `shouldAdjustToFitBars` returns `true`.
- Updated project to recommended settings in Xcode 9, set language to Swift 4 and `@objc inference` to `default`.

## Version 0.7.0

- Update constraints for labels so that they do not extend past the edges of the view
- Add private extension to help calculate the the height of labels

## Version 0.6.0

- Fix bug where title for UIEmptyState was not being updated when reloading
- Made sure to assign all datasource properties when creating, and updating the view


## Version 0.5.0

- Refactored API methods for `UIEmptyStateDataSource` into computed properties to be more "swift-like"
- Add new delegate method to get notified when the view has been shown, here you can bring subviews to front that may have been covered by the UIEmptyState
- Add new property to determine whether the viewcontroller using UIEmptyState should adjust it's frame to take into account navigation bars/tab bars
- Refactored a lot of code and comments

#### Breaking API Changes in 0.5.0

Basically, everything... Sorry!
Due to the change from methods to properties, the way you interact with the data source has changed. [Please read the documentation](https://htmlpreview.github.io/?https://raw.githubusercontent.com/luispadron/UIEmptyState/master/docs/Protocols/UIEmptyStateDataSource.html). Most methods have been convereted into computed properties. This will be the design going forward unless it's not possible, i.e requires parameters or would be better in a method.

## Version 0.4.0

- Add ability to animate the empty state view
- Removed returning a detail message in the default implementation as this caused an annoying problem in that you would need to implement that method and return nil if you didn't want to use a detail message

## Version 0.3.0

- Add fixes for views not being updated
- Add fix to constraints becoming wonky after readding views
- Add convenience extenions to `UITableViewController` and `UICollectionViewController`
	
	You can now do this:
	
	```swift 
	// If a tableview or collectionview controller subclass
	// This will default the tableView/collectionView to self.tableView/collectionView
	self.reloadEmptyState()
	```
- Refactoring of UIEmptyStateView
- Rerun Jazzy for documentation

## Version 0.2.1

- Add fix for updating view, titles can now be changed on the fly using data source methods
- Some small amount of refactoring

## Version 0.2.0

- Now works with any UIViewController subclass
- Update example project to contain a `UITableViewController` example as well a `UICollectionViewController` exmaple
- Refactor some uneeded code
- Rerun Jazzy for code documentation

##### Breaking API CHanges:

- Call for reloading of empty state view has changed

	_Before_
	
	```swift
	// Called whenever data has changed, only worked for table views
	self.reloadTableViewEmptyState() 
	```
	
	_Now_
	
	```swift
	// Called whenever data has changed, now works with collectionview or tableview
	// If tableView controller, or controller with tableView property
	self.reloadEmptyState(forTableView: self.tableView) 
	// OR if collectionview controller, or controller with collectionView property
	self.reloadEmptyState(forCollectionView: self.collectionView)
	```

## Version 0.1.1

- Initial of the initial release (messed up the spec in 0.1.0 oops)
- Currently only works with `UITableViewController`
- iOS required of 9.0 +

## Version 0.1.0

- Initial release
- Currently only works with `UITableViewController`
- iOS required of 9.0 +
