import 'package:flutter/material.dart';

class IconMap {
  static const Map<String, IconData> icons = {
    // Finance
    'account_balance_wallet': Icons.account_balance_wallet,
    'account_balance': Icons.account_balance,
    'credit_card': Icons.credit_card,
    'savings': Icons.savings,
    'payments': Icons.payments,
    'attach_money': Icons.attach_money,
    'trending_up': Icons.trending_up,
    'trending_down': Icons.trending_down,

    // Categories
    'restaurant': Icons.restaurant,
    'directions_car': Icons.directions_car,
    'home': Icons.home,
    'checkroom': Icons.checkroom,
    'favorite': Icons.favorite,
    'school': Icons.school,
    'sports_esports': Icons.sports_esports,
    'bolt': Icons.bolt,
    'business_center': Icons.business_center,
    'card_giftcard': Icons.card_giftcard,
    'more_horiz': Icons.more_horiz,
    'category': Icons.category,
    'shopping_cart': Icons.shopping_cart,
    'local_gas_station': Icons.local_gas_station,
    'phone': Icons.phone,
    'fitness_center': Icons.fitness_center,
    'flight': Icons.flight,
    'hotel': Icons.hotel,
    'pets': Icons.pets,
    'child_care': Icons.child_care,
    'celebration': Icons.celebration,
    'local_hospital': Icons.local_hospital,
    'work': Icons.work,
    'coffee': Icons.coffee,

    // UI
    'add': Icons.add,
    'edit': Icons.edit,
    'delete': Icons.delete,
    'search': Icons.search,
    'filter_list': Icons.filter_list,
  };

  static IconData get(String name) =>
      icons[name] ?? Icons.circle;

  static List<String> get allIconNames => icons.keys.toList();
}
