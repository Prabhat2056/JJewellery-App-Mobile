import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../bloc/OldJewellery/old_jewellery_bloc.dart';
import '../../../models/old_jewellery_model.dart';
import '../../../utils/color_constant.dart';

class OldJewelleryTable extends StatefulWidget {
  const OldJewelleryTable({super.key, required this.items});

  final List<OldJewelleryModel> items;

  @override
  State<OldJewelleryTable> createState() => _OldJewelleryTableState();
}

class _OldJewelleryTableState extends State<OldJewelleryTable> {
  late OldJewelleryDataSource dataSource;

  @override
  Widget build(BuildContext context) {
    final dataSource = OldJewelleryDataSource(
      data: widget.items,
      onDelete: (item) {
        BlocProvider.of<OldJewelleryBloc>(context)
            .add(OldJewelleryRemoveEvent(oldJewelleryModel: item));
      },
    );
    return Card(
      elevation: 5,
      color: Colors.white54,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: SfDataGrid(
          source: dataSource,
          columnWidthMode: ColumnWidthMode.fill,
          columns: <GridColumn>[
            GridColumn(
              columnName: 'item',
              label: buildHeader('Item'),
              maximumWidth: 120,
            ),
            GridColumn(
                columnName: 'qtyGram',
                label: buildHeader('Qty (g)'),
                width: 60),
            GridColumn(
                columnName: 'wasteGram',
                label: buildHeader('Waste (g)'),
                width: 60),
            GridColumn(
                columnName: 'finalQty',
                label: buildHeader('Final Qty'),
                width: 60),
            GridColumn(
              columnName: 'actions',
              label: buildHeader('Actions'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        title,
        overflow: TextOverflow.visible,
        softWrap: true,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class OldJewelleryDataSource extends DataGridSource {
  OldJewelleryDataSource({
    required List<OldJewelleryModel> data,
    required this.onDelete,
  }) {
    _rawData = data;
    _rows = data.map<DataGridRow>((e) {
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'item',
          value: e.item,
        ),
        DataGridCell<double>(
          columnName: 'qtyGram',
          value: e.qtyGram,
        ),
        DataGridCell<double>(
          columnName: 'wasteGram',
          value: e.wasteGram,
        ),
        DataGridCell<double>(columnName: 'finalQty', value: e.finalQty),
        DataGridCell<String>(
          columnName: 'actions',
          value: '',
        ),
      ]);
    }).toList();
  }

  late List<DataGridRow> _rows;
  late List<OldJewelleryModel> _rawData;

  final void Function(OldJewelleryModel item) onDelete;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final index = rows.indexOf(row);
    final item = _rawData[index];

    return DataGridRowAdapter(
      color: Colors.white54,
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'actions') {
          return IconButton(
            icon: Icon(Icons.delete, size: 20, color: ColorConstant.errorColor),
            padding: EdgeInsets.zero,
            onPressed: () => onDelete(item),
          );
        }

        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }
}
