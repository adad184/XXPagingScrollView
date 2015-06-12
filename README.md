XXPagingScrollView
============

[![Total views](https://sourcegraph.com/api/repos/github.com/adad184/XXPagingScrollView/.counters/views.png)](https://sourcegraph.com/github.com/adad184/XXPagingScrollView)
[![Views in the last 24 hours](https://sourcegraph.com/api/repos/github.com/adad184/XXPagingScrollView/.counters/views-24h.png)](https://sourcegraph.com/github.com/adad184/XXPagingScrollView)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/XXPagingScrollView/badge.png)](http://cocoapods.org/?q=XXPagingScrollView)

Paged scrollView with custom paging width

![demo](https://raw.githubusercontent.com/adad184/XXPagingScrollView/master/demo.gif)


Installation
============

The preferred way of installation is via [CocoaPods](http://cocoapods.org). Just add

```ruby
pod 'XXPagingScrollView'
```

and run `pod install`. It will install the most recent version of XXPagingScrollView.

If you would like to use the latest code of XXPagingScrollView use:

```ruby
pod 'XXPagingScrollView', :head
```

Usage
===============

simply, you can indicate the specific paging width & height, or set to 0 if you want a fulfill paging size

```swift
public var pagingWidth:CGFloat
public var pagingHeight:CGFloat
```

then use internal scrollview to show your content

```swift
public var scrollView:UIScrollView
```

check more detail in the demonstration


@end