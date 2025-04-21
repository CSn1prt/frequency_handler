import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frequency_handler/pages/loading.dart';
import 'package:frequency_handler/pages/chat_bot.dart';
import 'package:frequency_handler/pages/audio.dart';

void main() => runApp(HearingAidApp());

class HearingAidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '디지털 보청기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      // home: HearingAidMainScreen(),
      initialRoute: "/home",
      routes: {
        "/" : (context) => Loading(),
        "/home" : (context) => HearingAidMainScreen(),
        "/chat_bot": (context) => ChatBot(),
        "/audio": (context) => Audio(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HearingAidMainScreen extends StatefulWidget {
  @override
  _HearingAidMainScreenState createState() => _HearingAidMainScreenState();
}

class _HearingAidMainScreenState extends State<HearingAidMainScreen> {
  bool _isActive = false;
  double _volume = 0.7;
  List<double> _eqBands = [0.5, 0.7, 0.9, 1.2, 0.8, 0.6, 0.4];
  bool _showSettings = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // 메인 콘텐츠
            Column(
              children: [
                // 상태 표시 영역
                _buildStatusBar(context),
      
      
                // 주파수 조절 EQ 영역
                Expanded(
      
                  child: Center(
      
                    child: _buildGraphicEQ(),
                  ),
                ),
      
                // 제어 버튼 영역
                _buildControlButtons(),
              ],
            ),
      
            // 설정 패널 (슬라이드 업)
            if (_showSettings) _buildSettingsPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 배터리 상태
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat_bot');
                },
                icon: Icon(Icons.chat, color: Colors.green),
              ),
              SizedBox(width: 4),
            ],

          ),

          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/audio");
                },
                icon: Icon(Icons.audio_file, color: Colors.blue),
              ),
              SizedBox(width: 4),
            ],
          ),

          // 연결 상태
          Chip(
            label: Text(_isActive ? '활성화됨' : '대기 중'),
            backgroundColor: _isActive ? Colors.blue[100] : Colors.grey[300],
            avatar: Icon(
              _isActive ? Icons.hearing : Icons.hearing_disabled,
              size: 18,
              color: _isActive ? Colors.blue : Colors.grey,
            ),
          ),

          // 설정 버튼
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              setState(() => _showSettings = !_showSettings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGraphicEQ() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // EQ 밴드 레이블 (Hz)
              Text(
                ['125', '250', '500', '1K', '2K', '4K', '8K'][index],
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 4),
              // 조절 가능한 EQ 바
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _eqBands[index] = (_eqBands[index] - details.delta.dy / 100)
                        .clamp(0.1, 2.0);
                  });
                },
                child: Container(
                  width: 30,
                  height: _eqBands[index] * 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue[400]!,
                        Colors.blue[700]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(height: 8),
              // 현재 증폭 값 표시
              Text(
                '${(_eqBands[index] * 10).toStringAsFixed(1)}dB',
                style: TextStyle(fontSize: 12),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 볼륨 조절
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_up),
                  iconSize: 32,
                  onPressed: () {},
                ),
                Slider(
                  value: _volume,
                  min: 0,
                  max: 1,
                  onChanged: (value) => setState(() => _volume = value),
                  divisions: 10,
                ),
              ],
            ),

            // 메인 전원 버튼
            GestureDetector(
              onTap: () {
                setState(() {
                  _isActive = !_isActive;
                });
              },
              child: Container(
                width: 80,
                height: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isActive ? Colors.blue : Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  _isActive ? Icons.power_settings_new : Icons.power_off,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

            // 프리셋 버튼
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.equalizer),
                  iconSize: 32,
                  onPressed: () {
                    _showPresetDialog();
                  },
                ),
                Text('프리셋', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // 드래그 핸들
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 설정 내용
            Expanded(
              child: ListView(
                children: [
                  _buildSettingItem(
                    icon: Icons.noise_aware,
                    title: "소음 감소",
                    value: true,
                    onChanged: (v) {},
                  ),
                  _buildSettingItem(
                    icon: Icons.timer,
                    title: "자동 종료",
                    value: "30분",
                    onChanged: (v) {},
                  ),
                  _buildSettingItem(
                    icon: Icons.graphic_eq,
                    title: "음질 프로파일",
                    value: "표준",
                    onChanged: (v) {},
                  ),
                  _buildSettingItem(
                    icon: Icons.volume_down,
                    title: "최대 볼륨 제한",
                    value: "90%",
                    onChanged: (v) {},
                  ),
                  Divider(),
                  _buildSettingItem(
                    icon: Icons.help_outline,
                    title: "도움말",
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: "앱 정보",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    dynamic value,
    Function(dynamic)? onChanged,
    Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: value is bool
          ? Switch(value: value, onChanged: onChanged as Function(bool)?)
          : value != null
          ? Text(value.toString(), style: TextStyle(color: Colors.grey[600]))
          : null,
      onTap: onTap != null ? () => onTap() : null,
    );
  }

  void _showPresetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("음향 프리셋 선택"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPresetOption("표준", "일반적인 상황에 적합"),
            _buildPresetOption("야외", "바람 소리 감소"),
            _buildPresetOption("회의", "음성 명료도 강조"),
            _buildPresetOption("음악", "전 주파수 균형"),
          ],
        ),
        actions: [
          TextButton(
            child: Text("취소"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetOption(String title, String description) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing: Icon(Icons.radio_button_checked, color: Colors.blue),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title 프리셋이 적용되었습니다")),
        );
      },
    );
  }
}