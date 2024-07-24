import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store/model/order_model.dart';
import 'package:store/model/product_model.dart';
import 'package:store/view_model/orderadmin_view_model.dart';

class OrderspageView extends StatefulWidget {
  const OrderspageView({super.key});

  @override
  State<OrderspageView> createState() => _OrderspageViewState();
}

class _OrderspageViewState extends State<OrderspageView> {
  int? _filterStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Orders'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: GetBuilder<OrderadminViewModel>(
                init: OrderadminViewModel(),
                builder: (controller) => ListView.builder(
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    if (_filterStatus != null &&
                        controller.orders[index].status != _filterStatus) {
                      return SizedBox.shrink();
                    }
                    return buildOrderCard(
                      address: controller.orders[index].adresse,
                      date: controller.orders[index].date,
                      total: '${controller.orders[index].total} DH',
                      clientName:
                          'Client ${controller.orders[index].nomclient}',
                      status: _getStatusString(controller.orders[index].status),
                      products: controller.orders[index].products,
                      index: index,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8),
        children: [
          _buildFilterChip('All', null),
          _buildFilterChip('Order Placed', 0),
          _buildFilterChip('Shipped', 1),
          _buildFilterChip('Out for Delivery', 2),
          _buildFilterChip('Delivered', 3),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int? status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: _filterStatus == status,
        onSelected: (bool selected) {
          setState(() {
            _filterStatus = selected ? status : null;
          });
        },
      ),
    );
  }

  Widget buildOrderCard({
    required String address,
    required String date,
    required String total,
    required String clientName,
    required String status,
    required List<ProductModel1> products,
    required int index,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(clientName,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                _buildStatusChip(status, index),
              ],
            ),
            SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today, 'Date: $date'),
            _buildInfoRow(Icons.location_on, 'Address: $address'),
            _buildInfoRow(Icons.attach_money, 'Total: $total',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Products:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            ...products.map((product) => buildProductItem(product)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: style ?? TextStyle(fontSize: 14),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, int index) {
    return GetBuilder<OrderadminViewModel>(
      init: OrderadminViewModel(),
      builder: (controller) => InkWell(
        onTap: () {
          _showStatusChangeDialog(
              context, controller, controller.orders[index].id);
        },
        child: Chip(
          label: Text(status,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: _getStatusColor(status),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      ),
    );
  }

  void _showStatusChangeDialog(
      BuildContext context, OrderadminViewModel controller, String index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Order Status'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildStatusOption(
                    context, controller, index, 0, 'Order Placed'),
                _buildStatusOption(context, controller, index, 1, 'Shipped'),
                _buildStatusOption(
                    context, controller, index, 2, 'Out for Delivery'),
                _buildStatusOption(context, controller, index, 3, 'Delivered'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(
      BuildContext context,
      OrderadminViewModel controller,
      String orderIndex,
      int statusValue,
      String statusText) {
    return ListTile(
      title: Text(statusText),
      onTap: () {
        controller.updateOrderStatus(orderIndex, statusValue);
        Navigator.of(context).pop();
      },
    );
  }

  Widget buildProductItem(ProductModel1 product) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            product.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title:
            Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Quantity: ${product.quantity}'),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  String _getStatusString(int? status) {
    switch (status) {
      case 0:
        return 'Order Placed';
      case 1:
        return 'Shipped';
      case 2:
        return 'Out for Delivery';
      case 3:
        return 'Delivered';
      default:
        return 'All Orders';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Order Placed':
        return Colors.blue;
      case 'Shipped':
        return Colors.orange;
      case 'Out for Delivery':
        return Colors.amber;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
