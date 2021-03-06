import 'dart:async';
import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:intl/intl.dart';

import '../../pipes/capitalize_pipe.dart';
import '../fo_text_input/fo_text_input_component.dart';
import 'fo_dropdown_option.dart';
import 'fo_dropdown_option_component.dart';

@Component(
    selector: 'fo-dropdown-list',
    templateUrl: 'fo_dropdown_list_component.html',
    styleUrls: ['fo_dropdown_list_component.css'],
    directives: [
      NgClass,
      NgFor,
      NgIf,
      NgStyle,
      FoDropdownOptionComponent,
      formDirectives,
      FoTextInputComponent
    ],
    pipes: [CapitalizePipe],
    changeDetection: ChangeDetectionStrategy.OnPush)
class FoDropdownListComponent
    implements AfterViewInit, AfterChanges, OnDestroy {
  @Input()
  num width;

  @Input()
  bool visible = false;

  @Input()
  bool allowNullSelection = false;

  @Input()
  bool constrainToViewPort = true;

  @Input()
  bool materialIcons = true;

  @Input()
  Map<String, List<FoDropdownOptionRenderable>> options;

  @Input()
  String filter;

  @Input()
  bool showSearch = false;

  final String msgFilter = Intl.message('filter', name: 'filter');
  final FoDropdownOption nullOption = FoDropdownOption()
    ..id = null
    ..label = '-';
  StreamSubscription<html.MouseEvent> _onDocumentClickListener;
  final ChangeDetectorRef _changeDetectorRef;
  final html.Element host;
  final StreamController _visibleController = StreamController<bool>();
  final StreamController _selectController =
      StreamController<FoDropdownOptionRenderable>();
  Map<String, List<FoDropdownOptionRenderable>> _filteredOptions;
  String elementMaxHeight = '100px';
  String top;

  FoDropdownListComponent(this._changeDetectorRef, this.host) {
    _onDocumentClickListener = html.document.onClick.listen((event) {
      if (visible && !_visibleController.isClosed) {
        _visibleController.add(false);
      }
    });
  }

  String get elementWidth => width == null ? 'auto' : '${width}px';

  Map<String, List<FoDropdownOptionRenderable>> get filteredOptions =>
      _filteredOptions;

  @Output('select')
  Stream<FoDropdownOptionRenderable> get select => _selectController.stream;

  @Output('visibleChange')
  Stream<bool> get visibleChange => _visibleController.stream;

  @override
  void ngAfterChanges() {
    if (visible == true) {
      final rect = host.getBoundingClientRect();
      top = '${rect.top}px';

      elementMaxHeight = constrainToViewPort == true
          ? '${html.window.innerHeight - rect.top}px'
          : '${html.document.body.clientHeight - (rect.top + html.window.scrollY)}px';

      updateFilteredOptions(filter);
      if (_filteredOptions.isEmpty) {
        _visibleController.add(false);
      }
    }
  }

  @override
  void ngAfterViewInit() {
    html.document.onScroll.forEach((e) {
      top = '${host.getBoundingClientRect().top}px';
      _changeDetectorRef.markForCheck();
    });
  }

  @override
  void ngOnDestroy() {
    _visibleController.close();
    _selectController.close();
    _onDocumentClickListener?.cancel();
  }

  void onSelect(html.Event e, FoDropdownOptionRenderable option) {
    e.stopPropagation();
    _selectController.add(option);
  }

  void updateFilteredOptions(String value) {
    if (value == null || value.isEmpty) {
      _filteredOptions = Map.from(options);
    } else {
      _filteredOptions = {};
      for (final category in options.keys) {
        _filteredOptions[category] = options[category]
            .where((option) =>
                option.renderLabel.toLowerCase().contains(value.toLowerCase()))
            .toList(growable: false);
        if (_filteredOptions[category].isEmpty) {
          _filteredOptions.remove(category);
        }
      }
    }
  }
}
