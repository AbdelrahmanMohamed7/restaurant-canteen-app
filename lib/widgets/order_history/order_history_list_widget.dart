import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../consts.dart';
import '../../model/order_model.dart';
import '../../screens/order_view_detail_screen.dart';
import '../../state/order_history_state.dart';
import '../../utils/utils.dart';
import '../../view_model/order_history_vm/order_history_view_model_imp.dart';
import '../common/common_widget.dart';

class OrderHistoryListWidget extends StatefulWidget {

   OrderHistoryListWidget({Key? key, required this.listOrder,required this.orderStatusMode,required this.restaurantId})
      : super(key: key);
   List<OrderModel> listOrder;
  final String orderStatusMode;
  final String restaurantId;
  @override
  State<OrderHistoryListWidget> createState() => _OrderHistoryListWidgetState();
}

class _OrderHistoryListWidgetState extends State<OrderHistoryListWidget> {
  final orderDetailState = Get.put(OrderHistoryState());
  final vm = OrderHistoryViewModelImp();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: LiveList(
          showItemDuration: Duration(milliseconds: 300),
          showItemInterval: Duration(milliseconds: 300),
          reAnimateOnVisibility: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.listOrder.length,
               itemBuilder: animationItemBuilder((index) => InkWell(
                onTap: ()async {
                  orderDetailState.selectedOrder.value = widget.listOrder[index];
                 await Get.to(()=> OrderViewDetailScreen());
                widget.listOrder =await vm.getUserHistory(
                      widget.restaurantId,widget.orderStatusMode);
                setState(() {

                });
                },
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.listOrder[index].cartItemList[0].image,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, err) => Center(
                            child: Icon(Icons.image),
                          ),
                          progressIndicatorBuilder: ( context ,url,download) =>
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Color(COLOR_OVERLAY),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:20,bottom:20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:[
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Order #${widget.listOrder[index].orderNumber}',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.jetBrainsMono(
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            fontSize: 18),
                                          ),
                                          Text(
                                            'Date #${convertToDate(widget.listOrder[index].createdDate)}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.jetBrainsMono(
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                                fontSize: 18),

                                          ),
                                        ],
                                      )
                                    ]
                                  )
                                )
                              ],
                            )
                          )
                        )
                      ],
                    )),
              )),
        ))
      ],
    );
  }
}
