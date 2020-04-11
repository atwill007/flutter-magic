import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

/*
Stateful widgets 持有的状态可能在widget生命周期中发生变化. 实现一个 stateful widget 至少需要两个类:
一个 StatefulWidget类。
一个 State类。 StatefulWidget类本身是不变的，但是 State类在widget生命周期中始终存在.
 */

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

// 状态类
class RandomWordsState extends State<RandomWords> {
  // 在Dart语言中使用下划线前缀标识符，会强制其变成私有的

  // 保存建议的单词对 列表
  final _suggestions = <WordPair>[];

  // 添加Set(集合) 集合存储用户喜欢（收藏）的单词对
  // 在这里，Set比List更合适，因为Set中不允许重复的值
  final _saved = new Set<WordPair>();

  // 增大字体大小
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build (BuildContext context) { // 基本的build方法
    // final wordPair = new WordPair.random();
    // return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        // 提示: 某些widget属性需要单个widget（child），而其它一些属性，如action，需要一组widgets(children），用方括号[]表示。
        // 为AppBar添加一个列表图标。当用户点击列表图标时，包含收藏夹的新路由页面入栈显示
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  /**
   * 构建显示建议单词对的ListView
   * ListView的builder工厂构造函数允许您按需建立一个懒加载的列表视图
   * itemBuilder 值是一个匿名回调函数， 接受两个参数- BuildContext和行迭代器i。迭代器从0开始， 每调用一次该函数，i就会自增1，对于每个建议的单词对都会执行一次
   */
  Widget _buildSuggestions () {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
      // 在偶数行，该函数会为单词对添加一个ListTile row.
      // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
      // 注意，在小屏幕上，分割线看起来可能比较吃力。
      itemBuilder: (context, i) {
        // 在每一列之前，添加一个1像素高的分隔线widget
        if (i.isOdd) return new Divider();

        // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        final index = i ~/ 2;
        // 如果是建议列表中最后一个单词对
        if (index >= _suggestions.length) {
          // ...接着再生成10个单词对，然后添加到建议列表
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(index + 1, _suggestions[index]);
      }
    );
  }

  // 在ListTile中显示每个新词对
  Widget _buildRow (num idx, WordPair pair) {
    final alreadySaved = _saved.contains(pair); // 检查单词对有没有添加到收藏夹中

    return new ListTile(
      title: new Text(
        idx.toString() + ' - ' + pair.asPascalCase,
        style: _biggerFont,
      ),
      // 添加一个心形 ❤️ 图标到 ListTiles以启用收藏功能
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      // 添加点击交互，让row可以进行点击并触发心形❤️图标的切换
      onTap: () {
        // 提示: 在Flutter的响应式风格的框架中，调用setState() 会为State对象触发build()方法，从而导致对UI的更新
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      }
    );
  }

  /**
   * Tips: 在Flutter中，导航器管理应用程序的路由栈。将路由推入（push）到导航器的栈中，将会显示更新为该路由页面。 从导航器的栈中弹出（pop）路由，将显示返回到前一个路由。
   * 当用户点击导航栏中的列表图标时，建立一个路由并将其推入到导航管理器栈中。此操作会切换页面以显示新路由
   * 新页面的内容在在MaterialPageRoute的builder属性中构建，builder是一个匿名函数。
   * 添加Navigator.push调用，这会使路由入栈（以后路由入栈均指推入到导航管理器的栈）
   */
  void _pushSaved () {
    Navigator.of(context).push(
      // 添加MaterialPageRoute及其builder
      new MaterialPageRoute(
        // builder返回一个Scaffold，其中包含名为“Saved Suggestions”的新路由的应用栏。 新路由的body由包含ListTiles行的ListView组成; 每行之间通过一个分隔线分隔
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          // ListTile的divideTiles()方法在每个ListTile之间添加1像素的分割线。
          // 该 divided 变量持有最终的列表项。
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggesitons'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}
