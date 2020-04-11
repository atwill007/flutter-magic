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
  final _suggestions = <WordPair>[]; // 保存建议的单词对 列表
  final _biggerFont = const TextStyle(fontSize: 18.0); // 增大字体大小

  @override
  Widget build (BuildContext context) { // 基本的build方法
    // final wordPair = new WordPair.random();
    // return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
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

        return _buildRow(_suggestions[index]);
      }
    );
  }

  // 在ListTile中显示每个新词对
  Widget _buildRow (WordPair pair) {
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}
