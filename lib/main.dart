import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serarchpill/pill_service.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PillService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pillService = Provider.of<PillService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('약 검색'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // 가로 방향 가운데 정렬

            children: [
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  // "좋아요"한 약 목록을 확인하는 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LikedPillPage()),
                  );
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '리스트',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                // 검색어를 입력하고 엔터를 누를 때 검색을 실행
                pillService.search(value);
              },
              decoration: InputDecoration(
                hintText: '검색할 약 이름을 입력하세요.',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // 검색 버튼을 눌렀을 때 PillService를 통해 검색 수행
                    pillService.search(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<PillService>(
              builder: (context, pillService, child) {
                final pillList = pillService.pillList;
                return ListView.builder(
                  itemCount: pillList.length,
                  itemBuilder: (context, index) {
                    final pill = pillList[index];
                    return ListTile(
                      leading: Image.network(
                        pill.itemImage, // 약 이미지 URL
                        width: 100, // 이미지 너비 설정 (원하는 크기로 조정)
                        height: 100, // 이미지 높이 설정 (원하는 크기로 조정)
                        fit: BoxFit.cover, // 이미지를 화면에 맞춰 표시
                      ),
                      title: Text(pill.itemName),
                      subtitle: Text(pill.className),
                      trailing: IconButton(
                        icon: Icon(
                          pill.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: pill.isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          // "좋아요" 아이콘을 눌렀을 때 toggleLikePill 메서드 호출
                          pillService.toggleLikePill(pill: pill);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LikedPillPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pillService = Provider.of<PillService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('좋아요한 약 목록'),
      ),
      body: ListView.builder(
        itemCount: pillService.likedPillList.length,
        itemBuilder: (context, index) {
          final pill = pillService.likedPillList[index];
          return ListTile(
            leading: Image.network(
              pill.itemImage,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(pill.itemName),
            subtitle: Text(pill.className),
            trailing: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                // "좋아요" 아이콘을 누르면 "좋아요" 취소되도록 toggleLikePill 메서드 호출
                pillService.toggleLikePill(pill: pill);
              },
            ),
          );
        },
      ),
    );
  }
}