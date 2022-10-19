// Mocks generated by Mockito 5.3.2 from annotations
// in kotori/test/domain/repository/item_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:kotori/data/source/item/item_dao.dart' as _i3;
import 'package:kotori/data/source/item/item_entity.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeItemEntity_0 extends _i1.SmartFake implements _i2.ItemEntity {
  _FakeItemEntity_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ItemDao].
///
/// See the documentation for Mockito's code generation for more information.
class MockItemDao extends _i1.Mock implements _i3.ItemDao {
  @override
  _i4.Future<_i2.ItemEntity> getNewItem() => (super.noSuchMethod(
        Invocation.method(
          #getNewItem,
          [],
        ),
        returnValue: _i4.Future<_i2.ItemEntity>.value(_FakeItemEntity_0(
          this,
          Invocation.method(
            #getNewItem,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.ItemEntity>.value(_FakeItemEntity_0(
          this,
          Invocation.method(
            #getNewItem,
            [],
          ),
        )),
      ) as _i4.Future<_i2.ItemEntity>);
  @override
  _i4.Future<List<_i2.ItemEntity>> getAllItems() => (super.noSuchMethod(
        Invocation.method(
          #getAllItems,
          [],
        ),
        returnValue: _i4.Future<List<_i2.ItemEntity>>.value(<_i2.ItemEntity>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i2.ItemEntity>>.value(<_i2.ItemEntity>[]),
      ) as _i4.Future<List<_i2.ItemEntity>>);
  @override
  _i4.Future<void> updateAllItems(List<_i2.ItemEntity>? items) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateAllItems,
          [items],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> deleteItem(_i2.ItemEntity? item) => (super.noSuchMethod(
        Invocation.method(
          #deleteItem,
          [item],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}