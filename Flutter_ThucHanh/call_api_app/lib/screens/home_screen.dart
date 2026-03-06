import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<FoodItem>> _futureFoodItems;
  String _selectedFilter = 'Vietnamese';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _futureFoodItems = ApiService().fetchFoodItems(_selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TH3 - Nguyen Tuan Kiet - 2351160533',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orangeAccent,
        elevation: 2,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.orange.shade50,
            child: Row(
              children: [
                Text(
                  'Lọc theo ẩm thực:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: 'All', child: Text('Tất cả')),
                      DropdownMenuItem(
                        value: 'Vietnamese',
                        child: Text('Việt Nam'),
                      ),
                      DropdownMenuItem(value: 'Italian', child: Text('Ý')),
                      DropdownMenuItem(
                        value: 'Chinese',
                        child: Text('Trung Quốc'),
                      ),
                      DropdownMenuItem(value: 'Mexican', child: Text('Mexico')),
                      DropdownMenuItem(value: 'Indian', child: Text('Ấn Độ')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedFilter = value;
                          _loadData();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<FoodItem>>(
              future: _futureFoodItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orangeAccent,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Đang tải công thức...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.redAccent,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Không thể tải dữ liệu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _loadData();
                              });
                            },
                            child: Text('Thử lại'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  List<FoodItem> foodItems = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: foodItems.length,
                    itemBuilder: (context, index) {
                      FoodItem item = foodItems[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.restaurant,
                                        color: Colors.grey[500],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Danh mục: ${item.category}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Khu vực: ${item.area}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      item.instructions.length > 100
                                          ? '${item.instructions.substring(0, 100)}...'
                                          : item.instructions,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                        height: 1.4,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Không có công thức nào',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
