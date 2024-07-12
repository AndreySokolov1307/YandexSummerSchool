# FileCache

## Usage example

```swift
    let fileCahce: FileCache<ToDoItem>
    
    func deleteItem(_ item: ToDoItem) {
        self.fileCache.deleteItem(withId: item.id)
    }
```    
