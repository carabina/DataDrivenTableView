# DataDrivenTableView

Data driven table view makes it easy to work with dynamic data in table view

## Usage

### Properties
Then subclass a DDSection and override the following methods

- `isRefreshControlEnabled: Bool` return `true` if you need pull to refresh
- `isInfiniteScrollEnabled: Bool` return `true` if you need infinite scroll

### Interaction with datasource
- `update(insert newItems: [T], at: Int, animation: UITableViewRowAnimation? = nil)`
- `update(append newItems: [T], animation: UITableViewRowAnimation? = nil)`
- `update(reload item: T, animation: UITableViewRowAnimation? = nil)`
- `update(delete item: T, animation: UITableViewRowAnimation? = nil)`
- `clear()`
- `update(failed error: Error)`

### Cells
-`cellForRow(at index: Int) -> UITableViewCell`
-`heightForRow(at index: Int) -> CGFloat`
-`requestForMoreItems()`

### InfiniteScroll
-`infiniteScrollView() -> UIView`

### RefreshControl
-`didRefresh()`

### DDTableViewController
override following properties
-`showError()`
-`showLoading()`
-`showEmptyView()`

## Author

mohsenShakiba, work.shakiba@gmail.com

## License

DataDrivenTableView is available under the MIT license. See the LICENSE file for more info.
