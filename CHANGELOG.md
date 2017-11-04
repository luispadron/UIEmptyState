# UIEmptyState CHANGELOG

## Version 2.0.2

Bug fix for retain cycle between delegate, datasource, and the view controller. 
Thanks to [@piotrzuzel](https://github.com/piotrzuzel) for the fix.

## Version 2.0.1

Add shared scheme, fixed thanks to [@piotrzuzel](https://github.com/piotrzuzel).

## Version 2.0.0

#### Breaking API Changes:

- Renamed `reloadEmptyState(for: tableView)` to `reloadEmptyStateForTableView(_:)` __and__ `reloadEmptyState(for: collectionView)` to `reloadEmptyStateForCollectionView(_:)`. This fixes an issue where error is thrown for duplicate function declaration with Objective-C selector on Swift versions lower than 4.0.


- Renamed the `shouldShowEmptyStateView(for:)` datasource method to `emptyStateViewShouldShow(for:)`. This was done to be more consistent with the rest of the API.


- Renamed `titleView` to `titleLabel` __and__ `detailView` to `detailLabel`. This makes it more clear exactly what these views actually are.

#### Improvements and Fixes

- Fix a bug where constraints for the `UIEmptyStateView` would be added whenever the view appeared thus causing a warning to be thrown by Xcode for duplicate and breaking constraints. Constraints for the view are now only added on initial showing of view.

- Fix bug where `UIEmptyStateView.detailLabel` would not resize and fit the screen correctly on iOS versions lower than 11.0. `detailLabel` now calculates it's width properly and constraints are added accordingly.

- Change `emptyStateViewAnimatesEverytime` from `true` to `false`. This seems like a more reasonable default value as it animations can get annoying when repeated multiple times without change.

## Versin 1.0.2

- Fix issue with `UIEmptyStateView` and it's subviews not being accessible.

## Version 1.0.1

- Fix access modifier in default implementation of `emptyStateViewWillHide(view: UIView)`

## Version 1.0.0 - Stable Release

- Add Swift version check to allow support for Swift 3 --> Swift 4.
- Refactor public API to make it less verbose and more Swift-like.
	* All methods which had the format `methodName(forSomething:)` have been refactored to simply `methodName(for:)`. 
	* Due to this renaming, if using Swift 3.2 or lower, you may get an error 
about a `@objc` method having already been declared, this is due to Swift 3 inferring an `@objc` attribute when it is not in fact `@objc`. If using Xcode 9 +, you will need to set `Swift 3 @objc Inference` in the `Optimization Level` of this projects `Build Settings` to `Off`. I know this is a hassle, but I want to keep the API clean and stable, no point in changing it at a later date when Swift 4 is fully released and breaking more code.
- Add two new delegate methods to the `UIEmptyStateDelegate`
	* `emptyStateViewWillShow(view: UIView)` which is called before the view is shown, given you time to do any additional work.
	* `emptyStateViewWillHide(view: UIView)` which is called right before the view will be hidden from the screen.
- Fix some broken documentation/updated docs

After this release the API should not change that often, thus I wont be breaking your code as much 😅

Thanks for using `UIEmptyState`


## Version 0.8.3

- Fix bug where data source was not reverting `edgesForExtendedLayout` to default values after it was done presenting the view

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
