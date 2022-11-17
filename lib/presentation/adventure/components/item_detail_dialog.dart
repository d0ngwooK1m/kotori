import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kotori/domain/model/item.dart';
import 'package:kotori/presentation/adventure/adventure_view_model.dart';
import 'package:kotori/util/modal_route_observer.dart';
import 'package:provider/provider.dart';

class ItemDetailDialog extends StatefulWidget {
  final Item item;
  final int position;

  const ItemDetailDialog({Key? key, required this.item, required this.position})
      : super(key: key);

  @override
  State<ItemDetailDialog> createState() => _ItemDetailDialogState();
}

class _ItemDetailDialogState extends State<ItemDetailDialog> with RouteAware {
  final _valueMap = {
    'assets/images/question_mark.png': '코토리가 아직 확인해\n보지 않은 아이템이다.',
    'assets/images/korean_mountain_ash_fruit.png':
        '꽃은 배를, 열매는 팥을\n닮은 팥배나무 열매이다.',
    'assets/images/maple_seed.png': '장난감 겸 간식인\n단풍나무 씨이다.',
    'assets/images/meal_worm_chip.png': '뱁새들이 좋아하는\n밀웜 칩이다.',
    'assets/images/grass_whistle.png': '코토리가 잘 부는\n풀피리이다.',
    'assets/images/water_bottle.png': '기분산의 암반수에서\n나온 깨끗한 물이다.',
  };

  final recommends = [
    '추천 컨텐츠1 *',
    '추천 컨텐츠2 *',
    '추천 컨텐츠3 *',
    '추천 컨텐츠4 *',
    '추천 컨텐츠5 **',
    '추천 컨텐츠6 **',
    '추천 컨텐츠7 **',
    '추천 컨텐츠8 ***',
    '추천 컨텐츠9 ***',
  ];

  final random = Random();

  String _selectedImgString = '';

  TextEditingController controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRouteObserver.itemDetailDialogObserver
        .subscribe(this, ModalRoute.of(context) as ModalRoute<dynamic>);
  }

  @override
  void didPush() {
    controller.text = widget.item.desc;
    _selectedImgString = widget.item.picture;
    super.didPush();
  }

  @override
  void dispose() {
    controller.dispose();
    ModalRouteObserver.itemDetailDialogObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AdventureViewModel>();
    return AlertDialog(
      content: SizedBox(
        width: 300,
        height: 400,
        child: ListView(
          children: [
            _buildClose(),
            const SizedBox(height: 16),
            _buildSelectPicAndInfo(),
            const SizedBox(height: 16),
            _buildDesc(),
            _buildButton(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectPicAndInfo() {
    return Row(
      children: [
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _selectedImgString,
              items: List.generate(
                _valueMap.length,
                (index) => DropdownMenuItem(
                  value: _valueMap.keys.toList().elementAt(index),
                  child: Image.asset(_valueMap.keys.toList().elementAt(index)),
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  _selectedImgString = value!;
                });
              },
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 2),
            ),
            child: Text(_valueMap[_selectedImgString] ?? ''),
          ),
        ),
      ],
    );
  }

  Widget _buildDesc() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        maxLines: 9,
        style: const TextStyle(
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText:
              (widget.item.desc == '') ? '내가 힘들 때\n무슨 일을 하고 싶은지 적어보세요' : '',
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
        ),
        onChanged: (text) {
          controller.text = text;
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
        },
      ),
    );
  }

  Widget _buildButton(AdventureViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            controller.text =
                recommends.elementAt(random.nextInt(recommends.length));
          },
          icon: const Icon(Icons.lightbulb_outline),
        ),
        ElevatedButton(
          onPressed: () {
            viewModel.saveItemInfo(
              item: Item(
                name: widget.item.name,
                desc: controller.text,
                picture: _selectedImgString,
                date: widget.item.date,
              ),
              position: widget.position,
            );
            Navigator.of(context).pop();
          },
          child: const Text('저장'),
        ),
      ],
    );
  }

  Widget _buildClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
