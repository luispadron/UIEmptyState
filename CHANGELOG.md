# UIEmptyState Changelog

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