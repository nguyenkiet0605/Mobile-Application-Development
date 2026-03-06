# BÀI THỰC HÀNH 3: CALL API APP

## Ứng dụng Công Thức Nấu Ăn

**Sinh viên:** Nguyễn Tuấn Kiệt  
**MSSV:** 2351160533  
**Ngày:** Tháng 3, 2026

---

## SLIDE 1: GIỚI THIỆU

### 🎯 Mục tiêu:

- Lấy dữ liệu từ API công khai (TheMealDB)
- Xử lý luồng bất đồng bộ
- Hiển thị danh sách công thức nấu ăn
- Xử lý Loading, Success, Error states

### 📱 Tính năng chính:

- ✅ Lọc theo ẩm thực (6 quốc gia)
- ✅ Giao diện tiếng Việt
- ✅ Xử lý lỗi & retry
- ✅ Thiết kế responsive

---

## SLIDE 2: YÊU CẦU DỰ ÁN

### 📋 Yêu cầu bắt buộc:

1. **API Integration**: Gọi dữ liệu từ mạng
2. **UI States**: Loading → Success → Error
3. **Error Handling**: Try-catch + Retry button
4. **Code Organization**: Tách file (Model/Service/Screen)
5. **AppBar**: "TH3 - Nguyễn Tuấn Kiệt - 2351160533"

### 🎨 Yêu cầu giao diện:

- ListView với Card gọn gàng
- Text cắt ngắn, khoảng cách hợp lý
- Không màn hình trắng khi loading

---

## SLIDE 3: KIẾN TRÚC ỨNG DỤNG

### 📁 Cấu trúc thư mục:

```
lib/
├── main.dart              # Entry point
├── models/
│   └── food_item.dart     # Model dữ liệu
├── services/
│   └── api_service.dart   # API calls
└── screens/
    └── home_screen.dart   # UI chính
```

### 🔧 Technologies:

- **Flutter**: UI Framework
- **Dart**: Programming Language
- **HTTP Package**: API calls
- **TheMealDB API**: Data source

---

## SLIDE 4: NGUỒN DỮ LIỆU

### 🌐 API: TheMealDB

**Base URL:** `https://www.themealdb.com/api/json/v1/1/`

### 📡 Endpoints:

- `search.php?s=a` → Tất cả công thức
- `filter.php?a=Vietnamese` → Món Việt Nam
- `filter.php?a=Italian` → Món Ý
- `filter.php?a=Chinese` → Món Trung Quốc

### 📊 Response Format:

```json
{
  "meals": [
    {
      "idMeal": "52854",
      "strMeal": "Phở",
      "strCategory": "Seafood",
      "strArea": "Vietnamese",
      "strInstructions": "Recipe...",
      "strMealThumb": "image_url"
    }
  ]
}
```

---

## SLIDE 5: FEATURES & UI STATES

### 🎛️ Tính năng chính:

#### 1. Bộ lọc Ẩm thực

- Dropdown: Tất cả, Việt Nam, Ý, Trung Quốc, Mexico, Ấn Độ
- Auto-reload khi chọn filter

#### 2. Ba trạng thái UI

**Loading State:**

```
┌─────────────────────┐
│   ⏳ Đang tải...    │
│   [Circular Spinner] │
└─────────────────────┘
```

**Success State:**

```
┌──────────────────────────┐
│ [Hình] Tên Món           │
│        Danh mục: Seafood │
│        Khu vực: Vietnam  │
│        Hướng dẫn nấu...  │
└──────────────────────────┘
```

**Error State:**

```
┌──────────────────────┐
│     ❌ Lỗi          │
│ Không thể tải dữ    │
│   [Thử lại]         │
└──────────────────────┘
```

---

## SLIDE 6: THIẾT KẾ GIAO DIỆN

### 🎨 Design System:

- **Colors**: Orange accent + White background
- **Typography**: Bold titles, clean body text
- **Spacing**: 16px padding, 12px margins
- **Components**: Card (elevation 2), Dropdown, Buttons

### 📱 Layout:

- **AppBar**: Title + Orange background
- **Filter Bar**: Dropdown ở đầu màn hình
- **Content**: ListView với Card items
- **Responsive**: Hiển thị tốt trên mobile

---

## SLIDE 7: CODE IMPLEMENTATION

### 🏗️ Model (food_item.dart):

```dart
class FoodItem {
  final String id, name, category, area, instructions, imageUrl;

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? 'Unknown',
      area: json['strArea'] ?? 'Unknown',
      instructions: json['strInstructions'] ?? 'Recipe not available',
      imageUrl: json['strMealThumb'] ?? '',
    );
  }
}
```

### 🔗 Service (api_service.dart):

```dart
Future<List<FoodItem>> fetchFoodItems(String filter) async {
  try {
    String url = filter == 'All'
      ? '$baseUrl/search.php?s=a'
      : '$baseUrl/filter.php?a=$filter';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Parse JSON & return
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
```

### 🎯 UI (home_screen.dart):

```dart
class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'Vietnamese';

  void _loadData() {
    _futureFoodItems = ApiService().fetchFoodItems(_selectedFilter);
  }

  // FutureBuilder với 3 states
}
```

---

## SLIDE 8: XỬ LÝ LỖI & TESTING

### ⚠️ Error Handling:

- **Try-catch** trong API calls
- **Network errors**: Timeout, no connection
- **Empty data**: "Không có công thức nào"
- **Image load fail**: Placeholder icon

### 🧪 Test Scenarios:

- ✅ **Normal flow**: Load → Display list
- ✅ **Loading state**: Spinner hiển thị
- ✅ **Error handling**: Error message + Retry button
- ✅ **Filter change**: Auto reload data
- ✅ **Offline mode**: Error state

---

## SLIDE 9: KẾT QUẢ & ĐÁNH GIÁ

### ✅ Hoàn thành yêu cầu:

1. **API Integration** ✅
2. **3 UI States** ✅
3. **Error Handling** ✅
4. **Code Organization** ✅
5. **Clean UI** ✅

### 📈 Thống kê:

- **Files**: 5 files
- **Lines of Code**: ~270 dòng
- **Dependencies**: http package
- **API**: TheMealDB (free)

### 🎁 Bonus Features:

- Bộ lọc nâng cao (6 quốc gia)
- Giao diện tiếng Việt
- Responsive design
- Image error handling

---

## SLIDE 10: KẾT LUẬN & HƯỚNG PHÁT TRIỂN

### 🎓 Học được:

- Gọi API với Flutter
- Quản lý state bất đồng bộ
- Xử lý lỗi & exception
- Tổ chức code theo module
- Thiết kế UI/UX responsive

### 🚀 Hướng phát triển:

- Thêm trang chi tiết công thức
- Tìm kiếm theo tên
- Lưu công thức yêu thích
- Offline cache
- Push notifications

### 🙏 Cảm ơn!

**Đã hoàn thành bài thực hành 3 với chất lượng vượt yêu cầu**

---

## SLIDE 11: Q&A

### ❓ Câu hỏi thường gặp:

**Q: API nào được sử dụng?**  
A: TheMealDB - miễn phí, không cần API key

**Q: Xử lý lỗi như thế nào?**  
A: Try-catch + UI hiển thị lỗi + nút retry

**Q: Tại sao dùng ListView?**  
A: Đơn giản, responsive, phù hợp mobile

**Q: Có hoạt động offline không?**  
A: Không, cần internet. Có thể thêm cache sau
