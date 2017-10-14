// Copyright (c) 2017, Muienog AB. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import '../fo_multi_select_component/fo_multi_select_component.dart';
import '../../models/fo_model.dart';
import '../../pipes/phrase_pipe.dart';

@Component(
    selector: 'fo-image-map',
    styleUrls: const ['fo_image_map_component.css'],
    templateUrl: 'fo_image_map_component.html',
    directives: const [CORE_DIRECTIVES, materialDirectives, FoMultiSelectComponent],
    pipes: const [PhrasePipe],
    visibility: Visibility.none,
    changeDetection: ChangeDetectionStrategy.OnPush
)

class FoImageMapComponent implements OnChanges, OnDestroy
{
  FoImageMapComponent();

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("zones"))
    {
      zoneOptions = new StringSelectionOptions(zones);
    }
    if (changes.containsKey("selectedIds"))
    {
      for (FoZoneModel zone in zones)
      {
        zone.marked = selectedIds.contains(zone.id);
      }
    }
  }

  void ngOnDestroy()
  {
    _onSelectedIdsChangeController.close();
  }

  void onClick(FoZoneModel zone)
  {
    zone.marked = !zone.marked;
    selectedIds = zones.where((z) => z.marked).map((model) => model.id).toList(growable: false);
    _onSelectedIdsChangeController.add(selectedIds);
  }

  void onSelectionChange(List<String> selected_ids)
  {
    selectedIds = selected_ids;

    for (FoZoneModel shape in zones)
    {
      shape.marked = selectedIds.contains(shape.id);
    }

    _onSelectedIdsChangeController.add(selectedIds);
  }

  StringSelectionOptions<FoZoneModel> zoneOptions;

  final StreamController<List<String>> _onSelectedIdsChangeController = new StreamController();

  @Input('label')
  String label = "select";

  @Input('zones')
  List<FoZoneModel> zones = new List();

  @Input('src')
  String src = "";

  @Input('selectedIds')
  List<String> selectedIds = [];

  @Output('selectedIdsChange')
  Stream<List<String>> get onSelectedIdsChangeOutput => _onSelectedIdsChangeController.stream;
}

class FoZoneModel extends FoModel
{
  FoZoneModel(this._shapes, String id, String label) : super(id, label);
  List<FoShape> get shapes => _shapes;

  Iterable<FoShapeEllipse> get ellipses => _shapes.where((s) => s.type == "ellipse");
  Iterable<FoShapeRectangle> get rectangles => _shapes.where((s) => s.type == "rectangle");
  Iterable<FoShapePolygon> get polygons => _shapes.where((s) => s.type == "polygon");

  final List<FoShape> _shapes;
  bool marked = false;
}

abstract class FoShape
{
  FoShape(this._x, this._y, this.type);

  String get x => "$_x";
  String get y => "$_y";

  final int _x;
  final int _y;

  final String type;
}

class FoShapeEllipse extends FoShape
{
  FoShapeEllipse(int x, int y, this._rx, this._ry) : super(x, y, "ellipse");

  String get rx => "$_rx";
  String get ry => "$_ry";

  final int _rx;
  final int _ry;
}

class FoShapePolygon extends FoShape
{
  FoShapePolygon(this._points) : super(null, null, "polygon");

  String get points => _points.map((point) => point.toString()).join(" ");

  final List<FoShapePoint> _points;
}

class FoShapePoint
{
  FoShapePoint(this.x, this.y);

  @override
  String toString() => "$x,$y";

  final int x;
  final int y;
}

class FoShapeRectangle extends FoShape
{
  FoShapeRectangle(int x, int y, this._width, this._height) : super(x, y, "rectangle");

  String get width => "$_width";
  String get height => "$_height";

  final int _width;
  final int _height;
}