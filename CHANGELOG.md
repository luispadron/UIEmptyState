# UIEmptyState Changelog

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