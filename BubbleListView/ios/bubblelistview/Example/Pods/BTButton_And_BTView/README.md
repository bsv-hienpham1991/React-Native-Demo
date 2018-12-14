# BTButton And BTView

More custom for UIButton and UIView on Interface Builder!
## Ngôn ngữ: Objective-C
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

BTButton_And_BTView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:  
```ruby
pod 'BTButton_And_BTView', :git => 'https://bsvframeworks@bitbucket.org/bravesoftvietnam/btbutton-and-btview.git'
```

## BTButton
Trong các dự án mobile thông thường hay có một loại button khá thông dụng, chúng ta có thể gọi
nó là button bo tròn do có các đặc điểm sau:
1. Bo tròn 1 phần hoặc toàn phần
2. Bo tròn toàn bộ các góc hoặc chỉ một số góc
3. Không có hình background, thay vào đó là sử dụng màu
4. Có đường viền
5. Có tính chất composite (tức là được hình thành từ nhiều button con)

![alt text](https://shoeiordersystem.s3.amazonaws.com/bsv_frameworks/images/composite_button.original.png "Nút bo tròn")   
Hình vd minh hoạ cho nút bo tròn

Tuy gặp thường xuyên như vậy, nhưng đáng tiếc thay Apple lại vẫn chưa cung cấp api support một cách thuận tiện cho những trường hợp này. Dev phải tự code gây mất thời gian nhưng hiệu quả cũng như chất lượng chưa cao.  
Vì vậy BTButton được tạo ra để giải quyết vấn đề này một cách dễ dàng, chất lượng và có thể tái sử dụng ở nhiều dự án khác nhau.  
BTButton có thể được config bằng Interface Builder như các item thông thường, xem clip tại link dưới đây:  
https://drive.google.com/open?id=1ZPlnAM2-Xzi8StE0Bj28FsM9oOKjpi_M  
BTButton bao gồm các thuộc tính sau (tạm thời dùng swift để minh hoạ, sẽ thay đổi thành objective-c sau):  
```
var innerShadowX : Float // Thiết lập shadow x
var innerShadowY : Float // Thiết lập shadow y
var lineWidth : Float // Độ dày đường border
var strokeColor : Color // Màu đường border
var fillColor : Color // Màu background
var fillColorHighlighted : Color // Màu background trong trạng thái
highlight
var *strokeColorHighlighted : Color // Màu đường border trong trạng thái
highlight
var cornerRadius : Float // Độ cong của góc bo tròn
var roundAsMuchAsPossible : Bool // Nếu true tức là cố gắng làm bo tròn hết
sức có thể
var highlightedEnabled : Float // Có cho hiệu ứng highlight khi bấm vào hay
không. Vd: trong tabbar thì các nút tabbar khi bấm ko có hiệu ứng highlight
@IBOutlet var components: [UIButton]! // Các button con bên trong, có thể
lồng nhau
var roundedAllCorners : Bool // Có bo tròn tất cả các góc hay không, nếu
tue thì không quan tâm các thuộc tính con gồm roundedTopLeft,
roundedTopRight, roundedBottomRight,roundedBottomLeft
var roundedTopLeft : Bool // Có bo tròn góc trên trái hay không
var roundedTopRight : Bool // Có bo tròn góc trên phải hay không
var roundedBottomRight : Bool // Có bo tròn góc dưới phải hay không
var roundedBottomLeft : Bool // Có bo tròn góc dưới trái hay không
```
## BTView
BTView tính chất cũng tương tự như BTButton nhưng vì không có các event click BTButton nên không có các thuộc tính sau:  
```
var fillColorHighlighted : Color
var *strokeColorHighlighted : Color
var highlightedEnabled : Float
@IBOutlet var components: [UIButton]!
```

## Author

Hien, hienpham@bravesoft.com.vn

## License

BTButton_And_BTView is available under the APACHE license. See the LICENSE file for more info.
